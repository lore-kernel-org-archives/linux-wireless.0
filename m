Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E90449B3C
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428513; cv=none; b=Iz6L+KJdG9n+QswwDrkm15FUkpAbCxIvXE6drXpERZU3kRFu0Tu16T0fzopnu968tBppCZ/2a96tFoqHNuFOQiR6SbwQ19iyPSWe0NFvfT03RGJvoBwIoPrs0WLpWlEVK4LFY1BiO8mkHJzbZ1aGcm0h0f3Dd141TqnUGLxPg5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428513; c=relaxed/simple;
	bh=ubYEXsR4tEV0OYeMr1Q2ItQdS8K2QO1zmn+B8cI/9Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPezChn8nOU2IkzMh8fWU5rerV9ZrK2oTPwoRVOZaXLNPzAfYT/R2pFDT/VruOCaNdMM66merGAqt6lu+pMLkUemwxorPYHp4vmV/3rxcDlWGuRT6MPyvfJ1MUmUTZYhv3Yidkv3ENXO92DWPwLFlY41q2gRypQnWSf4WlebSEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c4YdsJ6N; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4YdsJ6N"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3856d4015e0so8789a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428511; x=1786033311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NRB/SiR0fGbZN5o58GOzDdPoMAH3MpfMvsmzOVQc0i8=;
        b=c4YdsJ6N7YT5yXMh/hOomV2pREUopS8GXLVQWnu2oCFB2BH9GKLZ54hocGLw9CHvRi
         6VDWOt7DyMMjJbEQdC627kUBT/r6a9fwNllSCFIZJBjIkyHQPMnOwDp+tmO9xJt2P93X
         YMVj7Ma2zX/EPP1RI3nt8JzGzxIdVsKfba40NlB/xV4QHdZ3FjMXeH9JShnqPbounzb7
         bnm1JrKZUcJZNJwoEKJqNPNESlGZg4rV4AeG92lqCbag+/G+EdvQKwJkfE4Waew3t6KJ
         DBqUbiQ51VtiIvOPes0SqfmAauPT4AtkYvHgJEr1qRDskLpKlAs9i3jiHTNypnlFXLAT
         kniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428511; x=1786033311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NRB/SiR0fGbZN5o58GOzDdPoMAH3MpfMvsmzOVQc0i8=;
        b=KjZo4jfgG9aaeXcArLb0tqulvpp0cidzW6FxGFJjKmbPzlemF3bg/jqdglPxhu6BS4
         gF5bGaKuKO1r1HZym0HVmLjnBMmAioM4aBWsrvtyRl7rpsAoipu8ATgdWUChtTdIj71l
         yuTmjuDEv/KdO3mfIg4NYB3g7EHgEcYspoCzT92TEMGSkMc9iDlrsDevxkUhs4y4MFhN
         nQNxLfA3Fa0zdMdr48ylGAHkxWTtMhAW1gZbEC9ehk7KhVOAOEMhGRhhE107Ge68tFvz
         CKuoEw+MSiznrPpPt1CJzQ64xaPibmjc7q7JbMJ1mcYwVmp7yR0Ll84mNzwaruzgMUx2
         6X0Q==
X-Gm-Message-State: AOJu0YysEs3wNxsQOJHiiPTQrzQa+WsIz5/Q87eosHGMsJE2+nELTLHE
	olTZ9VMEyNxD6330dlv1R34Se08YNb6t9h17aJd58y6b3sGtlBbFrKfh
X-Gm-Gg: AR+sD10CdpZI7606e6NBH+axF4HisWrmL78n5dciQ6rBUy+qXvlFo81SeUkzGz9bEAy
	ZUbN2dIXmVzb00CaBlbVMdeSM+SHiVy+qhasvIDLsWQpafLpYGl/r9sz/CHaZjMh8CGFjaWMT5i
	7wFhzthho7XMx1w4g3jhTnzgntFiFDTUmoYG75+nU3ZemPHMFfUFOpDCeccl1pj88MVB7T05BJ/
	1uEq4TSwgJ+dxcbkSIwUpbXO28pvAoikNeWNWLSvZC0UlQ7+Klld8lvLPV14mQs38amaxJiKmn7
	MUiLmMt8sAFv2Yr9/XbOdokJtEg3LKCtUxTbMRi1An0yTL0abKTEWcw2cj30bJrIGJNXOvxYNxx
	8qyYyRzzKdl6ABAAasknOiL4JGENG6FX/scQIOZi3B/ghVl0sPjEfRRSYIqfDrlJIFLihnmKMTs
	krMCTlP6SegtBEpPYAjOHSU057mSDWxUQNdliAEzBt8gnUx309cr9WbL012O26nQSM78VNGtZYX
	p0=
