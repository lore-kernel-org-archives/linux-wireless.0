Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B7B4499B1
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514026; cv=none; b=koKYcLvFwqaFJg2wKzyhPEY4KSPWbCaOq1a6FfJEwu8LJsAicQy3kx9FDcR3gCNipZOGG/BhAqOkOVQvK0d0RgLiaTfDhouRNcAb6HhQGtw0hGwjpWO//sYC4U+UDc6Nce5l+aCiBVwNM3SOpKOb4y4pWwt8fi2qrnFUgkIKXCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514026; c=relaxed/simple;
	bh=yt5tJ1FY92EBJqC4N6WpXN19nC5QZxle3Ke9UJYoQV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9KGfB6sBQj96W7N1Aevn97r6rO7nWe68KPXU2FO5yw2eq0jCugViZCe2gz7OtFgZ0iKF9g4RdEPmAXdqQntp85SDCKLE6N3KcTru5UMfd4caiuvF22bXk+ly+zx8AjONIjyG7ZMvLOX9y3ellVjjwX1XSCYOW/GgqfdFXkaWVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V130nf0Z; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V130nf0Z"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c8612812170so42314a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514024; x=1786118824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4c7Zng1vNMrE5OjddEOF9zhiKxLLsxB841dV4ylJ/sE=;
        b=V130nf0Z+TdS5jbXhhgv7sXPjrv8aLj3jwU+IssoFI3DeAjD4pdVkxHME8wl5Pxua5
         i52hwF/d1VdMD4ndiVQaCzfhSodvseceUV4o7LfTSya5YsrGEZaqx5rNqVpkx1cSjPKg
         nlb/GSpKt1wVTkMqBT4SevQ0jLwSUgNRKOiyLMGpBPcgSzqeyvKq/G/D01NovovL9AtV
         DN22LVePgLVs+dJTytVWVD3DhT3lDs8VpiYVopB0AKdDXLd0/ugq863hjt8529BrHTWL
         DYkz03bvWzzshsX78FFCogLOth64vOPQ5/KYwqLQCnVqvUZ1zrg2SG3icu/vTJ/5SEdQ
         N/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514024; x=1786118824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4c7Zng1vNMrE5OjddEOF9zhiKxLLsxB841dV4ylJ/sE=;
        b=Iky4WPxLpdOHkVTftp9IhUSlLGGeb7JmZoaKVtVcnBqZN75MDTU1LoZ7Wb0zT7ddCn
         VWO/XilADpV6mE/j9UtJLS4wK1AwiyIZ7o/bViAWiwabXh7Sgwj8q42vHCkiWvtuxJNr
         L7HZ0YaYICg1ULYhALnLhHBl5jd7Y8mQeYaiyig0IWyqnLy+NZSJSCegRxIAEwghElhJ
         CBGH3aDYkB6FPdbUROBBCX+p7lL0hyXv9HxKX77wp78JSjamO8i6B03c6ChjDGdpYtll
         bpYJ0lDEcESW2qG/3sJt5bL41bYG2T+q4j63+cNDu5GIsuF7S/DaG+n7EBOffqc0Mp9x
         v0dw==
X-Gm-Message-State: AOJu0YwKHR4Czvltoo4R5oVJemlhgIFdCaG/dd9+kiLUSWcwzYYxSpBw
	eX/BlWJw2E9RCPqOpzlrSQJiTBikLcu+nFwBIfKQjbRrdT+2+wwXxbD4zR363XePJ90=
X-Gm-Gg: AR+sD12um3k3eYjrHsEJSrzttWZSaHFXaEdrdepP5QhID8hL2fR0bgBj+r3BxUaexn4
	RHhr4+0NhaPnmljwbyrR1V1D35Njmd1s90yqF3xocX0wDLF8BtJCzkLa5nbeZg044sCudqw3TxC
	pViyePnbgi+c5k0CgEt4WWN3cMLtCCk4P5r8S7t+BFhP2mW/KDAn4GOqoSV0RzpM71tB3qYXJOw
	y1C/RUHyrEyuYLgCW/EPOL3rZafeuJGvyOYlrhqYSBBsBQRwk89pd9PBH27qc6FlKeEGdw628re
	Et6OpWMvaJjy+KHcizMtYxSBqdeKi70Sazt/sO1FkRqKOj0wv92vTK2/Gf+PYYf3Eo7lHNxZJsV
	vctq2h3IH6/JVP0iPaKey2d6swSBIkBezvsUWtlcNtwcPCNqfF44WMoMY6dV/bPxC01GcDE7tmk
	+7a/qsBDiT0d4taPf+8u0sNfgOhitVVIflKN7M+e1K3+F1nGQqJ65Qv63S8O4C08+rJXT0ThExX
	W+hbKpO
X-Received: by 2002:a17:903:1a24:b0:2ca:ecf6:9105 with SMTP id d9443c01a7336-2d0521bd8a0mr7853625ad.1.1785514024258;
        Fri, 31 Jul 2026 09:07:04 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:07:03 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 4/8] wifi: brcmfmac: cfg80211: implement PMKID_V2 and fix brcmf_delay busy-wait
Date: Fri, 31 Jul 2026 16:06:21 +0000
Message-ID: <20260731160646.3812-5-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two independent fixes:

1. PMKID_V2 implementation
   Firmware revision 12 introduced a versioned PMKID list (V2) with
   FILS-specific fields: raw PMK material, SSID, and fils_cache_id.
   The set/del/flush callbacks all contained "TODO: implement PMKID_V2"
   placeholders and fell through to the V1 path, breaking FILS
   fast-roaming on devices with V2-capable firmware.

   Add brcmf_pmksa_v2_op() which maintains a shadow brcmf_pmk_list_v2_le
   in cfg80211_info and pushes the full updated list to firmware via the
   pmkid_info iovar on every set/del/flush. The shadow counter is kept
   in list->length between calls; the wire-format byte-length is
   computed only at send time to avoid corrupting the shadow on the next
   call. Dispatch V2 between the existing V3 and V1 paths.

2. brcmf_delay() busy-wait
   When ms < (1000/HZ), brcmf_delay() called mdelay(), which is a
   CPU busy-wait loop. Since the function is always called in a
   sleepable context (it falls back to msleep() for larger values),
   the busy-wait is unnecessary and wastes CPU cycles. Replace with
   usleep_range() for values <= 20ms.

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

