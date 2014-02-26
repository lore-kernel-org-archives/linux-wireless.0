Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:58461 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaBZSm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 13:42:27 -0500
Received: from smtp02.msg.oleane.net (smtp02.mail.priv [172.17.20.111])
	by smtp-out05.msg.oleane.net with ESMTP id s1QHA3nb031597
	for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 18:10:03 +0100
Received: from RD9 ([195.6.104.67]) (authenticated)
	by smtp02.msg.oleane.net (MSA) with ESMTP id s1QGnNRv004534
	for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 17:49:24 +0100
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Subject: mac80211: double processing of probe response frames ?
Date: Wed, 26 Feb 2014 17:49:30 +0100
Message-ID: <000c01cf3312$b8131540$28393fc0$@acksys.fr> (sfid-20140226_194231_040116_EB122CE8)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am using mac80211 and ath9k.
I put a debug trace in the net/wireless/scan.c, in
cfg80211_inform_bss_frame().
I exercise scanning with wpa_supplicant and I monitor the air with
wireshark/airpcapN.
Each time a probe response frame is received, I can see that
cfg80211_inform_bss_frame() is called *twice.*

I wonder if this is really needed ? Is it possible to remove one of the
calls ?

AFAICT, mac80211/scan.c/ieee80211_bss_info_update() is called along two
paths,
1) in mac80211/rx.c, from __ieee80211_rx_handle_packet() and
ieee80211_scan_rx() 
2) in mac80211/mlme.c, from the work queue calling
ieee80211_sta_rx_queued_mgmt()
    => ieee80211_rx_mgmt_probe_resp() => ieee80211_rx_bss_info()

Maybe part of the call to ieee80211_scan_rx() could be delayed and merged
later when ieee80211_rx_mgmt_probe_resp() is called ? Any comments ?

I am using compat-wireless-2013-04-16.

