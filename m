Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr02-02.mta.terra.com.br ([200.154.152.31]:41063 "EHLO
	sr02-02.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYLUVNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 16:13:54 -0500
Message-ID: <494EB1A1.5080209@unitednerds.org> (sfid-20081221_221411_022493_C5AA2E8D)
Date: Sun, 21 Dec 2008 19:14:09 -0200
From: Piter PUNK <piterpunk@unitednerds.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Fabio Rossi <rossi.f@inwind.it>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: rtl8180: the network interface is not anymore created
References: <200812211710.23846.rossi.f@inwind.it> <494E852E.4070002@lwfinger.net>
In-Reply-To: <494E852E.4070002@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Fabio Rossi wrote:
>> I was using successfully the rtl8180 driver but after last git-pull the 
>> network interface (wlan0) is not anymore created.
> 
> Fabio,
> 
> Does this patch fix it for you?

I was with the same problem using linville branch (to test rtl8187se
support). I thought the wlan0 missing was some problem with the
rtl8187se support.

I apply the patch and now I have an wlan0 interface! -:)
I can't see now if the interface is really working, no AP near
to test. But the wlan0 now is created

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

Thanks!

Piter PUNK


