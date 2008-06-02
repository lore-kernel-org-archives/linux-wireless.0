Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbYFBMdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 08:33:08 -0400
Subject: [PATCH] mac80211: fix rate control initialisation
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <g1uicv$se6$1@ger.gmane.org>
References: <g1uicv$se6$1@ger.gmane.org>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 09:38:04 +0200
Message-Id: <1212392284.4148.7.camel@johannes.berg> (sfid-20080602_143313_035781_919AAFC2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39 ("mac80211: use rate
index in TX control") I forgot to initialise a few new variables to -1 which
means that the rate control algorithm is never triggered and 0 is used as
the only rate index, effectively fixing the transmit bitrate at the lowest
supported.

This patch adds the missing initialisation.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Bisected-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- everything.orig/net/mac80211/tx.c	2008-06-02 09:25:05.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-02 09:31:34.000000000 +0200
@@ -947,6 +947,8 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->local = local;
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	tx->channel = local->hw.conf.channel;
+	tx->rate_idx = -1;
+	tx->last_frag_rate_idx = -1;
 	/*
 	 * Set this flag (used below to indicate "automatic fragmentation"),
 	 * it will be cleared/left by radiotap as desired.


