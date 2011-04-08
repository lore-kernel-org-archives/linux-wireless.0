Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52404 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1DHLbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 07:31:38 -0400
Received: by bwz15 with SMTP id 15so2750209bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 04:31:37 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Alberto Panizzo <alberto@amarulasolutions.com>
Subject: Re: [PATCH RFC 2/3] libertas: add set_power callback for iface subdrivers
Date: Fri, 8 Apr 2011 14:30:10 +0300
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <1302207960-28536-1-git-send-email-anarsoul@gmail.com> <201104081236.54157.anarsoul@gmail.com> <1302258194.2649.94.camel@realization>
In-Reply-To: <1302258194.2649.94.camel@realization>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104081430.11248.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 April 2011 13:23:14 Alberto Panizzo wrote:
> On Fri, 2011-04-08 at 12:36 +0300, Vasily Khoruzhick wrote:
> > On Friday 08 April 2011 12:10:53 Alberto Panizzo wrote:
> > > > +	} else {
> > > > +		/* Copy addr back to hw */
> > > > +		memcpy(priv->current_addr, priv->dev->dev_addr, ETH_ALEN);
> > > > +		hw_addr_cmd.hdr.size = cpu_to_le16(sizeof(hw_addr_cmd));
> > > > +		hw_addr_cmd.action = cpu_to_le16(CMD_ACT_SET);
> > > > +		memcpy(hw_addr_cmd.macadd, priv->current_addr, ETH_ALEN);
> > > > +
> > > > +		ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS,
> > > > +			&hw_addr_cmd);
> > > > +		if (ret)
> > > > +			lbs_deb_net("set MAC address failed\n");
> > > 
> > > Does this be really related to the subject of the patch?
> > 
> > Yep, this function is called right after power on, and we have to copy
> > mac address back to hardware (in case it was changed).
> 
> So, are you assuming that someone can change the wifi card while this
> is powered off?

Nope, I assume someone can do 'ifconfig wlan0 hw ether xx:xx:xx:xx:xx:xx' 
while card is powered down. Or when it's powered up - we need then to load 
choosen mac into hw back after power cycle sequence.

> > Moved it to avoid forward declatation.
> 
> Mmm, personally I like more the forward declaration.. the moving do not
> allow readers if you have modified something in the function.

Depends on person, someone hates forward declarations, someone likes them. I 
have nothing against them, but most part of kernel maintainers do not like 
them for some reason.
 
> > In this place there's no iface yet (we're still in probe callback of
> > driver).
> > 
> > lbs_power_on/lbs_power_off are called only on iface up/down and in
> > suspend/resume handlers (at least, for now), so we can't get race
> > condition here.
> 
> Ok, I understand what you are doing. It's the same as removing the
> module when the interface is not used..

Not same, wlan0 is still here :)
 
> I think this driver needs a good documentation of software flows: You
> are adding a mechanism that is really useful for saving power while the
> wlan interface is not used. But this should not be the same as the
> policy this driver use through suspensions.

Hmm, driver is expected to disable hw or put it into powersaving mode in 
.ndo_stop(). It's already documented, isn't it?

> I know that at this moment, this driver is not managing Power Save very
> well and ok, this allow you to give up and turn off the card during
> suspension.

Host goes suspend (i.e. bus is not active anymore), and there's no way to put 
device into deep sleep mode in some cases (I'm not sure if gpio to wake card 
wired somewhere on my device :)), so looks like there's no choice.

> Look for "CMD_802_11_HOST_SLEEP_CFG pdf" in google, you will be excited
> on the results..!

Thanks, will take a look on fw datasheet.

Regards
Vasily
