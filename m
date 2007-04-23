Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:44487 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbXDWEzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 00:55:33 -0400
Date: Sun, 22 Apr 2007 23:54:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add channel to scan results
Message-ID: <462c3c1f.8rt9VKvruWRkx5ts%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan results from mac80211 list only the frequency for any access
point found. This patch adds the channel to the output as well.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-dev/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c
+++ wireless-dev/net/mac80211/ieee80211_sta.c
@@ -2971,6 +2971,10 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = bss->channel;
+	iwe.u.freq.e = 0;
+	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
+					  IW_EV_FREQ_LEN);
 	iwe.u.freq.m = bss->freq * 100000;
 	iwe.u.freq.e = 1;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,

