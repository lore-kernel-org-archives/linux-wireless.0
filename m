Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab2DDOQk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 10:16:40 -0400
Date: Wed, 4 Apr 2012 16:15:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2 v2] rt2x00: configure different txdesc parameters for non
 HT channel
Message-ID: <20120404141532.GA14078@redhat.com> (sfid-20120404_161644_065160_BC686933)
References: <1333365666-4413-1-git-send-email-sgruszka@redhat.com>
 <CAGXE3d8C61rnWPgRU565n_FjjKTqk4pi9ncmdjxyAmEvVM-uvA@mail.gmail.com>
 <20120402123542.GA4567@redhat.com>
 <CAGXE3d_7ONx0=scmicYkvgjYM7ROYuHHNfNbO4xMJfmwM+rbrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d_7ONx0=scmicYkvgjYM7ROYuHHNfNbO4xMJfmwM+rbrA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed when we are concted to non 11n AP.

v1 -> v2: set correctly txdesc->u.ht.txop and txdesc->u.ht.mcs

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    1 +
 drivers/net/wireless/rt2x00/rt2x00config.c |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   26 ++++++++++++++++++--------
 3 files changed, 24 insertions(+), 8 deletions(-)

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
index 9b1b2b7..acd0133 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -320,14 +320,6 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		txdesc->u.ht.wcid = sta_priv->wcid;
 	}
 
-	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
-
-	/*
-	 * Only one STBC stream is supported for now.
-	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_STBC)
-		txdesc->u.ht.stbc = 1;
-
 	/*
 	 * If IEEE80211_TX_RC_MCS is set txrate->idx just contains the
 	 * mcs rate to be used
@@ -351,6 +343,24 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 			txdesc->u.ht.mcs |= 0x08;
 	}
 
+	if (test_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags)) {
+		if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
+			txdesc->u.ht.txop = TXOP_SIFS;
+		else
+			txdesc->u.ht.txop = TXOP_BACKOFF;
+
+		/* Left zero on all other settings. */
+		return;
+	}
+
+	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
+
+	/*
+	 * Only one STBC stream is supported for now.
+	 */
+	if (tx_info->flags & IEEE80211_TX_CTL_STBC)
+		txdesc->u.ht.stbc = 1;
+
 	/*
 	 * This frame is eligible for an AMPDU, however, don't aggregate
 	 * frames that are intended to probe a specific tx rate.
-- 
1.7.1

