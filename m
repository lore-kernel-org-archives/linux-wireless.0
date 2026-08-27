Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5CD1632E7
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809839; cv=none; b=Fh9ILrkOqpolPDi6sM53LYLIaKwZoSfisLpxWw1CmeC+mLeapW6hgo6AoiYCha3z9Sje1V2PIcui/KqSwnrdqr+EQSmHnFMdlzfjsNez6ERxEPUXk5O3LpQxDK37ptxt/lhApt9v8NiF9gWbDf/HmPI4j6cUH3jD4rSyIM6+kSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809839; c=relaxed/simple;
	bh=QIilISweQgg5PHBdIHg3PEbO4cdL4PDWo++0peMKboo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNLxTRlOJFf1USIlFbuf6ylNxojvKCZJ5xrSe8Gyy4JwkINJNBImVGILjO6fNuRzpwCy3LFqfgQZpLJA2Y++VLlhXm1uCjZ51uZFK0ht2ZeAbJRMGtU7XHSoAsCBWiQbcu7SJg30DWLvFqyBu3KLCFTDQg6gfwRbk/bsQJDlDHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=vBfZ3EZd; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="vBfZ3EZd"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8548db7428aso831935b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809838; x=1788414638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1DxO01FvYRl2FzLMQ3Q5ySGmASmrP0fydsTcX9cwgls=;
        b=vBfZ3EZd8V4tutRQtJ8aY7kwn3m3RFqs3rgVkegZ579zhk0G6EWux4Ep6oIouAqE0/
         iv7Nx6Q3Q2kBw0WLpOcDFuIPyV7+GT8fZTwVWHY6w7R7VdeOkqS2R1BP+zD4heKIzumd
         jeFeNlzhhAA2wPnn+Y/idOhQ3Nolv9+6s6cnB4sFSbG3BBRSURW5WE93MSb/Iq2MbTD5
         59x1EWqXnxy+PIeWfFFlxPLbK9bjlPT2qz/8XINRkfQTLlwqa/s/Ekz3pnbfttUgZPRo
         5Et+3rNuQlVRBxazVMx3bsryCMDir6cUJyv6r2Yo35ZqYv3EfSXGbAXXPw/MQxBSAoDH
         qf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809838; x=1788414638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1DxO01FvYRl2FzLMQ3Q5ySGmASmrP0fydsTcX9cwgls=;
        b=Iy03twD0iwjOxujTAEUvL+oNhs5cd1ZyZvtJD79fA/sGMFKshrVzB19PBPeI46ZxpK
         b1lfO2s9E4rJMWcTxtKVRHenRXeI2ybeuY+GvTcks1R6WNDmoKeOZDBGAQNzEnRheD1g
         4QnnqWKiBecYcPScW7ujCzrdB5U2BbW5cHIfwo6m1xWx9UwcqTG8DKuQXJDXhV4DVAGp
         SONzkbmEVU4jA1SPutSJqQtfzIbBZMTAuwUcwH/gwh0a5n8NbIGZrWTj3Ii/i6wcyroP
         fdU2YCnh6+51ZWFdy1vG9hN+Yudma2ZoEbCruEERhS7+TwHPXvuD+dB9ztBshySxxX+t
         mtSA==
X-Gm-Message-State: AFuF++naBNWBx8Ew6MruvTOKXM00EhcGS3WTgTrGsA4Zwr0JXCOWu1Wx
	NOnaFi6JbAS7YDoXEv8lhjZmYWV7tas5M6B3hLFMCu4rcfZWflxsEebO389rpEiPu1c=
X-Gm-Gg: AR+sD114byBwRRHRL4jezOwfZEJOq/hbpLw3zYkw6ZEUoJ4tMS+AcSVIHFbP7J9bid6
	gffqkZdWTqyILAoDpvgHQe3l6Q4cOO8jWKsRFtMJxpznCnjJJvm4qL4qdTXxLhHTXm8JYRVHvYG
	iCzTgS6/nUDx3Exi/cnv7vDepEDOLDnrv0IHkM56iHF3K4Dy036S0sfgUkJQpDvODIOxVzXK6ol
	ASSktZPFcCRha/RjWaCtkJcNuohkxvvgjHpdocRzOijGs5YRPqCjwMvT3s7d5tpKfJx2JBBNq2W
	5RugFC4KNq8gxvfE9coH0Xvikd/A+MGjHyZEivJLhVdVFRuoBZEmReXRNmxJFGf2JbfhEMfRk5N
	etyWL1wtys2Vz2VCXPNnpmNeZIXE6TX8qbcMjXFwPaJc419f/mnJB2vbP33AOP2VL+/DOuskxx1
	jO/ARhaMJyB2GKp9IihSr5Sy96LHLo2Ybg+zevBVgJnYvoWOIm7N1robGjfKpeUfKKWkU0b+xea
	nsCUvCRuduqlo8hufLVlVOSvCIY4U48njhEBUNJTol+/S6eBnBkUj2lpmel/ScrTNA9RViI8PNj
