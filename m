Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E81B1A5B8A
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809804; cv=none; b=P1p47ZhLl6gCZuIUd3WTbRH52dcsT95JZXZQw0yHlKTVGXXFyD5t+5EqNcy+MW59huctqfC+F84YyocTbXii+t5U1l/GaUsKxQwDdqjaKJIwwK0XaI/EAyj25G69y7V2mJu/xis7S/uga2vlSPKHN8Fr19HIwQFMQgnyge9pmeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809804; c=relaxed/simple;
	bh=DFCKdHTBHrXkh3N31ALGb9TaCk0gxnOX1sJH7iw2Ssg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5f4gGAkAw49J4yIMmuSo7wMLbENZ6xYKFvzxDaSPrfRgcJzNN4bv0CIylvTqbgpOS4frCNt/qiEakqJSrwljle1TBq4IDrmYWcIFlkV6dQWbwICmgQKMu0jfK40gTi65U6nXhGe82aX2jKxvr5enyRKGTNDi2IWAASoBvusecA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=qbhvsXqq; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="qbhvsXqq"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc1a4c62804so1845957a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809802; x=1788414602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SNHvvO6wld9v2uE+UqHVetqIRMVyT5YPkel6Sx4K4L8=;
        b=qbhvsXqqxvDvh5eOu1Z/8GqQQtuRBToLa31pX2niJBist+X7LIvyhWCrLhoUi8TD/4
         ZFC21AT47MWCQ2cj86QRlKF53h74rNV34lOsS9S/KwbyYZq4lZjW0m0rccxEXygcZhPx
         yccg5kv87OIpPkTC6R0uL1fZYXaL8RrRExIgddMpQP/HydpkGFnGsmmzT65Yd4Yl0xH/
         nRWZqhwlTnAWA8/MZF6pRAB7HQDDC/Hf5UffqCrdTpkImfAfR9Q55PYSo72fpSPzOeF1
         y549rO24KILNEo0vxTR2TFOgHREqMxjFNOkr4K1xH2pSkwbT2lsixUWBHLVILWTKkuX/
         qifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809802; x=1788414602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SNHvvO6wld9v2uE+UqHVetqIRMVyT5YPkel6Sx4K4L8=;
        b=agY3pzabxVwj+WbnAKGFpjTkqNIy2SrVnlBgFItwRpbHadFUN2SDxT63SIDJneFjKB
         3ZHG+mJ789I+q/oynssR1tMz+JpbTjbUg4Km1bIoc8Edkphcg0pwZ0rPqGCCFHBlaoh4
         ladqmwRM4UrZCINCvyzbn8QAW20KJyRNGAvsFuW4JVgtmutyaZklhjhIeRZzFhpifLRP
         f97Tz8iAU5V757lxzYpgtk9KsVSZRpobfYT/h5eg1D9uII4FGn3QajGVzjzD3e71LryY
         Tleo2PMaBCmBeiaLSTRFHQ+wGmI6jkLUd4q82DpguATc3ZL1QrjGUmojPh7UZE/KkEtd
         3bZA==
X-Gm-Message-State: AFuF++nEdMMUNeIZGZ7Ptix6pR0Ndpz18XlM2RjFgJUhm161J8Jee0+T
	lZ/Yf49pRH4XkRl0DpAbov77pGcTt5I2lIxt+cJD4M0EBBR4mi9jdDEr65LsV0ASSTe75o16tsB
	LmO1Qsrk=
X-Gm-Gg: AR+sD12Wgcx86DqPeynIRurItPHS9/BaXZl0JsBiAosA2/5hPe2h2EYIGh2DN1VrUJD
	2mOqPeEVjFKVZyOomEvznH487KAyrmQtDbh1mF8Q/IrT7WLWeRJ2BYH8LQ8EEnVDaeW+l2p0VCE
	0Hi1LU/Lqt1UARgudFNQTYzRZzF8yB9PHXrNR8K8CUSqkBUR5TJ5mLuwyPj/sfSjL54ykE9cLFh
	SM1VOcmkWbBMZXhLCD6dIUfAxe6s7NuZ10enqF45TEXOtFaSqWUC9IpUTmaSLOG20Xbt8elhBSL
	MHLmsFEgLDpQPlx8ztR9vMCesfuCURvdO8EyqmCTPrgiSX4sP0J+S6TSSwTcR4qpL1VTcoPTDN0
	E4yUtVdw/1WcH1RgtMry1CHM1agvBFjFbbtams/87O0quMjTfyVNInYHPQE+LmcQS0o8B2YyXMX
	pR7uMraDS1I4NMe/EECYFAY4cnJKPkvFSODjdMdsuieD8yMfshiNkgevDQVU3UBYvOdPOiVd31G
	uxSkJlRtCFrNJKEmQrMaF8aft861SFkybhM9lR7456g3PsWa4q0OcaWuZYb38cKslynRwjreG3k
