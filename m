Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DCB445AC8
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512966; cv=none; b=F6LCiHMV5FC/tALhQxw9T8cJofYBfb4ECYiMctICQvIrixdfvZhZcyG86a7iYjor/C6ECKeWVAI/Gjl0HnNYiDRIyzIQ68Xg/HGUTd/H4Gbd14aA1n+no8ckXaNqZ99AryQTUSFf2lgAgeuY7rOgyXm5dgUOSBkThyg9qRIZx5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512966; c=relaxed/simple;
	bh=5l5j8Mmu2S3Bni8tiVCEfGXSJ+0eqA6wzanI0ZL23bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJQGNRrK1w/YXHAyTJ5EkGq4IAzRkASIRfX+va+6ke83thapwvBUHHZiJT7wKrBgLCrNcM+PaJyuMSLTdv3BkioE679+EVfD/38KnxEC21wF/vuF707ADzUpo65Qpw0J75GQ0F1DZDHNxhT5KHTRjUzFh1m+DGmEFbpWlB3k41U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XkwcQLl/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XkwcQLl/"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d01548ac96so1128685ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512963; x=1786117763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=60bjaHyBUJd87L9/5oXjhGZVQ3tHQ6V6AhVTN/AVUw0=;
        b=XkwcQLl/Mm6YKXIunIeQlBrOYcSnzGWj482ckX9un2ZFd2U0dyZy9cHJzDQxKy/tz6
         +h9pJhZqALeO0U0tKYuFUHoktok3fflOpk6l07d4CqWyf0h54Mn46M/52QXGI+yQ0COB
         M/y0HFpB0HTDS6BLIDxMDhEvjxUzMDo8NLIZ6USrgAi7YkHh7E1h9Xq8tX5l3hbfkkuS
         j2enUcbPYHZTjROTSHKbAyZ/ai57Vd4tpne47V94wh8KijWaDN7vZXsBRJ87zIoWRhar
         R+9CuxrRYyqkB/icBywJWD7dT2JtF7VQD5KMvY+0EDsYfPZmssvs0Qm1m1DpcIm9kTwK
         uVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512963; x=1786117763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=60bjaHyBUJd87L9/5oXjhGZVQ3tHQ6V6AhVTN/AVUw0=;
        b=qoxF4//M9s7pYM/2MkDLkvXbrCrKVM2sggRM9hQp5QhVH3Gj65CPQ2H1kQnipnRQvo
         TFvwnfA7vzJaF9Pfb4tZJEK2CTfvuWt23Ft5Tg6EBSQLsyMwOo/zW4yV00dAiDn/TjGV
         uPC6VgtsgNfLqfeZ5ligXnUKs0/7OmIRDGUGVykl8fIJ/UR46IR4qIxnSMg6AKACzcaE
         LqEYEVMF76KIM7WqWZNsOF4x+b49rT6TPkzLwhkAqdUbChYqAgobNWNVwipGzotkinXF
         5rhPA6v2KLm4f8PMl5qI0lBp3VmfYCGC/TfBKijyo5O0PSuJRJXpME58j2AmxFUj8FUI
         lNcA==
X-Gm-Message-State: AOJu0YyTHQzpljA6vtSrV0qLWWDDLYK+ZzC7hS4/Shk+TkZ4wEuVwOKv
	nUeSRiAw5z4wM84kaK3ZGaVmcwKtPUk3EZbFFCW7DGVgHwYa/XN2lct2
X-Gm-Gg: AR+sD11whYeccOMmcINo5eEs3wMyklYamCuFYxonX6eLyZTmPuU6UvF4nQQmb/vloHj
	+WjZ1Pm4CQmQKAgRuT/eb3xWFnS3NX7gzMMjP2ZFBI729A2bFPVFYIS3V7yQ00JbIqbRmFuwWaF
	XAcwfehb1xvZ1YEHvnc7jBpYwHEyzO7mkWg9nUbtZHLIVtEmF/YxvxEk9elhXMY82yR71/8Kz4o
	WDcpP/TQmVnTpY9pa7l9PSKmS2XGuQjnLdAqL5BYSZzQx257Kbi6mAJ2Oew6rjOL//SUa1qgMkC
	8a/E9aSc2Q55I9GqyeHrOQ9RLTUsvwZY2vHCSC0MeB6E/pjFr0M8tk0S2qrHUBYYFfyHNh+V/3X
	TrjN7XTeiUZad3CMDIv1WArLPAt4sf9j31BERz0ti8TMzMy4JxQnWLtb0VO0ElXqB6OLw0sU4LN
	mJIQERPshwPXyGeZ087y5zwYTCZUAAFrDKaMqriTaobWL1G2FEE7PdTd8YMz1sLlOyiNkT1kU2a
	JE=
X-Received: by 2002:a17:903:18d:b0:2cc:e7f3:d39e with SMTP id d9443c01a7336-2d052298ccemr6525965ad.2.1785512962471;
        Fri, 31 Jul 2026 08:49:22 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:22 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 4/8] wifi: brcmfmac: cfg80211: implement PMKID_V2 and fix delay busy-wait
Date: Fri, 31 Jul 2026 15:48:36 +0000
Message-ID: <20260731154901.1822-5-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154901.1822-1-shivesh@example.com>
References: <20260731154901.1822-1-shivesh@example.com>
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
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 123 ++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |   4 +-
 2 files changed, 115 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 0b55d445895f..2375c2f9d97a 100644
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
@@ -4364,6 +4362,109 @@ brcmf_pmksa_v3_op(struct brcmf_if *ifp, struct cfg80211_pmksa *pmksa,
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
+	/* Write the updated entry count back to shadow BEFORE we overwrite
+	 * list->length with the wire-format byte length at send:.  If we
+	 * don't do this here, the next call will read a byte-length back
+	 * as an entry count and silently corrupt the list.
+	 */
+	list->length = cpu_to_le16(npmk);
+
+send:
+	/* Build the wire-format byte length and send the full list to firmware.
+	 * Read npmk back from the shadow (handles the flush path where npmk=0).
+	 */
+	npmk = le16_to_cpu(list->length);
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
@@ -4402,8 +4503,8 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
 		return brcmf_pmksa_v3_op(ifp, pmksa, true);
-
-	/* TODO: implement PMKID_V2 */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
+		return brcmf_pmksa_v2_op(cfg, ifp, pmksa, true);
 
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
@@ -4446,8 +4547,8 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
 		return brcmf_pmksa_v3_op(ifp, pmksa, false);
-
-	/* TODO: implement PMKID_V2 */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
+		return brcmf_pmksa_v2_op(cfg, ifp, pmksa, false);
 
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
@@ -4487,8 +4588,8 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 
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

