Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57709 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZGaQQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:16:44 -0400
Received: by ewy10 with SMTP id 10so1624492ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 09:16:43 -0700 (PDT)
Message-ID: <4A7318E6.3000004@gmail.com>
Date: Fri, 31 Jul 2009 18:16:38 +0200
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Igor Perminov <igor.perminov@inbox.ru>
CC: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: A station can't reconnect after it wakes up
References: <1248969930.29068.224.camel@sunlight>
In-Reply-To: <1248969930.29068.224.camel@sunlight>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[linux-wireless added to cc list]

Igor Perminov wrote:
> I have an issue related to handling power-saving stations by hostapd
> and/or mac80211 stack. A station can't reconnect after it wakes up.
> 
> The problems looks similar to another one having been reported to this
> list earlier (STA can connect, but fails to reconnect within
> ap_max_inactivity):
> http://lists.shmoo.com/pipermail/hostap/2009-February/019192.html
> 
> AP: Linux box with D-Link DWA-110 USB Wi-Fi stick (rt73usb kernel
> driver), kernel 2.6.30 with some patches, hostapd 0.6.9.
> Station: Toshiba G900 PDA under Windows Mobile 6.0.
> 
> The environment is described in details here:
> http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5486&start=10
> 
> Consider the following step-by-step:
> 1. A station authenticates and associates with the AP and exchanges
> traffic.
> 2. The station indicates to the AP that it is going to sleep.
> 3. The station device goes to the stand-by mode (not only its wi-fi
> card, but the device itself).
> 4. The station device wakes up and begins authentication with an
> Authentication management frame.
> 
> This is the behavior of my PDA.
> 
> The problem is the mac80211 stack at the point 4 "remembers" that the
> station has gone to sleep. So, the response frames from hostapd are
> buffered by mac80211.
> The station indicates in the Authentication frame that it isn't sleeping
> anymore. But the mac80211 stack analyzes sleep/wake transitions in
> _data_ frames only, but not in management ones. See
> ieee80211_rx_h_sta_process in net/mac80211/rx.c. A comment there notes:
> "Ignore doze->wake transitions that are indicated by non-data frames,
> the standard is unclear here".
> As the result, the station never receives the authentication response
> from the AP.
> 
> One solution against this problem could be implemented in hostapd: to
> force the mac80211 stack to "forget" the station just after receiving an
> authentication frame (the patch is below). After this change the station
> can reconnect successfully.

i just did a quick test and your hostapd patch does indeed fix my problem
too (p54+hostapd with a winmobile device that couldn't reconnect after
turning the wifi module off and on). 

> Another solution (in theory) would be to improve the mac80211
> implementation: to analyze not only data frames, but also
> management ones (or may be just some kinds of them) in
> ieee80211_rx_h_sta_process.

would seem to make sense, but having not read the spec i have no idea
if that's the right answer; hence the linux-wireless cc...

> I've asked this question to the linux-wireless mailing list few days
> ago, but nobody has answered still:
> http://marc.info/?l=linux-wireless&m=124879549212741&w=2
> 
> And what is your opinion, what is a better way: should this problem be
> fixed in hostapd or in mac80211?
> 
> === Begin diff ===
> --- a/hostapd/ieee802_11.c	2009-06-29 14:21:59.000000000 +0400
> +++ b/hostapd/ieee802_11.c	2009-07-21 16:28:17.000000000 +0400
> @@ -583,6 +583,13 @@
>  		goto fail;
>  	}
>  
> +	res = hostapd_sta_remove(hapd, mgmt->sa);
> +	if (res) {
> +		wpa_printf(MSG_DEBUG, "authentication: STA=" MACSTR
> +				", hostapd_sta_remove returned %d\n",
> +				MAC2STR(mgmt->sa), res);
> +	}
> +
>  	if (vlan_id > 0) {
>  		if (hostapd_get_vlan_id_ifname(hapd->conf->vlan,
>  					       sta->vlan_id) == NULL) {
> === End diff ===

Thanks for the cc, added this to my local hostapd patch set, until the
issue gets resolved one way or another.

artur
