Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/11] ath9k: move ATH_AMPDU_LIMIT_MAX to hw.h
Date: Mon, 14 Sep 2009 04:37:24 -0400
Message-Id: <1252917448-10744-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used by hw code.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/hw.h    |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 73c2ac5..f3b5a60 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -189,7 +189,6 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 /* minimum h/w qdepth to be sustained to maximize aggregation */
 #define ATH_AGGR_MIN_QDEPTH        2
 #define ATH_AMPDU_SUBFRAME_DEFAULT 32
-#define ATH_AMPDU_LIMIT_MAX        (64 * 1024 - 1)
 
 #define IEEE80211_SEQ_SEQ_SHIFT    4
 #define IEEE80211_SEQ_MAX          4096
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e2b6bce..047b5b8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -51,6 +51,8 @@
 #define AT9285_COEX3WIRE_SA_SUBSYSID	0x30aa
 #define AT9285_COEX3WIRE_DA_SUBSYSID	0x30ab
 
+#define ATH_AMPDU_LIMIT_MAX        (64 * 1024 - 1)
+
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
 	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
-- 
1.6.3.3

