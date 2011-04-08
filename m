Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58944 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab1DHLoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 07:44:00 -0400
Received: by fxm17 with SMTP id 17so2269922fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 04:43:59 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH RFC 2/3] libertas: add set_power callback for iface subdrivers
Date: Fri, 8 Apr 2011 14:42:33 +0300
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <1302207960-28536-1-git-send-email-anarsoul@gmail.com> <1302207960-28536-3-git-send-email-anarsoul@gmail.com> <1302215732.17586.25.camel@dcbw.foobar.com>
In-Reply-To: <1302215732.17586.25.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104081442.33540.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 April 2011 01:35:31 Dan Williams wrote:
> > +	} else {
> > +		/* Copy addr back to hw */
> > +		memcpy(priv->current_addr, priv->dev->dev_addr, ETH_ALEN);
> > +		hw_addr_cmd.hdr.size = cpu_to_le16(sizeof(hw_addr_cmd));
> > +		hw_addr_cmd.action = cpu_to_le16(CMD_ACT_SET);
> > +		memcpy(hw_addr_cmd.macadd, priv->current_addr, ETH_ALEN);
> > +
> > +		ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS,
> > +			&hw_addr_cmd);
> > +		if (ret)
> > +			lbs_deb_net("set MAC address failed\n");
> 
> Might want to make a note here that this part is only used if the MAC
> was set while the card was powered down.

Ok

> > @@ -136,13 +205,14 @@ static int lbs_eth_stop(struct net_device *dev)
> > 
> >  	netif_stop_queue(dev);
> >  	spin_unlock_irq(&priv->driver_lock);
> > 
> > -	schedule_work(&priv->mcast_work);
> 
> Any reason this is getting removed?

It breaks powerdown, and I do not see a reason to do something with multicast 
here. Would be nice if someone can clarify why it's here.
 
> > +	lbs_power_off(priv);
> > +
> 
> So the idea here is that when the device is opened, the card powers up,
> but when it's closed, the card powers down?

Yep

> If that's the case, we can
> make mesh work with this too if you also call
> lbs_power_on()/lbs_power_off() from the mesh.c functions that open/close
> the mesh device, since power on/off is refcounted, essentially.

Can anyone explain what mesh is? How can I test it? (I have 2 devices with 
libertas wifi). Of course, I can add lbs_power_{on,off} to mesh.c functions, 
(and then we need to protect power_on_cnt with mutex)
 
> The thing that worries me here (and it's not your fault) is that there
> are 4 different and overlapping ways to do power saving with libertas:
> 
> 1) normal 802.11 power save (CMD_802_11_PS_MODE): independent of
> everything else

This one is broken at the time, right?
 
> 2) deep sleep + host sleep: SDIO-only for now, used by OLPC, but could
> be used by all bus types.  Bus remains powered unless the host sleeps
> too, and it requires bus-specific interaction (GPIO) to wake up the
> card.  Doesn't require a firmware reload because the card is still
> powered.

I can't use this one on my device, as I don't know gpio num that wakes card 
(and I'm not sure if there's such gpio at all).

> 3) bus sleep/power on bus power events: requires a firmware reload when
> the bus comes back because the bus and card aren't powered, triggered by
> some external suspend/resume mechanism
> 
> 4) bus sleep/power on dev open/close: same as #3 except the trigger is
> internal to the driver
> 
> and it's getting pretty complicated in the code...  You'll want to do
> any of [2, 3, 4] depending on your platform, so that's really the only
> difference.  I'd think that we'd want to enable the dev open/close power
> save stuff by default.
>
> We want deep sleep when we know that (a) the card will be powered
> despite the bus or host being unpowered, and that's a platform decision.
> I wonder if there's a better way to integrate all this stuff so it's
> less confusing in the code?

Deep sleep looks pretty much like power off, the only difference we do not 
need to upload fw to device/reconfigure it, so maybe we can unify them? I.e. 
use deep sleep if it's available in dev open/close, if it's not available - 
use set_power(), if nothing is available - do nothing. In suspend it makes 
sense to disable device at all if there's no WoL capability (or it's not 
implemented yet)

> Dan

Regards
Vasily
