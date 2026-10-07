Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F016A3D9523
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 05:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349220; cv=none; b=h2nvaEj5Pa3e8utfy2Sktlu7dtO6JU75/QvZqPbAg4hGPp1/kt25qfEbuKYZfc0j1Ok3M688oEQxDvVuk0NdVoM/7fYv4WNvRfXfhgBOCzIuBI8OkvJe9yMGBv3lhh6ZU4Upp9uJXRnsV0QG/2hHDmyj3jXIBYcW8ZrLlp5rZJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349220; c=relaxed/simple;
	bh=F+WhITRb305oGosHqKq5H9xjAIIQID5zehviwjkvzgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRMDpOrA04EkX7g+TPiqP0jG7HG8EHqSPJhQbX2keKWzQyKoJaFsxRryhbmxmw3v4jS0NShjHCdHqKpRugSV3zsPrrw+rb2O/CnQdnMCUWcPaNQQP4Ep3JbCvtR36Y1M9J56VJWcwzFu25hKOsYaCVWmCFXJyxnKvYChuRNWrAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=MAoPTW+0; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="MAoPTW+0"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so594455a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 22:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791349211; x=1791954011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZWOMHA5iZQdg0Ng1LucpTsv/J7FkFHXatllNhZn5OGQ=;
        b=MAoPTW+0D3DJYFNIp32+SPRSkCipstFtAYauueyPs1SUfFAaY5sJ8zUXhi1q7zCA+a
         iP3JxEXWaaQI9M4QwjdEpwysNGDrCgeXB/3CWdBAlMQkRmgSYy5li81cj0967e+gtc9P
         4EHlRWwln6ekZKvXiT+fgo3YByQMQjPhwaGNyfdIaPlYC658hFT00hfN3oaZdl6iPXLU
         cbJmFalq7hTIYU/6t6uqyesSJb7QlgPn6cCX3zwnaKNozTJLF9ZTNLAYO6T+65ExLF4t
         j+wk9bqQM5VJOVN1DC3WjeBJiSWo90qR/WcC8Y2sdqoJuNn+qBlQONf/Jit3L0dRDrZH
         Ak/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791349211; x=1791954011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZWOMHA5iZQdg0Ng1LucpTsv/J7FkFHXatllNhZn5OGQ=;
        b=VvYvNWnfDf3RLxjhBK0bJi3lyByaFln5ReHAMJhbtk+WF07gPWDfo//INN0An+80LS
         X+tiFjysJ8FcarWAsQAqZmwdQ3p6arIFuG0ctB/7X1SkFOwwgyUVGApUc8K5/lJINvIl
         unKGbyo/eXNQb8Nf20seZ7us4JBGqIH4YQYYSDfO7OIjftMLVxAEMAbEGgzrwxcs5Etm
         sYdoItbaZONinuNhK9JngzWHYoAPHPN8U3ld9SpDe9DXo51Jyugg74bwGr1fSEMDZjjh
         MPgvPQ/s6uW/LLOUHtyIaYW2ULFzAUIK/o8yhkSqHaFC7um7G/2L69olpVC2iaXIjCdg
         sPpQ==
X-Forwarded-Encrypted: i=1; AKwUvBzumEqlrx9Ubs4CUZLWid2k24TpMTw+z+9Lr3R0uXihZnx5PdP03f5a9F02wDU4hocsKZ2Mqdnv7Rb/05x4ww==@vger.kernel.org
X-Gm-Message-State: AFq9FYL/NQdO0OvXb17JDuO5aTS4A4Ei8PFvLk+v4eFowNT7YS1gTdD0
	HpHbr1vpKa3DxGoSaZlvfTX9dBqIQvxnKntkw9RQluR0q0GDYcdPqiVSp6YOX3O+JTd0nESiDCU
	iyAWfqcA=
