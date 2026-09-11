Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C4D3B3BE9
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 01:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789091324; cv=none; b=Mx7sEVwufJWn4r/hB3PjNiPxBvFAbnKs57u2bCFXBplh80YiQ8Mq0pxMoA12/GSzXTGxYAbkna6zK6sjXwXJ3Iaf2wF0ztLmldGzBEVAyczg2stRM42P97xwwWpM1aoI+3q/J2f1U3XxP+EoBBzp5xLZjPjcRd8PGvx9kvX01uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789091324; c=relaxed/simple;
	bh=BlohuCT153xScu6Dy9vwc4wWqzDsTnfR928b6u7j8L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcveNzmM+xY/OV7FRIV3zG597ArdMmPPqCRBSABgMz/eebhTmZXeagyfFFalQHf6cCoUnygNuBus1834158d1aWO4ay7mf5j99ElXje6CGNHp5aYB5U/N/ivNKOukdCdlN7p4wBotdZ0bNjD6Zi09RYLXFQhFdt3jTIoNEcp9gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEz0z4LI; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEz0z4LI"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a99ac0e91eso822250a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 18:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789091318; x=1789696118; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GAHht+WghV3TdSDRxQQLgJBQ6j/lYQlO07gbmFFmu/8=;
        b=JEz0z4LIrlyVqhppU2edhETE8nbv2SjWoE8zbXpB/vpg/ybe3vWPbfg1D4GOJX6ssI
         qJHgR4Wev6+27bKfHgAxubpkvrYQ0l44ryGdxHN4beDIULFNZizZwb5OpypdinVibA9o
         RPuENcjCjJP3YtWUc/4h4Oj7L2cgMstPx5qxfS739vC2mqZTpSJvoV+vH14CGgND+0Sj
         fFzRsp6KrdhvrO3kraspz+Qsdu6uVGw0h5Jiibz5EPYT1DtnePgdNwgejsvY8G1MhS3f
         GajhN9Cahl/Ko7S2kt7X6IjV9wOVePTX+4rnNar3h8sUdneXXCWi9hwCJBRMSdkfjemt
         MW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789091318; x=1789696118;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GAHht+WghV3TdSDRxQQLgJBQ6j/lYQlO07gbmFFmu/8=;
        b=fNlLikNY/GsotkmEKZyJotXDKAn0izI5UqBUevJBFmam9IxpeMyAUPQrdxbcN8y8Zy
         1/dWEC23mryDRKzt0g6Te/cth9K8qbdxg7ZJLPONi6qrR9OgRWAKBrvGAINqc67LY3Zo
         N4JxXaHBpEn5GzEwfFxF3e0TYednYVTApNOAh1B8uYz/TdYi/xxWYT02ag5Xf9kvs3mT
         022VkRZYd7Iptg9GFfyBVCDQSRH/r1mWdzAA1KCEXtzm9hRRxehgoE8RRSuu/IhGwiyH
         FM+wqG+c0awdqEtBjMlKytifCJfXUVG9W/zlpUTEowC1xd0FwuIw+nmgNOjYJ93TO6qP
         tG2w==
X-Gm-Message-State: AFuF++krXO2N1wBNPjmjfHNeljJXBXNL6rP2eCnbBw9lNQE2LGyg+Ovb
	/9TGbrEC4DCKeRR7KwKyPQbclTDlAtPLlJ7aDl/OD0zVVJiFBGRGvUo=
X-Gm-Gg: AYBFou1bH2fJn86f4B8d+rJnjjLqPpmEXJkaGaZdGN28HMjlbHSBCSI8/+MwopjO1GB
	77pO5tAyI1m1hjl1HfT7njM/38ua006bZlpfM+H/xqkvOKTk5063Ud2gb4J/3wOWadPgiY7AIUn
	GmIc9EtWACxwxiYEqGxQK3w8kvYRP37I0ExBvEOKlfFsEOPApfUusMABreaolllkb7LpAqpfsjK
	i3Du5QKczkRzkYkRPu+AnKFA7IHUto8HqhY0IeqP+pUYZY4GvaoWw6qaNZJOT7FHTvHRoRRG6i7
	eVo3bO//OtmXr5Zj526sVgxYQsuxna4rOkif7wUmRXuMng0GTyhdPHr5E10x0amEFmkcvi1w5Bj
	9ncjTMUewW6tt+6WGnh1VhrXjM+e5UOKcdV5aXn0jGV8eSX+rJyRUF6askOQYHZ5epO1TD5wl4q
	zqdx3r9lGFT4jCaRlgWYKswgOQu8gN8MACvIHBQ8rAElJTdtZ/wgAm0pWWm9Ztr/tH1mbqzpBPE
	wxoWyWOB8VcHf6BY7yWC0fvyGF9TxOPGWv+bnplS8M2fuSKwnM5GWKmJmoxLbFSXlw4RUhc5G1R
	0lSN3yPXkZkL/7E=
