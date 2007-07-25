Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21779 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758952AbXGYSwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 14:52:46 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [RFC/T] mac80211: Remove overly "sticky" averaging filters for rssi, signal, noise.
Date: Wed, 25 Jul 2007 11:52:43 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF001746239@orsmsx413.amr.corp.intel.com>
In-Reply-To: <4697C9DF.2030200@lwfinger.net>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Cc: "Jiri Benc" <jbenc@suse.cz>, <benmcahill@gmail.com>,
	<flamingice@sourmilk.net>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I like it without the filter just fine.

It might even be better "philosophically", because it does not impose
any particular filtering policy on the signal values, leaving it up to
user space apps to choose whether/how to filter them.

Did anyone else try it or have an opinion?

-- Ben -- 

> -----Original Message-----
> From: Larry Finger [mailto:larry.finger@lwfinger.net] 
> Sent: Friday, July 13, 2007 2:52 PM
> To: Cahill, Ben M
> Cc: Jiri Benc; benmcahill@gmail.com; flamingice@sourmilk.net; 
> linux-wireless@vger.kernel.org
> Subject: [RFC/T] mac80211: Remove overly "sticky" averaging 
> filters for rssi, signal, noise.
> 
> As has been discussed on the wireless list, the averaging in 
> the current version of mac80211 has a bug. This trial patch 
> is to see if removing averaging leads to wireless statistics 
> that are too jittery to be useful.
> 
> If you are using a mac80211-based driver, please test and 
> report your findings.
> 
> Thanks,
> 
> Larry
> ------ patch follows ------
> 
> The current version of wireless statistics contains a bug in 
> the averaging that makes the numbers be too sticky and not 
> react to small changes. This test patch removes all averaging 
> for testing if averaging is needed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-dev/net/mac80211/ieee80211.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/ieee80211.c
> +++ wireless-dev/net/mac80211/ieee80211.c
> @@ -3615,12 +3615,9 @@ ieee80211_rx_h_sta_process(struct ieee80
> 
>   	sta->rx_fragments++;
>   	sta->rx_bytes += rx->skb->len;
> -	sta->last_rssi = (sta->last_rssi * 15 +
> -			  rx->u.rx.status->ssi) / 16;
> -	sta->last_signal = (sta->last_signal * 15 +
> -			    rx->u.rx.status->signal) / 16;
> -	sta->last_noise = (sta->last_noise * 15 +
> -			   rx->u.rx.status->noise) / 16;
> +	sta->last_rssi = rx->u.rx.status->ssi;
> +	sta->last_signal = rx->u.rx.status->signal;
> +	sta->last_noise = rx->u.rx.status->noise;
> 
>   	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
>   		/* Change STA power saving mode only in the end 
> of a frame
> 
> 
> 
> ---
> 