X-Gm-Gg: AYBFou1Sy5ruynCsp3PpPRT31QEwbMbFc3169iGkhk9PSZ+is4qex+Te2J7fd6cZ5T/
	ls/ygpWRFMy0bJUghkZofeWa+xlaaQIjJn7aL79c3sLfy9J1XkLT/FTmjE0HGjKfPD3PbcCqJSL
	rTV7/BU0DWOTkwjVAXJ81gYfYLyy+2K2DCZuAmepDVU+EH0cQ8HAw0QUCHf5mkftJXUUVs5CCuX
	cS93/wm832fPOJ7GF2zpeVuPLcv/9fobvvNgw9YRxhGftbWleUBaZQdglkIqSO64y2ABffP3ILy
	vfjotQDdLypKS/CgU3chsJCpjEXXu4LHRGekZ+pdINe6zVpZaJnL86mMt6g/mbyu6bIAD1mzaqE
	1K0RlkBDPvCAnevkGhtviWHGrEuaZ1ZXsRQJxiESwl4rj0KQp29Y88kLwSsek/6V9H/0mEEB9tc
	ZYxsa9QXTfKBJgrqNv89Nxmo85f7SNDBWbEZgKI70yqTAiwhMy/sewJdBicpSzT9uz8PquXeP6J
	ZjejPI/3JNyzl4taFcWHFDyqD4tOtpFnLoEjP0ZF7SHxW4kSWStdLUXgFa1x8AtY8xjRLeDNfrC
	uarXF489H006B99y
X-Received: by 2002:a17:90b:2791:b0:3a4:dc2c:be9e with SMTP id 98e67ed59e1d1-3a8a1bfec25mr1006040a91.51.1791349210772;
        Tue, 06 Oct 2026 22:00:10 -0700 (PDT)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a4b1abbfsm696011a91.4.2026.10.06.22.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 22:00:10 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 1/3] wifi: mm81x: provide the station to mac80211 on rx
Date: Wed,  7 Oct 2026 15:59:58 +1100
Message-ID: <20261007050000.127009-2-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007050000.127009-1-lachlan.hodges@morsemicro.com>
References: <20261007050000.127009-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now we look up the station on rx to update its average RSSI but
then hand the frame to mac80211 without it, leaving mac80211 to look
the station up again. Use ieee80211_rx_napi() and rework the code a
bit so we pass the station directly to mac80211 to prevent another
lookup.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 34 ++++++++++-----------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 1a7382d27475..ab6a33a27935 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -1926,22 +1926,13 @@ static void mm81x_rx_h_fill_status(struct mm81x *mors,
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 }
 
-static void mm81x_rx_h_update_sta(struct ieee80211_vif *vif,
-				  struct ieee80211_hdr *hdr,
+static void mm81x_rx_h_update_sta(struct ieee80211_sta *sta,
 				  struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_sta *sta;
-	struct mm81x_sta *msta;
-	u8 *lookup = ieee80211_is_s1g_beacon(hdr->frame_control) ? hdr->addr1 :
-								   hdr->addr2;
+	struct mm81x_sta *msta = (void *)sta->drv_priv;
 
 	lockdep_assert_in_rcu_read_lock();
 
-	sta = ieee80211_find_sta(vif, lookup);
-	if (!sta)
-		return;
-
-	msta = (void *)sta->drv_priv;
 	if (msta->avg_rssi) {
 		msta->avg_rssi =
 			CALC_AVG_RSSI(msta->avg_rssi, rx_status->signal);
@@ -1969,9 +1960,11 @@ void mm81x_mac_rx_skb(struct mm81x *mors, struct sk_buff *skb,
 		      struct mm81x_skb_rx_status *hdr_rx_status)
 {
 	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta = NULL;
 	struct ieee80211_hw *hw = mors->hw;
 	struct ieee80211_rx_status rx_status;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
+	u8 *lookup;
 
 	memset(&rx_status, 0, sizeof(rx_status));
 
@@ -1980,19 +1973,24 @@ void mm81x_mac_rx_skb(struct mm81x *mors, struct sk_buff *skb,
 		return;
 	}
 
+	lookup = ieee80211_is_s1g_beacon(hdr->frame_control) ? hdr->addr1 :
+							       hdr->addr2;
+
 	mm81x_rx_h_fill_status(mors, hdr_rx_status, &rx_status, skb);
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
 	scoped_guard(rcu) {
 		vif = mm81x_rx_h_skb_get_vif(mors, skb, hdr_rx_status);
-		if (!vif)
-			goto rx;
+		if (vif) {
+			sta = ieee80211_find_sta(vif, lookup);
+			if (sta)
+				mm81x_rx_h_update_sta(sta, &rx_status);
+		}
 
-		mm81x_rx_h_update_sta(vif, hdr, &rx_status);
+		local_bh_disable();
+		ieee80211_rx_napi(hw, sta ? &sta->deflink : NULL, skb, NULL);
+		local_bh_enable();
 	}
-
-rx:
-	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
-	ieee80211_rx_ni(hw, skb);
 }
 
 static void mm81x_mac_flush_queues(struct mm81x *mors)
-- 
2.43.0