X-Received: by 2002:a05:6a00:bd03:b0:847:77e9:acbb with SMTP id d2e1a72fcca58-85374ab4b70mr21898823b3a.13.1787809837900;
        Wed, 26 Aug 2026 22:50:37 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:37 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 7/8] wifi: mm81x: clamp tx width to stas max supported width
Date: Thu, 27 Aug 2026 15:49:16 +1000
Message-ID: <20260827054917.255584-8-lachlan.hodges@morsemicro.com>
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

max_bw_mhz is not populated with the stas maximum supported width
during association. This means data frames are sent at the operating
width, regardless of whether the sta can support the operating width.
For example a STA that supports up to 4MHz receiving frames from an AP
running on an 8MHz operating channel will be sent frames at 8MHz which
it cannot receive.

Make sure we initialise the stas maximum support bandwidth and while
we are here rename it to max_rx_bw_mhz to indicate its the maximum
bandwidth the sta can receive frames from.

Note: This should be conveyed via ieee80211_link_sta::bandwidth, but
the ieee80211_sta_rx_bandwidth enum does not support S1G widths as of
now and will require some non-trivial work to support in the future.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/core.h |  7 ++++++-
 drivers/net/wireless/morsemicro/mm81x/mac.c  | 11 +++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/core.h b/drivers/net/wireless/morsemicro/mm81x/core.h
index 2fd4b4786e77..75e998e8e324 100644
--- a/drivers/net/wireless/morsemicro/mm81x/core.h
+++ b/drivers/net/wireless/morsemicro/mm81x/core.h
@@ -192,7 +192,12 @@ struct mm81x_sta {
 	bool tid_tx[IEEE80211_NUM_TIDS];
 	bool tid_start_tx[IEEE80211_NUM_TIDS];
 	u8 tid_params[IEEE80211_NUM_TIDS];
-	int max_bw_mhz;
+
+	/*
+	 * We really should be using link_sta::bandwidth but
+	 * that requires non-trivial work.
+	 */
+	int max_rx_bw_mhz;
 	struct mm81x_rc_sta rc;
 	struct mmrc_rate last_sta_tx_rate;
 	s16 avg_rssi;
diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index fa3b0cfccffe..d77df6e9af85 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -325,7 +325,7 @@ static int mm81x_mac_ops_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static int mm81x_tx_h_get_max_bw(struct mm81x *mors)
+static int mm81x_tx_h_get_max_tx_bw(struct mm81x *mors)
 {
 	return MM81X_FW_SUPP(&mors->fw_caps, 8MHZ) ? 8 :
 	       MM81X_FW_SUPP(&mors->fw_caps, 4MHZ) ? 4 :
@@ -1260,10 +1260,10 @@ static int mm81x_tx_h_get_bw(struct mm81x *mors, struct ieee80211_sta *sta,
 	if (sta)
 		mors_sta = (struct mm81x_sta *)sta->drv_priv;
 
-	tx_bw_mhz = min(mm81x_tx_h_get_max_bw(mors),
+	tx_bw_mhz = min(mm81x_tx_h_get_max_tx_bw(mors),
 			cfg80211_chandef_get_width(&mors->chandef));
-	if (mors_sta && mors_sta->max_bw_mhz)
-		tx_bw_mhz = min(tx_bw_mhz, mors_sta->max_bw_mhz);
+	if (mors_sta && mors_sta->max_rx_bw_mhz)
+		tx_bw_mhz = min(tx_bw_mhz, mors_sta->max_rx_bw_mhz);
 
 	return tx_bw_mhz;
 }
@@ -1718,6 +1718,9 @@ static int mm81x_mac_ops_sta_state(struct ieee80211_hw *hw,
 			mors_vif->u.ap.num_stas++;
 		else if (vif->type == NL80211_IFTYPE_STATION)
 			mors_vif->u.sta.is_assoc = true;
+
+		mors_sta->max_rx_bw_mhz =
+			S1G_SUPP_CH_WIDTH_MAX(sta->deflink.s1g_cap.cap);
 	}
 
 	if (new_state < old_state && new_state == IEEE80211_STA_NONE) {
-- 
2.43.0