X-Received: by 2002:a05:6a21:35c7:b0:3d0:9590:7148 with SMTP id adf61e73a8af0-3d095907623mr13132872637.17.1787809801812;
        Wed, 26 Aug 2026 22:50:01 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:01 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 1/8] wifi: mm81x: move beacon work and init below the tx op
Date: Thu, 27 Aug 2026 15:49:10 +1000
Message-ID: <20260827054917.255584-2-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
References: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move mm81x_mac_beacon_work() and mm81x_mac_beacon_init() to below
mm81x_mac_ops_tx() to prepare for future multicast handling such that
we avoid a forward declaration. No functional change.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 84 ++++++++++-----------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 08ca116a68b4..4d0131246710 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -445,39 +445,6 @@ static void mm81x_beacon_h_fill_tx_info(struct mm81x *mors,
 			cpu_to_le32(MM81X_TX_CONF_FLAGS_IMMEDIATE_REPORT);
 }
 
-static void mm81x_mac_beacon_work(struct work_struct *work)
-{
-	struct mm81x_vif *mors_vif =
-		from_work(mors_vif, work, u.ap.beacon_work);
-	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
-	struct mm81x_skbq *mq;
-	struct sk_buff *beacon;
-	struct ieee80211_vif *vif = mm81x_vif_to_ieee80211_vif(mors_vif);
-	struct mm81x_skb_tx_info tx_info = { 0 };
-	int num_bcn_vifs = atomic_read(&mors->num_bcn_vifs);
-
-	mq = mm81x_hif_get_tx_beacon_queue(mors);
-	if (!mq) {
-		dev_err(mors->dev, "no matching beacon Q found");
-		return;
-	}
-
-	if (mm81x_skbq_count(mq) >= num_bcn_vifs) {
-		dev_err(mors->dev,
-			"previous beacon not consumed, dropping req [id:%d]",
-			mors_vif->id);
-		return;
-	}
-
-	beacon = ieee80211_beacon_get(mors->hw, vif, false);
-	if (!beacon)
-		return;
-
-	mm81x_beacon_h_fill_tx_info(mors, &tx_info, mors_vif,
-				    cfg80211_chandef_s1g_pri_width(&mors->chandef));
-	mm81x_skbq_skb_tx(mq, &beacon, &tx_info, MM81X_SKB_CHAN_BEACON);
-}
-
 void mm81x_mac_beacon_irq_handle(struct mm81x *mors, u32 status)
 {
 	int vif_id;
@@ -497,15 +464,6 @@ void mm81x_mac_beacon_irq_handle(struct mm81x *mors, u32 status)
 	}
 }
 
-static void mm81x_mac_beacon_init(struct mm81x_vif *mors_vif)
-{
-	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
-
-	INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
-	mm81x_mac_beacon_irq_enable(mors_vif, true);
-	atomic_inc(&mors->num_bcn_vifs);
-}
-
 static struct hw_scan_tlv_hdr mm81x_hw_scan_h_pack_tlv_hdr(u16 tag, u16 len)
 {
 	struct hw_scan_tlv_hdr hdr = { .tag = cpu_to_le16(tag),
@@ -1329,6 +1287,48 @@ static void mm81x_mac_ops_tx(struct ieee80211_hw *hw,
 				      MM81X_SKB_CHAN_DATA);
 }
 
+static void mm81x_mac_beacon_work(struct work_struct *work)
+{
+	struct mm81x_vif *mors_vif =
+		from_work(mors_vif, work, u.ap.beacon_work);
+	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
+	struct mm81x_skbq *mq;
+	struct sk_buff *beacon;
+	struct ieee80211_vif *vif = mm81x_vif_to_ieee80211_vif(mors_vif);
+	struct mm81x_skb_tx_info tx_info = { 0 };
+	int num_bcn_vifs = atomic_read(&mors->num_bcn_vifs);
+
+	mq = mm81x_hif_get_tx_beacon_queue(mors);
+	if (!mq) {
+		dev_err(mors->dev, "no matching beacon Q found");
+		return;
+	}
+
+	if (mm81x_skbq_count(mq) >= num_bcn_vifs) {
+		dev_err(mors->dev,
+			"previous beacon not consumed, dropping req [id:%d]",
+			mors_vif->id);
+		return;
+	}
+
+	beacon = ieee80211_beacon_get(mors->hw, vif, false);
+	if (!beacon)
+		return;
+
+	mm81x_beacon_h_fill_tx_info(mors, &tx_info, mors_vif,
+				    cfg80211_chandef_s1g_pri_width(&mors->chandef));
+	mm81x_skbq_skb_tx(mq, &beacon, &tx_info, MM81X_SKB_CHAN_BEACON);
+}
+
+static void mm81x_mac_beacon_init(struct mm81x_vif *mors_vif)
+{
+	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
+
+	INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
+	mm81x_mac_beacon_irq_enable(mors_vif, true);
+	atomic_inc(&mors->num_bcn_vifs);
+}
+
 static void mm81x_mac_ops_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct mm81x *mors = hw->priv;
-- 
2.43.0

