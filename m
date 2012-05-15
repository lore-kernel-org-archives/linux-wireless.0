Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42523 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918Ab2EONjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:39:10 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so2485267wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:39:09 -0700 (PDT)
Date: Tue, 15 May 2012 15:38:59 +0200 (CEST)
From: Holger Schurig <holgerschurig@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: send beacon loss events to userspace
Message-ID: <alpine.DEB.2.02.1205151537180.28213@desktop.schurig.dlog.com> (sfid-20120515_153913_591537_EE0F4A7B)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send beacon loss events to userspace, so it will be
able to initiate roaming before disconnection

Signed-off-by: Holger Schurig <holgerschurig@googlemail.com>
---

depends on "nl80211: add new rssi event to indicate beacon loss".


Index: compat-wireless-2012-05-08/net/mac80211/mlme.c
===================================================================
--- compat-wireless-2012-05-08.orig/net/mac80211/mlme.c	2012-05-08 22:13:05.000000000 +0200
+++ compat-wireless-2012-05-08/net/mac80211/mlme.c	2012-05-15 15:09:46.664789656 +0200
@@ -1571,6 +1571,8 @@
  		printk(KERN_DEBUG "%s: detected beacon loss from AP "
  		       "- sending probe request\n", sdata->name);
  #endif
+	ieee80211_cqm_rssi_notify(&sdata->vif,
+		NL80211_CQM_RSSI_BEACON_LOSS_EVENT, GFP_KERNEL);

  	/*
  	 * The driver/our work has already reported this event or the
