Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D987282F14
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809828; cv=none; b=pbOMoch5wT3Da9+pM8GcJy+VVouz+dEoL2bpq4BcQifU/Ss5+cS1JxdXBcm43MWqq8bCOJrghE5TkZ7TabILdxxDMg0Cp6lTj03urLQjIKlHoYpbrceD3kuPb7Y0xpzmZfiHWYn2P9TOEEW8M3GAssRVixWurkPoJlNTQWEKPWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809828; c=relaxed/simple;
	bh=5HZusXGGgXhhH3W8ubzFw67xLQYDeCSyR6CM2Uhy2zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqZe2yAq3x+IkYJJPvGrGQSfQJroEL5XM8MfSJHxcfKrWWN0LTFWa1q5KchdqMMRdm0W1OofMcXKrqiWQf0XwkSPV2sCOS4l15Rsdj3i0x6eJHiN3yo092CUtmYx6pUgsAawH2b0ayeMlDDuGW76OPDSEmInUqztZFMe0AgKMPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=LDfBE+BT; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="LDfBE+BT"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1cc97b84bso295713a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809826; x=1788414626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1HEWHLEuvsY5qcN6tmmUM0xY8jgOcPE6VZRgHulQ8dQ=;
        b=LDfBE+BTTWKCZZmMGAP4aqhY/psk+G1nqyCbXgOySdSpjIutEWtlWsreiRZwsiujEP
         jTrBW/Ta16LH4FbDuhOF8raDQT1XZPO/yLYFiSMweR1kwV4Z9hp6vPkxrg73DN+UQch3
         ZL3arnVQ085r+cMDcFEmPnrkdm0YwLDb3gJQLJHkIY3HubkcrwditSDNxvbiQS7ESVEW
         tsbu+cfJIhysARws/v/taFZ4v1MUG4KPxnPnThPpUxWaCa0U4hncgHyoqXAjh89oKBVQ
         49vgWpPqx65fRyZTWLvZSZjSdVWFB9x3JxsJa07qs5/8miRd6faLEAB4PlKNQyJDQ9gO
         DfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809826; x=1788414626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1HEWHLEuvsY5qcN6tmmUM0xY8jgOcPE6VZRgHulQ8dQ=;
        b=Inp+ktLoxf5PZZxUHo+4Qfr9tM+eBQwW5+6SRywJmCJGvqTGA/lvRl1xHkXkuTUHMQ
         vxgqLmYwgwVVeS5QUbwZrjgbA56q7ey5mWGnHni84X1h2Z8nHaNGvHMDh1Ht6gx+XY0K
         tskHn/M9m8q1aXpNjDeI+Hs+QGJxvCxHTtHf9rFv/znStGXfc1z6FXmQjrdnRtwjFW29
         SG+AfxutTLLJ6rPte6uhpyoRk1ymByL9P3a6UJtoaOagl2H+IdWgW88ndVZqmGukzmi7
         6UiIxR2dHDSzxsJ4INxRCT1YWVTX7M0N+ZXJqv2eKyHJwQvZkyHb9Yzsens0ZAvfPwZ3
         /cvg==
X-Gm-Message-State: AFuF++nJE1pJMRgQ8cI0/absnAfXwUZLAmsgaF0N7EuGBrwSoAnrU4Np
	U6gpUT8iPTPbmWaoIFYHj553rq1No3ZdLU9Dx+UqtOO62GZda8DukJm6WhOcEPPbXDo=
X-Gm-Gg: AR+sD12bhzPu6ex44CmzqOncvt3uDoYHxViir48FgUZfOKd2gZ+KmHrvJDZ4Y8XkdDI
	MStTeVmO+8vNr1fLg08L00JNI/Wv9fd+NlUzaTQalcOY7IzQoZ2yUMrSRnUTLdEQqWMJ1acpok7
	vmiRGGzfIwkTU1pa94GzVadcfKVIxKBvJFh6LcfCMpwuzMg4KSQ+G6AYtOu2qhyBiSXV4AFTZ3u
	Or4mT10QtYNuOEJXBc0unmBiX0ItVzJOw+0YKYS1NdyDBW3hdsWKfcXEkWN34mEIPvmnnHaOFQm
	prFC3aakywj6Wfaji9oMPi0nYK4FwvNSpFlf13W1r21W3XPwfVG7d85qmHbSMNMrNCLifFRQDmp
	2ZMlPfGn/m/5WdLYWwzGgxElFcqvcw2quZJy3IFQzHxsS+4f/euymorieH/CqPLe1ob0DxfF3BQ
	6EFJPFfjOJkKeSmuOsArIuWulzT9Q2opU6FsbTnOdrIG/dUHAojCjWdFDYpGNqsF0JnocpNl/PL
	zib/YwKrTNrbGBQKZd7iP4wMMOdmPO70FwWOIlMsr/q0DCA+qsjfYNeWegIc2txjXXLBy9n3HZO