X-Received: by 2002:a17:90b:4c0f:b0:38e:91a8:fb85 with SMTP id 98e67ed59e1d1-38fa8200471mr765335a91.3.1785428511324;
        Thu, 30 Jul 2026 09:21:51 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7275973dsm19964269c88.15.2026.07.30.09.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:21:50 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v2 4/8] wifi: brcmfmac: cfg80211: implement PMKID_V2 and fix delay busy-wait
Date: Thu, 30 Jul 2026 16:21:07 +0000
Message-ID: <20260730162135.12278-4-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730162135.12278-1-shivesh@example.com>
References: <20260730162135.12278-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Implements PMKID_V2 for FILS fast-roaming support instead of falling
through to the V1 path. Additionally replaces a harmful mdelay() busy-wait
in brcmf_delay with usleep_range() to prevent CPU stalls.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 118 ++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |   4 +-
 2 files changed, 110 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 0b55d445895f..7d7e5ececd22 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3989,12 +3989,10 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 
 static __always_inline void brcmf_delay(u32 ms)
 {
-	if (ms < 1000 / HZ) {
-		cond_resched();
-		mdelay(ms);
-	} else {
+	if (ms <= 20)
+		usleep_range(ms * 1000, ms * 1000 + 1000);
+	else
 		msleep(ms);
-	}
 }
 
 static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
@@ -4364,6 +4362,104 @@ brcmf_pmksa_v3_op(struct brcmf_if *ifp, struct cfg80211_pmksa *pmksa,
 	return ret;
 }
 
