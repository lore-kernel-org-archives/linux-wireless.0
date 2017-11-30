Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33647 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751929AbdK3QdA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 11:33:00 -0500
Received: by mail-io0-f195.google.com with SMTP id t196so8176255iof.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Nov 2017 08:33:00 -0800 (PST)
Date: Thu, 30 Nov 2017 08:32:56 -0800
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        James Cao <jcao@marvell.com>
Subject: Re: Re: [PATCH 3/3] mwifiex: debugfs: trigger device dump for usb
 interface
Message-ID: <20171130163254.GA87129@google.com> (sfid-20171130_173304_898375_97CA35AF)
References: <a14a1d7b6c0a4c91a85be955a813ee14@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a14a1d7b6c0a4c91a85be955a813ee14@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On Wed, Nov 15, 2017 at 11:31:05AM +0000, Xinming Hu wrote:
> > -----Original Message-----
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > 
> > On Mon, Aug 14, 2017 at 12:19:03PM +0000, Xinming Hu wrote:
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c
> > > b/drivers/net/wireless/marvell/mwifiex/debugfs.c
> > > index 6f4239b..5d476de 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
> > > @@ -168,10 +168,11 @@
> > >  {
> > >  	struct mwifiex_private *priv = file->private_data;
> > >
> > > -	if (!priv->adapter->if_ops.device_dump)
> > > -		return -EIO;
> > > -
> > > -	priv->adapter->if_ops.device_dump(priv->adapter);
> > > +	if (priv->adapter->iface_type == MWIFIEX_USB)
> > > +		mwifiex_send_cmd(priv, HostCmd_CMD_FW_DUMP_EVENT,
> > > +				 HostCmd_ACT_GEN_SET, 0, NULL, true);
> > 
> > Why couldn't you just implement the device_dump() callback?
> 
> Currently mwifiex_send_cmd function is not exported to external modules, it is designed for module mwifiex internal use.

If you really don't want to export mwifiex_send_cmd(), you can export
some other wrapper which does the logic for you. The point is that
there's a well defined point for determining how to dump the firmware
based on which interface you're using. You should use it.

> If we export mwifiex_send_cmd, and call it in mwifiex_usb. There will be a loop,

So? There are all sorts of interdependencies between mwifiex.ko and
mwifiex_usb.ko (or in your words, "loops").

> .Device_dump (module mwifiex_usb)  -->  mwifiex_send_cmd(module mwifiex)  --> .host_to_card (module mwifiex_usb)
> 
> This seems not an elegant design, right?

No less elegant than scattering:

	if (!USB)
		driver->this();
	else
		that();

all over the place.

> Regards,
> Simon
> > 
> > > +	else
> > > +		priv->adapter->if_ops.device_dump(priv->adapter);
> > >
> > >  	return 0;
> > >  }

Brian
