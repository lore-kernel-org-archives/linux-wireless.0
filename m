Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34122 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935747AbcKKWFh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 17:05:37 -0500
Received: by mail-pg0-f51.google.com with SMTP id x23so14471048pgx.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Nov 2016 14:05:37 -0800 (PST)
Date: Fri, 11 Nov 2016 14:05:34 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH v2 3/3] mwifiex: Enable WoWLAN for both sdio and pcie
Message-ID: <20161111220530.GA142669@google.com> (sfid-20161111_230542_021559_5544F083)
References: <1478862911-15498-1-git-send-email-akarwar@marvell.com>
 <1478862911-15498-3-git-send-email-akarwar@marvell.com>
 <20161111204235.GB111624@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161111204235.GB111624@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

One correction to my review:

On Fri, Nov 11, 2016 at 12:42:36PM -0800, Brian Norris wrote:
> On Fri, Nov 11, 2016 at 04:45:11PM +0530, Amitkumar Karwar wrote:
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
> 
> This flag is unecessary and buggy. IIUC, you're trying to avoid calling
> disable_irq() in resume(), if you've called it here?
> 
> > +		disable_irq_nosync(irq);
> 
> ...but this is unnecessary, I think, unless you're trying to make up for
> buggy wakeup interrupts that keep firing? See my suggestion below.

I think I figured out some of the logic here, and my suggestion was
somewhat wrong. This 'wake_by_wifi' flag seems to be used here to assist
with the fact that we're requesting a level-triggered interrupt, but
the card doesn't deassert the interrupt until much later -- when we
finish the wakeup handshake.

So I guess it is necessary (or at least, expedient) to disable the
interrupt here.

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
> > +
> > +	ret = devm_request_irq(dev, adapter->irq_wakeup,
> > +			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
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
> > +	}
> > +	return;
> > +
> > +err_exit:
> > +	adapter->irq_wakeup = 0;
> >  }
> >  
> >  /*
> > diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> > index 0c07434..11abc49 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/main.h
> > +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> > @@ -1011,6 +1011,10 @@ struct mwifiex_adapter {
> >  	bool usb_mc_setup;
> >  	struct cfg80211_wowlan_nd_info *nd_info;
> >  	struct ieee80211_regdomain *regd;
> > +
> > +	/* Wake-on-WLAN (WoWLAN) */
> > +	int irq_wakeup;
> > +	bool wake_by_wifi;
> >  };
> >  
> >  void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
> > @@ -1410,6 +1414,27 @@ static inline u8 mwifiex_is_tdls_link_setup(u8 status)
> >  	return false;
> >  }
> >  
> > +/* Disable platform specific wakeup interrupt */
> > +static inline void mwifiex_disable_wake(struct mwifiex_adapter *adapter)
> > +{
> > +	if (adapter->irq_wakeup >= 0) {
> > +		disable_irq_wake(adapter->irq_wakeup);
> > +		if (!adapter->wake_by_wifi)
> 
> You're depending on the wake IRQ handler to set this flag, so you don't
> disable the IRQ twice (the calls nest). But what if the IRQ is being
> serviced concurrently with this? Then you'll double-disable the IRQ.
> 
> I believe you can just remove the disable_irq_nosync() from the handler,
> kill the above flag, and just unconditionally disable the IRQ.

So my suggestion here was wrong; we shouldn't completely kill the check
for ->wake_by_wifi I don't think, but we *should* wait for the interrupt
handler to complete before checking the flag. i.e., synchronize_irq():

diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 4063086ab5b8..e9446eeafb9d 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -841,6 +841,11 @@ void mwifiex_disable_wake(struct mwifiex_plt_wake_cfg *wake_cfg)
 {
 	if (wake_cfg && wake_cfg->irq_wifi >= 0) {
 		disable_irq_wake(wake_cfg->irq_wifi);
+		/*
+		 * Disable the wake IRQ only if it didn't already fire (and
+		 * disable itself).
+		 */
+		synchronize_irq(wake_cfg->irq_wifi);
 		if (!wake_cfg->wake_by_wifi)
 			disable_irq(wake_cfg->irq_wifi);
 	}

I'd appreciate if you bugfix this, either before or after this patch.

Brian

> > +			disable_irq(adapter->irq_wakeup);
> > +	}
> > +}
> > +
> > +/* Enable platform specific wakeup interrupt */
> > +static inline void mwifiex_enable_wake(struct mwifiex_adapter *adapter)
> > +{
> > +	/* Enable platform specific wakeup interrupt */
> > +	if (adapter->irq_wakeup >= 0) {
> > +		adapter->wake_by_wifi = false;
> > +		enable_irq(adapter->irq_wakeup);
> > +		enable_irq_wake(adapter->irq_wakeup);
> > +	}
> > +}
> > +
> >  int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
> >  			     u32 func_init_shutdown);
> >  int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8,
