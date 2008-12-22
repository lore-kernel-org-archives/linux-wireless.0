Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:46496 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYLVIwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 03:52:50 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: rtl8180: the network interface is not anymore created
Date: Mon, 22 Dec 2008 09:52:35 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <200812211710.23846.rossi.f@inwind.it> <494E852E.4070002@lwfinger.net>
In-Reply-To: <494E852E.4070002@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812220952.36063.rossi.f@inwind.it> (sfid-20081222_095253_109482_6BA03E12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Larry, now it works again!

Fabio

On Sunday 21 December 2008, Larry Finger wrote:

> Fabio Rossi wrote:
> > I was using successfully the rtl8180 driver but after last git-pull the
> > network interface (wlan0) is not anymore created.
> >
> > I have discovered the problem: there has been a change in mac80211,
> > commit 3fc7826b95521e40cf53f63437a5fdcc24e54ac4. The problem is that the
> > bit NL80211_IFTYPE_STATION is not set during the hardware initialization.
> >
> > I guess that the problem might be solved inserting the following line of
> > code
> >
> >     dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> >
> > somewhere in rtl8180_dev.c but I don't know which is the right point to
> > do so.
>
> Fabio,
>
> Does this patch fix it for you?
>
> Larry
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
> @@ -898,6 +898,7 @@ static int __devinit rtl8180_probe(struc
>  	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>  		     IEEE80211_HW_RX_INCLUDES_FCS |
>  		     IEEE80211_HW_SIGNAL_UNSPEC;
> +	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
>  	dev->queues = 1;
>  	dev->max_signal = 65;


