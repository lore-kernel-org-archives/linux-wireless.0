Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2E1Jx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 05:53:56 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] rt2x00: claim RSN IBSS support
Date: Mon, 28 May 2012 11:53:11 +0200
Message-Id: <1338198791-21643-1-git-send-email-sgruszka@redhat.com> (sfid-20120528_115402_849814_F539ED5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar like other drivers, do not configure group keys to the hardware
(on Ad-Hoc mode) to make IBSS RSN work.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e5404e5..a6b88bd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1161,6 +1161,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		    BIT(NL80211_IFTYPE_MESH_POINT) |
 		    BIT(NL80211_IFTYPE_WDS);
 
+	rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+
 	/*
 	 * Initialize work.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index b49773e..ef8b984 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -507,9 +507,19 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return 0;
-	else if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags))
+
+	if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags))
+		return -EOPNOTSUPP;
+
+	/*
+	 * To support IBSS RSN, don't program group keys in IBSS, the
+	 * hardware will then not attempt to decrypt the frames.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -EOPNOTSUPP;
-	else if (key->keylen > 32)
+
+	if (key->keylen > 32)
 		return -ENOSPC;
 
 	memset(&crypto, 0, sizeof(crypto));
-- 
1.7.1

