Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75045FFDD
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427483; cv=none; b=tU2BjXZ18EiLaWfd3KS2i3zeMPmpmWrc9NlQjLTaRX5o6kAHHqV6msSIdF+lLddm+JWbdNzzoAgoxPEvwK3iK7/hNSsfQh/LbVUyY0WanJfUAbci1TUkM+9OVO4gb4OPpPUyydzHCSTyqiwPfqHuvwjyu6Jvhy8inkOT9T/Bh9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427483; c=relaxed/simple;
	bh=2/xzd7pwxzvKAQzcQP6eUvsOWiHqVVYplGHUqC9o+AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kklnwn7hZeWxg283vN533Kk2zyxiVuSAyA+IPqaKc3DjyvvReM/DEgixVWjYfual11FbTU/iUu3UKJzVzElOtrgodh3psOXAHGUDE9DoQoPsjZgOGFagLZDFwo1pBDN07QUkHuafXAblv7xNe4+Qab6JZTor5tkF8txBYLLYFYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rDUpJv4j; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDUpJv4j"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-381f03d7be0so5190a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785427481; x=1786032281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uXxniCcKoOU5F+uvUGWNd+osNIWTn5/2sMtcMApujT0=;
        b=rDUpJv4jMX7SYJqRIhtXhO30maeyXwPMbOxHb5P1PqYlQ4WEKfYC+RxSaIJcnpZyRH
         UZ5lS+FQ7zQQx3X8tmsCVhRzdltXpKrccHIINHoNpVksi7WoHEkTz1rknKeQTAFCRyLL
         ANjgBq09frtdFOPYSVNhJCfc5wG3oCndhfjLbyDtZ9z012ZFAe2xM9juEV7R/AXhVgED
         RYzO8ypvb03TJDP/EQkOwB5BeLpu0JjrK12UPmqHmcRA0p/voBK61k+MHp3xJhvGNuoA
         2c7daZZatVsEncneqRVeKqj6H1xrolY0Ma3o86XG5ki3irD9QH9FJFTpEHlkTMnRSrN0
         rAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427481; x=1786032281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uXxniCcKoOU5F+uvUGWNd+osNIWTn5/2sMtcMApujT0=;
        b=oRWlvUTNxHSdTt8bszuRGBYBoKiGlRANxcsULWtYtLnk68DHqxMHq6XnwUxiK5wGdj
         9MjoLkcQ4LhVOtpgwwOlaNqm3fzLdGJStkYXXV59qfm9pV8vj9/5qwNbGE9Pi7QXfmtN
         DNaT1E1B/5gXP3QwOlv6LKs2RJJCmECcxvS044HkeGTr3SWYuiydqfW5SeWtUQRbOJyF
         7PpjTU/IO8sTZtCso3wE49eQ7jub7FqlrjkaQ73OSsuscEpAnfsB8ZIVVI4CgBvZDDTZ
         hrYlvaef2XZzfeLfW5/XdzceOwaYZuT5nT41y45PCZqeYr7o2E5EXjdI0+8PYl9G/Kr3
         C8Zw==
X-Gm-Message-State: AOJu0YyDIMGPuFFDyLN2POdZtnGoi35u/4wcK3jNTH+EatCKYGE67KJ+
	cPta6kX9tzWsaRomYSCl/Jx040H5+y29TnaKB6+jvDl+j6MRhBVWma1x
X-Gm-Gg: AR+sD13lRBW4RY1Vyht/pwfKFnNgYsfmgqGs9sPrfdraW9C2yL6yySUjlT10hmcqG78
	IJR8RE6QefSrV3YQyufzbq3lKDL2X9sXkXVhjbM+uy1Y5rVm2lMEL/KlkABibeoAtpWXnDRCEgy
	fChGvgjDlDBVQ6u2Z3V1CVP+gnNsCnuP1cLwmmJEYMicIfddsa+ktxwmIgP5SpraF2HvkdtN9ON
	9YsV4mN03i1IM3B6KiO/W9CxhM4zHx3DGpkVudvy+3f1A8XCaytCbgAjNfxMqSM3EBjOhbuSr8Z
	vFEOwkZIYsGL+sSSMq9MtPwRG9G+bdTO7fo3Y9bD5Qrh2JfoTjk7gh70zatys1NxLhtsTbnkcSj
	etek2RWS8jgQpSle9BO0Ry4qivv2rZOIPFS4Fh1ceuKQzgq1w4XIt7YuJr94/6kbr3AaH3u9zaO
	oTWOnkjle+CMQgJbn1wFT2BychCUfdBtpyUxMbAohjkKD4az/GOKerlVunDVx8dD1vsZewysnko
	NY=
X-Received: by 2002:a17:90b:4c0f:b0:38e:91a8:fb85 with SMTP id 98e67ed59e1d1-38fa8200471mr696474a91.3.1785427480946;
        Thu, 30 Jul 2026 09:04:40 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm35012783c88.5.2026.07.30.09.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:04:40 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <shivesh@example.com>
Subject: [PATCH 4/8] wifi: brcmfmac: cfg80211: implement PMKID_V2 and fix delay busy-wait
Date: Thu, 30 Jul 2026 16:03:52 +0000
Message-ID: <20260730160425.11933-4-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730160425.11933-1-shivesh@example.com>
References: <20260730160425.11933-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implements PMKID_V2 for FILS fast-roaming support instead of falling
through to the V1 path. Additionally replaces a harmful mdelay() busy-wait
in brcmf_delay with usleep_range() to prevent CPU stalls.

Signed-off-by: Shivesh <shivesh@example.com>
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