+/**
+ * brcmf_pmksa_v2_op - update firmware PMKSA cache using the V2 list interface.
+ *
+ * V2 firmware (revision 12) uses a versioned flat list structure
+ * (brcmf_pmk_list_v2_le) rather than the per-entry operation model of V3.
+ * Each entry carries FILS-specific fields (raw PMK material, SSID, and
+ * fils_cache_id) in addition to the basic BSSID + PMKID pair, enabling
+ * FILS fast-roaming on devices that do not support V3.
+ *
+ * @cfg:   driver config structure holding the shadow V2 PMKSA list
+ * @ifp:   interface pointer
+ * @pmksa: the PMKSA to add/remove, or NULL for a flush
+ * @alive: true = add (set time_left to no-expiry), false = remove/flush
+ */
+static s32
+brcmf_pmksa_v2_op(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
+		  struct cfg80211_pmksa *pmksa, bool alive)
+{
+	struct brcmf_pub *drvr = cfg->pub;
+	struct brcmf_pmk_list_v2_le *list = &cfg->pmk_list_v2;
+	struct brcmf_pmksa_v2 *pmk = list->pmk;
+	u32 npmk = le16_to_cpu(list->length);
+	u32 i;
+
+	/* npmk here stores the count of valid entries, repurposing the
+	 * length field of the shadow list as a counter.  We convert to
+	 * the wire format (byte length) when sending to firmware.
+	 */
+	if (!pmksa) {
+		/* Flush: zero the shadow list and push an empty V2 list. */
+		memset(list, 0, sizeof(*list));
+		goto send;
+	}
+
+	if (alive) {
+		/* Set: search for existing BSSID match first. */
+		for (i = 0; i < npmk; i++)
+			if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
+				break;
+
+		if (i >= BRCMF_MAXPMKID) {
+			bphy_err(drvr, "V2 PMKSA cache full (%d entries)\n",
+				 npmk);
+			return -EINVAL;
+		}
+
+		memset(&pmk[i], 0, sizeof(pmk[i]));
+		pmk[i].length = cpu_to_le16(sizeof(struct brcmf_pmksa_v2));
+		if (pmksa->bssid)
+			memcpy(pmk[i].bssid, pmksa->bssid, ETH_ALEN);
+		if (pmksa->pmkid)
+			memcpy(pmk[i].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+		if (pmksa->pmk && pmksa->pmk_len &&
+		    pmksa->pmk_len <= WLAN_PMK_LEN_SUITE_B_192) {
+			memcpy(pmk[i].pmk, pmksa->pmk, pmksa->pmk_len);
+			pmk[i].pmk_len = cpu_to_le16(pmksa->pmk_len);
+		}
+		if (pmksa->ssid && pmksa->ssid_len) {
+			memcpy(pmk[i].ssid.SSID, pmksa->ssid, pmksa->ssid_len);
+			pmk[i].ssid.SSID_len = pmksa->ssid_len;
+		}
+		if (pmksa->fils_cache_id)
+			pmk[i].fils_cache_id = *pmksa->fils_cache_id;
+
+		if (i == npmk)
+			npmk++;
+	} else {
+		/* Delete: find by BSSID and compact the list. */
+		for (i = 0; i < npmk; i++)
+			if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
+				break;
+
+		if (i >= npmk) {
+			bphy_err(drvr, "V2 PMKSA entry not found\n");
+			return -EINVAL;
+		}
+
+		for (; i < npmk - 1; i++)
+			memcpy(&pmk[i], &pmk[i + 1], sizeof(pmk[i]));
+		memset(&pmk[npmk - 1], 0, sizeof(pmk[npmk - 1]));
+		npmk--;
+	}
+
+	/* Update shadow entry count (stored in length field). */
+	list->length = cpu_to_le16(npmk);
+
+send:
+	/* Build the wire-format header and send the full list to firmware.
+	 * version and length on the wire reflect the actual byte footprint.
+	 */
+	list->version = cpu_to_le16(BRCMF_PMKSA_VER_2);
+	list->length  = cpu_to_le16(offsetof(struct brcmf_pmk_list_v2_le, pmk) +
+				   npmk * sizeof(struct brcmf_pmksa_v2));
+
+	return brcmf_fil_iovar_data_set(ifp, "pmkid_info", list, sizeof(*list));
+}
+
+
 static __used s32
 brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 {
@@ -4402,8 +4498,8 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
 		return brcmf_pmksa_v3_op(ifp, pmksa, true);
-
-	/* TODO: implement PMKID_V2 */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
+		return brcmf_pmksa_v2_op(cfg, ifp, pmksa, true);
 
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
@@ -4446,8 +4542,8 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
 		return brcmf_pmksa_v3_op(ifp, pmksa, false);
-
-	/* TODO: implement PMKID_V2 */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
+		return brcmf_pmksa_v2_op(cfg, ifp, pmksa, false);
 
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
@@ -4487,8 +4583,8 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
 		return brcmf_pmksa_v3_op(ifp, NULL, false);
-
-	/* TODO: implement PMKID_V2 */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
+		return brcmf_pmksa_v2_op(cfg, ifp, NULL, false);
 
 	memset(&cfg->pmk_list, 0, sizeof(cfg->pmk_list));
 	err = brcmf_update_pmklist(cfg, ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 6ceb30142905..57167fde5ba1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -344,7 +344,8 @@ struct brcmf_cfg80211_wowl {
  * @bss_list: bss_list holding scanned ap information.
  * @bss_info: bss information for cfg80211 layer.
  * @conn_info: association info.
- * @pmk_list: wpa2 pmk list.
+ * @pmk_list: wpa2 pmk list (V1 firmware).
+ * @pmk_list_v2: wpa2 pmk list for V2 firmware (FILS-capable, firmware rev 12).
  * @scan_status: scan activity on the dongle.
  * @pub: common driver information.
  * @channel: current channel.
@@ -376,6 +377,7 @@ struct brcmf_cfg80211_info {
 	struct wl_cfg80211_bss_info *bss_info;
 	struct brcmf_cfg80211_connect_info conn_info;
 	struct brcmf_pmk_list_le pmk_list;
+	struct brcmf_pmk_list_v2_le pmk_list_v2;
 	unsigned long scan_status;
 	struct brcmf_pub *pub;
 	u32 channel;
-- 
2.53.0

