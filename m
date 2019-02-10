Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CB6C282D7
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2FD621736
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:06:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="gkazHbhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBJVGv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:06:51 -0500
Received: from 7.mo173.mail-out.ovh.net ([46.105.44.159]:47867 "EHLO
        7.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfBJVGu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:06:50 -0500
Received: from player773.ha.ovh.net (unknown [10.109.146.53])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 094DEF25DB
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:48 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player773.ha.ovh.net (Postfix) with ESMTPSA id C23CA28D1975;
        Sun, 10 Feb 2019 21:06:46 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832805;
        bh=0f8g4ivAGpWqdoKdp67l1sOeBpI5mjFB0kN78tnmcq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=gkazHbhGTTVBSQADrCSWX0s0oTliO3CMwjdVt/1e/bHitOk71BhmVKBu3KAHNPLoi
         kO4vFfLj3XbCLmGBDzwGCIkZ9B1VD3oBo5z+eAa+DgscKT/WYqvMRfuTdq/JLZGXTy
         k4QQRn+c9DBMYO+jcz2bFtoNoLaK0TJISU+hJHmc=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 09/12] ath: Basic Extended Key ID support (COMPAT+NATIVE)
Date:   Sun, 10 Feb 2019 22:06:17 +0100
Message-Id: <20190210210620.31181-10-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549400653095443655
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleeggddvlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extend the shared ath key cache code to support Extended Key ID.

The key cache code has to accept unicast keys to use key idx 1 and allow
drivers to enable/disable hardware Rx decryption for a key independent
from Tx.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

I know this is the wrong audience to discuss ath drivers. It's only
included here as an example and POC that the Compatibility Extended Key
ID means for drivers.
This has so far only got the minimal attention needed to get it working
for my AP used for tests. The idea is, to discuss that with the proper
audience once we know what mac80211 Extended Key ID support will look
like.

 drivers/net/wireless/ath/ath.h |  7 ++++++-
 drivers/net/wireless/ath/key.c | 35 +++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index cc45ccfea5af..465629448fdf 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -202,8 +202,13 @@ void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
 int ath_key_config(struct ath_common *common,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
-			  struct ieee80211_key_conf *key);
+			  struct ieee80211_key_conf *key,
+			  bool rx_accel);
 bool ath_hw_keyreset(struct ath_common *common, u16 entry);
+bool ath_hw_rx_crypt(struct ath_common *common,
+		     struct ieee80211_key_conf *key,
+		     struct ieee80211_sta *sta,
+		     bool rx_accel);
 void ath_hw_cycle_counters_update(struct ath_common *common);
 int32_t ath_hw_get_listen_time(struct ath_common *common);
 
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 689fab9acf10..ced1c89102ad 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -126,6 +126,23 @@ static bool ath_hw_keysetmac(struct ath_common *common,
 	return true;
 }
 
+bool ath_hw_rx_crypt(struct ath_common *common,
+		     struct ieee80211_key_conf *key,
+		     struct ieee80211_sta *sta,
+		     bool rx_accel)
+{
+	const u8 *mac = NULL;
+
+	if (!sta || !test_bit(key->hw_key_idx, common->keymap))
+		return false;
+
+	if (rx_accel)
+		mac = sta->addr;
+
+	return ath_hw_keysetmac(common, key->hw_key_idx, mac);
+}
+EXPORT_SYMBOL(ath_hw_rx_crypt);
+
 static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 				      const struct ath_keyval *k,
 				      const u8 *mac)
@@ -473,7 +490,8 @@ static int ath_reserve_key_cache_slot(struct ath_common *common,
 int ath_key_config(struct ath_common *common,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
-			  struct ieee80211_key_conf *key)
+			  struct ieee80211_key_conf *key,
+			  bool rx_accel)
 {
 	struct ath_keyval hk;
 	const u8 *mac = NULL;
@@ -527,21 +545,28 @@ int ath_key_config(struct ath_common *common,
 			idx = key->keyidx;
 			break;
 		}
-	} else if (key->keyidx) {
+	} else if (key->keyidx > 1) {
 		if (WARN_ON(!sta))
 			return -EOPNOTSUPP;
 		mac = sta->addr;
 
 		if (vif->type != NL80211_IFTYPE_AP) {
-			/* Only keyidx 0 should be used with unicast key, but
-			 * allow this for client mode for now. */
+			/* Only keyidx 0 and when using Extended Key ID 1 should
+			 * be used with a unicast key. But allow this for client
+			 * mode for now.
+			 */
 			idx = key->keyidx;
 		} else
 			return -EIO;
 	} else {
 		if (WARN_ON(!sta))
 			return -EOPNOTSUPP;
-		mac = sta->addr;
+
+		/* Handle sta Tx only keys like GTK keys for now */
+		if (rx_accel)
+			mac = sta->addr;
+		else
+			mac = NULL;
 
 		idx = ath_reserve_key_cache_slot(common, key->cipher);
 	}
-- 
2.20.1