X-Received: by 2002:a05:6a21:3a46:b0:3b4:8880:2089 with SMTP id adf61e73a8af0-3cf851558d3mr25977733637.16.1787809826493;
        Wed, 26 Aug 2026 22:50:26 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:26 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 5/8] wifi: mm81x: factor out tx width selection
Date: Thu, 27 Aug 2026 15:49:14 +1000
Message-ID: <20260827054917.255584-6-lachlan.hodges@morsemicro.com>
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

The tx mac op is getting busy, lets factor out tx width selection to
prepare for some future tx width selection fixes.

No functional changes.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 54 ++++++++++++---------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 5bae7c6251df..1444db98351b 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -1243,38 +1243,44 @@ static void mm81x_tx_h_fill_info(struct mm81x *mors,
 	}
 }
 
+static int mm81x_tx_h_get_bw(struct mm81x *mors, struct ieee80211_sta *sta,
+			     struct sk_buff *skb, bool is_mgmt)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct mm81x_sta *mors_sta = NULL;
+	int tx_bw_mhz;
+
+	if (ieee80211_is_probe_resp(hdr->frame_control))
+		return 1;
+
+	if (is_mgmt)
+		return cfg80211_chandef_s1g_pri_width(&mors->chandef);
+
+	if (sta)
+		mors_sta = (struct mm81x_sta *)sta->drv_priv;
+
+	tx_bw_mhz = min(mm81x_tx_h_get_max_bw(mors),
+			cfg80211_chandef_get_width(&mors->chandef));
+	if (mors_sta && mors_sta->max_bw_mhz)
+		tx_bw_mhz = min(tx_bw_mhz, mors_sta->max_bw_mhz);
+
+	return tx_bw_mhz;
+}
+
 static void mm81x_mac_ops_tx(struct ieee80211_hw *hw,
 			     struct ieee80211_tx_control *control,
 			     struct sk_buff *skb)
 {
-	struct mm81x *mors = hw->priv;
-	struct mm81x_skbq *mq = NULL;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_vif *vif = info->control.vif;
-	struct mm81x_skb_tx_info tx_info = { 0 };
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	bool is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
-	int tx_bw_mhz = cfg80211_chandef_get_width(&mors->chandef);
 	struct ieee80211_sta *sta = control->sta;
-	int max_tx_bw = 0, sta_max_bw_mhz = 0;
-
-	if (sta) {
-		struct mm81x_sta *mors_sta = (struct mm81x_sta *)sta->drv_priv;
-
-		sta_max_bw_mhz = mors_sta->max_bw_mhz;
-	}
-
-	max_tx_bw = mm81x_tx_h_get_max_bw(mors);
-	tx_bw_mhz = min(max_tx_bw, tx_bw_mhz);
-
-	if (is_mgmt)
-		tx_bw_mhz = cfg80211_chandef_s1g_pri_width(&mors->chandef);
-	if (sta_max_bw_mhz)
-		tx_bw_mhz = min(tx_bw_mhz, sta_max_bw_mhz);
-	if (ieee80211_is_probe_resp(hdr->frame_control))
-		tx_bw_mhz = 1;
+	struct mm81x_skb_tx_info tx_info = { 0 };
+	struct mm81x *mors = hw->priv;
+	struct mm81x_skbq *mq;
 
-	mm81x_tx_h_fill_info(mors, &tx_info, skb, vif, tx_bw_mhz, sta);
+	mm81x_tx_h_fill_info(mors, &tx_info, skb, info->control.vif,
+			     mm81x_tx_h_get_bw(mors, sta, skb, is_mgmt), sta);
 
 	if (mm81x_tx_h_ps_filtered_for_sta(mors, skb, sta))
 		return;
-- 
2.43.0

