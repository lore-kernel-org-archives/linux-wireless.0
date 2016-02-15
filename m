Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:58347
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbcBONf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 08:35:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/3] cfg80211: stop critical protocol session upon disconnect event
Date: Mon, 15 Feb 2016 14:35:53 +0100
Message-Id: <1455543353-20311-4-git-send-email-arend@broadcom.com> (sfid-20160215_181517_781049_8446E1C5)
In-Reply-To: <1455543353-20311-1-git-send-email-arend@broadcom.com>
References: <1455543353-20311-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When user-space has started a critical protocol session and a disconnect
event occurs, the rdev::crit_prot_nlportid remains set. This caused a
subsequent NL80211_CMD_CRIT_PROTO_START to fail (-EBUSY). Fix this by
clearing the rdev attribute and call .crit_proto_stop() callback upon
disconnect event.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 net/wireless/sme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 79bd3a1..5445581 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -917,6 +917,12 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);
 
+	/* stop critical protocol if supported */
+	if (rdev->ops->crit_proto_stop && rdev->crit_proto_nlportid) {
+		rdev->crit_proto_nlportid = 0;
+		rdev_crit_proto_stop(rdev, wdev);
+	}
+
 	/*
 	 * Delete all the keys ... pairwise keys can't really
 	 * exist any more anyway, but default keys might.
-- 
1.9.1

