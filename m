Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:34901 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936594AbcKOSQw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 13:16:52 -0500
Received: by mail-pg0-f45.google.com with SMTP id p66so69162761pga.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 10:16:52 -0800 (PST)
Date: Tue, 15 Nov 2016 10:16:49 -0800
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com
Subject: Re: [PATCH v4 3/3] mwifiex: Enable WoWLAN for both sdio and pcie
Message-ID: <20161115181648.GA121911@google.com> (sfid-20161115_191656_963288_CF06069A)
References: <1479216964-3328-1-git-send-email-akarwar@marvell.com>
 <1479216964-3328-3-git-send-email-akarwar@marvell.com>
 <20161115173507.GB22897@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161115173507.GB22897@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 15, 2016 at 09:35:07AM -0800, Dmitry Torokhov wrote:
> On Tue, Nov 15, 2016 at 07:06:04PM +0530, Amitkumar Karwar wrote:
> > --- a/drivers/net/wireless/marvell/mwifiex/main.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> > @@ -1552,14 +1552,55 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
> >  }
> >  EXPORT_SYMBOL_GPL(mwifiex_do_flr);
> >  
> > +static irqreturn_t mwifiex_irq_wakeup_handler(int irq, void *priv)
> > +{
> > +	struct mwifiex_adapter *adapter = priv;
> > +
> > +	if (adapter->irq_wakeup >= 0) {
> > +		dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
> > +		adapter->wake_by_wifi = true;
> > +		disable_irq_nosync(irq);
> > +	}
> > +
> > +	/* Notify PM core we are wakeup source */
> > +	pm_wakeup_event(adapter->dev, 0);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> >  static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
> >  {
> > +	int ret;
> >  	struct device *dev = adapter->dev;
> >  
> >  	if (!dev->of_node)
> >  		return;
> >  
> >  	adapter->dt_node = dev->of_node;
> > +	adapter->irq_wakeup = irq_of_parse_and_map(adapter->dt_node, 0);
> > +	if (!adapter->irq_wakeup) {
> > +		dev_info(dev, "fail to parse irq_wakeup from device tree\n");
> > +		return;
> > +	}
> 
> I'd rather we used of_irq_get() here, because ti allows handling
> deferrals. of_irq_get_byname() would be even better, but I guess we
> already have bindings in the wild...

This function doesn't handle errors very gracefully at all; we just try,
and if we fail, we just skip the rest...

This could be an argument for rewriting the error handling to stop just
returning -1 in mwifiex_add_card() and use real Linux error codes.
Perhaps that can be a later cleanup?

> > +
> > +	ret = devm_request_irq(dev, adapter->irq_wakeup,
> > +			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
> 
> irq_of_parse_and_map() (and of_irq_get()) will set trigger flags,
> why do we override them?
> 
> > +			       "wifi_wake", adapter);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to request irq_wakeup %d (%d)\n",
> > +			adapter->irq_wakeup, ret);
> > +		goto err_exit;
> > +	}
> > +
> > +	disable_irq(adapter->irq_wakeup);
> > +	if (device_init_wakeup(dev, true)) {
> > +		dev_err(dev, "fail to init wakeup for mwifiex\n");
> > +		goto err_exit;
> 
> Leaking interrupt (not forever, but if we are not using wakeup irq there
> is no need to have it claimed).
> 
> > +	}
> > +	return;
> > +
> > +err_exit:
> > +	adapter->irq_wakeup = 0;
> >  }
> 
> I also do not see anyone actually calling mwifiex_probe_of() in this
> patch?

It was added to mwifiex_add_card() in the previous patch, so all users
with a proper ->dt_node would call it.

> >  
> >  /*

Brian
