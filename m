Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab2DBLWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 07:22:05 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] rt2x00: configure different txdesc parameters for non HT channel
Date: Mon,  2 Apr 2012 13:21:05 +0200
Message-Id: <1333365666-4413-1-git-send-email-sgruszka@redhat.com> (sfid-20120402_132211_529482_E9B73880)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed when we are concted to non 11n AP.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    1 +
 drivers/net/wireless/rt2x00/rt2x00config.c |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   14 ++++++++++++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 471f87c..8de9bfc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -692,6 +692,7 @@ enum rt2x00_state_flags {
 	 */
 	CONFIG_CHANNEL_HT40,
 	CONFIG_POWERSAVING,
+	CONFIG_HT_DISABLED,
 
 	/*
 	 * Mark we currently are sequentially reading TX_STA_FIFO register
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 293676b..e7361d9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -217,6 +217,11 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	libconf.conf = conf;
 
 	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL) {
+		if (!conf_is_ht(conf))
+			set_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags);
+		else
+			clear_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags);
+
 		if (conf_is_ht40(conf)) {
 			set_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags);
 			hw_value = rt2x00ht_center_channel(rt2x00dev, conf);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 9b1b2b7..f7403cf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -320,6 +320,20 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		txdesc->u.ht.wcid = sta_priv->wcid;
 	}
 
+	if (test_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags)) {
+		if (ieee80211_is_beacon(hdr->frame_control))
+			txdesc->u.ht.txop = TXOP_PIFS;
+		else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
+			txdesc->u.ht.txop = TXOP_SIFS;
+		else
+			txdesc->u.ht.txop = TXOP_BACKOFF;
+
+		txdesc->u.ht.mcs = txrate->idx;
+
+		/* Left zero on all other settings. */
+		return;
+	}
+
 	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
 
 	/*
-- 
1.7.1

