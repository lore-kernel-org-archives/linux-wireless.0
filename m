Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B55BC282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 22:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C2A12084D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 22:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="ofkl9trX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfBJWW2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 17:22:28 -0500
Received: from 2.mo69.mail-out.ovh.net ([178.33.251.80]:35311 "EHLO
        2.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfBJWW2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 17:22:28 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 17:22:27 EST
Received: from player799.ha.ovh.net (unknown [10.109.143.220])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 0B7A03CEE4
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:47 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player799.ha.ovh.net (Postfix) with ESMTPSA id C3D1428E55B9;
        Sun, 10 Feb 2019 21:06:46 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832805;
        bh=NO41DDl3GTnJ18+e/1O8CJ9wuS8Z1/T4g3AHXOWnDN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ofkl9trXDs8522wzCaE886jRxt9+stmbgn7XyGIH46Qu0a0EiVrh8dAual6E+eG+5
         UAvLUACD8J41/NScltGuW2wO8zFtfCvzX4dkU/f110hTU7zq4qmPVU7sQZ22wPo5dm
         /IIGxmrxSs1uN/QmE3xa6zv0LZek33GohsZfTZhw=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 11/12] ath9k: Extended Key ID support (COMPAT)
Date:   Sun, 10 Feb 2019 22:06:19 +0100
Message-Id: <20190210210620.31181-12-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549400655444319431
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleehgdeiiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Implements %EXT_SET_KEY, %EXT_KEY_RX_TX and %EXT_DISABLE_KEY_RX and
enables EXT_KEY_ID_COMPAT.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

Like the generic ath patch to provide Extended Key ID support just the
minimum needed to get it working in AP mode and serve as an reference
how Compatibility Extended Key ID support looks like from a driver
perspective.

 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
 drivers/net/wireless/ath/ath9k/init.c         |  1 +
 drivers/net/wireless/ath/ath9k/main.c         | 20 ++++++++++++++++---
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a82ad739ab80..2708572616f2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1446,7 +1446,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath_key_config(common, vif, sta, key);
+		ret = ath_key_config(common, vif, sta, key, true);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c070a9e51ebf..ac1c6d59b954 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -929,6 +929,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
+	ieee80211_hw_set(hw, EXT_KEY_ID_COMPAT);
 
 	if (ath9k_ps_enable)
 		ieee80211_hw_set(hw, SUPPORTS_PS);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f23cb2f3d296..880687f09157 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1518,7 +1518,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
 		return 0;
 
-	key = ath_key_config(common, vif, sta, &ps_key);
+	key = ath_key_config(common, vif, sta, &ps_key, true);
 	if (key > 0) {
 		an->ps_key = key;
 		an->key_idx[0] = key;
@@ -1675,9 +1675,13 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = NULL;
 	int ret = 0, i;
+	bool rx_accel = true;
 
-	if (ath9k_modparam_nohwcrypt)
+	if (ath9k_modparam_nohwcrypt) {
+		if (cmd == EXT_DISABLE_KEY_RX || cmd == EXT_KEY_RX_TX)
+			return 0;
 		return -ENOSPC;
+	}
 
 	if ((vif->type == NL80211_IFTYPE_ADHOC ||
 	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
@@ -1701,12 +1705,15 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		an = (struct ath_node *)sta->drv_priv;
 
 	switch (cmd) {
+	case EXT_SET_KEY:
+		rx_accel = false;
+		/* Fall trough */
 	case SET_KEY:
 		if (sta)
 			ath9k_del_ps_key(sc, vif, sta);
 
 		key->hw_key_idx = 0;
-		ret = ath_key_config(common, vif, sta, key);
+		ret = ath_key_config(common, vif, sta, key, rx_accel);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
@@ -1740,6 +1747,13 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		}
 		key->hw_key_idx = 0;
 		break;
+	case EXT_DISABLE_KEY_RX:
+		rx_accel = false;
+		/* fall trough */
+	case EXT_KEY_RX_TX:
+		if (ath_hw_rx_crypt(common, key, sta, rx_accel))
+			ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.20.1

