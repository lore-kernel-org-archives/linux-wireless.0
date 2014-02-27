Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaB0Qko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:40:44 -0500
Message-ID: <1393519239.4648.8.camel@jlt4.sipsolutions.net> (sfid-20140227_174049_081469_7CEA4DDD)
Subject: Re: mac80211: double processing of probe response frames ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Feb 2014 17:40:39 +0100
In-Reply-To: <000c01cf3312$b8131540$28393fc0$@acksys.fr> (sfid-20140226_194231_040116_EB122CE8)
References: <000c01cf3312$b8131540$28393fc0$@acksys.fr>
	 (sfid-20140226_194231_040116_EB122CE8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-26 at 17:49 +0100, Jean-Pierre Tosoni wrote:
> Hi all,
> 
> I am using mac80211 and ath9k.
> I put a debug trace in the net/wireless/scan.c, in
> cfg80211_inform_bss_frame().
> I exercise scanning with wpa_supplicant and I monitor the air with
> wireshark/airpcapN.
> Each time a probe response frame is received, I can see that
> cfg80211_inform_bss_frame() is called *twice.*
> 
> I wonder if this is really needed ? Is it possible to remove one of the
> calls ?
> 
> AFAICT, mac80211/scan.c/ieee80211_bss_info_update() is called along two
> paths,
> 1) in mac80211/rx.c, from __ieee80211_rx_handle_packet() and
> ieee80211_scan_rx() 
> 2) in mac80211/mlme.c, from the work queue calling
> ieee80211_sta_rx_queued_mgmt()
>     => ieee80211_rx_mgmt_probe_resp() => ieee80211_rx_bss_info()
> 
> Maybe part of the call to ieee80211_scan_rx() could be delayed and merged
> later when ieee80211_rx_mgmt_probe_resp() is called ? Any comments ?

Not easily - the latter call is very much filtered. However, the
scan_rx() one should only do something during scan, I believe, and the
other *not* during scan?

johannes