X-Received: by 2002:a17:907:d38c:b0:c26:19de:9138 with SMTP id a640c23a62f3a-c2966739de8mr60264466b.43.1789091318386;
        Thu, 10 Sep 2026 18:48:38 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2966021ae8sm28097866b.22.2026.09.10.18.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 18:48:37 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] wifi: ath9k: stop a failed register read from opening the RX filter
Date: Fri, 11 Sep 2026 04:46:52 +0300
Message-ID: <20260911014653.1566388-2-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
References: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On USB a register read is a WMI round trip and a timeout returns -1.
The spectral trigger reads AR_RX_FILTER back, ORs in the PHY error
bits and writes it, so a timed-out read stores 0xffffffff and the
device forwards every frame and PHY error to the host.

Add ath9k_hw_enable_rxfilter(), which sets the requested bits with
REG_SET_BIT() and reads nothing back, and use it in the trigger. With
firmware 1.4 and later the read-modify-write is done by the firmware;
older firmware still reads from the host.

Fixes: e93d083f42a1 ("ath9k: add spectral scan feature")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 .../net/wireless/ath/ath9k/common-spectral.c  |  7 ++----
 drivers/net/wireless/ath/ath9k/hw.c           | 23 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index ca01a07f6630..73c1eb4ebe0e 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -716,7 +716,6 @@ void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
 				 struct ath_spec_scan_priv *spec_priv)
 {
 	struct ath_hw *ah = spec_priv->ah;
-	u32 rxfilter;
 
 	if (IS_ENABLED(CONFIG_ATH9K_TX99))
 		return;
@@ -730,10 +729,8 @@ void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
 		return;
 
 	ath_ps_ops(common)->wakeup(common);
-	rxfilter = ath9k_hw_getrxfilter(ah);
-	ath9k_hw_setrxfilter(ah, rxfilter |
-				 ATH9K_RX_FILTER_PHYRADAR |
-				 ATH9K_RX_FILTER_PHYERR);
+	ath9k_hw_enable_rxfilter(ah, ATH9K_RX_FILTER_PHYRADAR |
+				     ATH9K_RX_FILTER_PHYERR);
 
 	/* TODO: usually this should not be necessary, but for some reason
 	 * (or in some mode?) the trigger must be called after the
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e08ab73fcacb..d62b6ff00d41 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2905,6 +2905,29 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 }
 EXPORT_SYMBOL(ath9k_hw_setrxfilter);
 
+/*
+ * Set bits in the RX filter without reading it back: on USB a failed read
+ * returns all ones, and writing that back would open every filter bit.
+ */
+void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits)
+{
+	u32 phybits = 0;
+
+	if (bits & ATH9K_RX_FILTER_PHYRADAR)
+		phybits |= AR_PHY_ERR_RADAR;
+	if (bits & ATH9K_RX_FILTER_PHYERR)
+		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
+
+	REG_SET_BIT(ah, AR_RX_FILTER, bits);
+
+	if (phybits) {
+		REG_SET_BIT(ah, AR_PHY_ERR, phybits);
+		/* PHY errors are reported in zero length frames. */
+		REG_SET_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_enable_rxfilter);
+
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
 	if (ath9k_hw_mci_is_enabled(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b942b8303d8f..f102f73a0114 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1055,6 +1055,7 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 				  struct chan_centers *centers);
 u32 ath9k_hw_getrxfilter(struct ath_hw *ah);
 void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits);
+void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits);
 bool ath9k_hw_phy_disable(struct ath_hw *ah);
 bool ath9k_hw_disable(struct ath_hw *ah);
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
-- 
2.55.0

