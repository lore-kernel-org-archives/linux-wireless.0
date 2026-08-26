Received: from mail-qk2-f0.google.com (mail-qk2-f0.google.com [74.125.230.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68013BCD25
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 09:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787736488; cv=none; b=OwE8Wgj10oPGzlj5mUnNAFDDbzZmCXjkchDrzvDbV1raHeWLKCIonlv4pMT3DubXEVwDasTfstZqOa1WI4+k+tzUiBj+yJM3EBhZAQCR/bv9BXu5zwQSyUDa0R+j7cHbnxOJzHVaKG1WUTSaxhufNJ5oYl82OOLWeLO1lf3haZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787736488; c=relaxed/simple;
	bh=Hv7+Y9dHESTSaxHnfqqTK4NCvljMduEQjgsI3qTkahQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LKsJMKq0UW/4Rg4cVNElidRe740868J6V7kS9g6GgMtiSxavqz+Y6dTQd01ANy0h+TvfR8PCD4p8mVvEbCxnoxLAjLuvA3mzaE3lv9nCvsXG22AMEkkOO8r0+UxoGzU973C1dwK+gcZbJQFfy47lQ8wTMjT4vvPTa1Fd2jtC3lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQ6buCXR; arc=none smtp.client-ip=74.125.230.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQ6buCXR"
Received: by mail-qk2-f0.google.com with SMTP id af79cd13be357-9371529ed6cso16710985a.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 02:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787736485; x=1788341285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nLln/nzEL/lmZp8E8NEYYdhaUC5D7iZndLYefw4Q5CU=;
        b=QQ6buCXRA5+hpQnX7RTql7lkgNGgM/evAvzcML/xujJ0HQCdOwpP39axbkBy9dvnGP
         +jG4cz8hcOlWsv3cJWA/QFvygkWstK03yLaCh6Ews0lKTGJGv3rcCLocQVNBV2SziZsX
         gNV7HgkBXuTLN7KJHAXMDi7oOrSiZEMmerwN7M0JGGHWWEBkDgczUNVh/ZarSF1QJsa/
         300gd+vMCmcMcl5Kipx96bAKZOf4oDwvzdcaS7Yllom6TGhUdmU9CTq5bJUgiNFRsre4
         aT8D4JtW47uiUo9TskyY5RZynZIhODjk+3qTMP6wvHExsj7KbXmLVKI14WLMWf8nj5Os
         ss1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787736485; x=1788341285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nLln/nzEL/lmZp8E8NEYYdhaUC5D7iZndLYefw4Q5CU=;
        b=b7feeJELl706A+8KrRvSBqNPBjXouTS4Ii+si+qcMVlFQicnAjY88lI7jv9MkMVy8R
         k0DY5ljelSkAZDulyvc2hiKZw6SXASWEL+I2FgE6wxmpSljzEPzjQkR2XDYf95jy4hgW
         otqF4o/HYoEmg9PBis5ZXeLwCht4bvGABvMgrjKALkaE/DI69TilezNs84Mr64284dyI
         DvbnACVLRcCCZgQLFkf8csd29es/avMa26FWEzs5b/ZEyO3sc22c5+pKK1POhrzWAIae
         8oNPaIRGraQNfertthV5hvKweslXwAqSb10br6Do0X7hKnm3dxdjWwZcroTe4sRkOayI
         8r2w==
X-Gm-Message-State: AFuF++kE/R+QVCFegRGxhI6clUTw/8ba4SFsmUGs6Y+5+Cxef5NseK1N
	tCivr+b+e2rOdtpGXKpEaDwpASZZWP/AwPXbHsdV1X/Gh1A4FZ6d8tG4iui5rX/3xAw=
X-Gm-Gg: AR+sD10NP+lphI2Q37EsRL9GnqIvVJFcbCZLu+VYQZM1qrdw7YvAdvyK54l8T1VWjdC
	DtjzqeJctPeO6Con2QHlnXSLdUJa8iHVXrRxHS1Sz+RO42aERHshB1TimWTZAr350wTHI/TGwkI
	FjF9RAn0HZvaQw19tN8yqlCVNHEwn/lSRsSTA6MUK62KHt5kMrWWXNMpug+Hw0jZwr81C3B/h3a
	XsAAIEgXv8vZRPv0jLVQx8L05/jw1HzeY5EhmHhpkJ61w9CTJfqQufwCK9rrp1Vu1E5NYi4sh7P
	IvAv0kt7P9lQT9IikZJiha8D6hSSGEfxf0fgYUPtRfsDBWKf8j+PiIdQyc3FleGelm2sH6Q5hGT
	FQjrkQT1YF3E0fWaT1ZGmEs1gqgdjeDj6ZELFSPRqXa1c///PULZi/WJawAu5if+Ssl9TRhHqUJ
	zkf4ACB9KZypL752e7BMBgo2OiT9D5c5+zSFbDKoDh9pzJLTtDgY+v5H6H0QpeZC0VIT2bYnaGP
	H3FDQsI6p2SLA==
X-Received: by 2002:a05:620a:99c:b0:937:2aca:4d58 with SMTP id af79cd13be357-937803e5454mr340157585a.24.1787736485479;
        Wed, 26 Aug 2026 02:28:05 -0700 (PDT)
Received: from localhost.localdomain ([2606:6d00:39f:4500:5acb:2301:2b5a:c076])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e34b9cfsm170522085a.13.2026.08.26.02.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 02:28:05 -0700 (PDT)
From: Mark Anthony Agarro <markanthonyagarro@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: [PATCH wireless v2] wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
Date: Wed, 26 Aug 2026 05:27:55 -0400
Message-ID: <20260826092755.480190-1-markanthonyagarro@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76x02_mac_process_tx_rate() extracts the rate index straight from
the hardware's raw TX-status word with no bounds check for the
HT/HT_GF/VHT cases, and mt76x02_mac_fill_tx_status() ignores its
return value. A stale or corrupt hardware index reaches mac80211's
minstrel_ht rate control, whose per-group rate array is a fixed 10
entries (MCS_GROUP_RATES), causing an out-of-bounds write.

Validate the index in mt76x02_mac_process_tx_rate() (HT: 0-31,
VHT: MCS nibble 0-9) and have mt76x02_mac_fill_tx_status() bail out
cleanly on failure instead of passing an invalid index through.

Fixes: 7c1f88812690 ("mt76: unify send_tx_status and related helpers")
Cc: stable@vger.kernel.org
Closes: https://github.com/morrownr/mt76/issues/88
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
---
v2: Drop the Reported-by tag. It named an invented
    users.noreply.github.com address for the reporter that isn't a
    real, deliverable mailbox (v1's Cc bounced with NXDOMAIN on that
    domain). Closes: already credits and links the original report;
    no functional change.

 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 27 ++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 14ee5b3b9..d77356a2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -302,10 +302,22 @@ mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
 		fallthrough;
 	case MT_PHY_TYPE_HT:
+		/* Raw hardware TX-status index is unvalidated; a stale or
+		 * corrupt value here overflows mac80211/minstrel_ht's
+		 * per-group rate array (MCS_GROUP_RATES == 10) and crashes.
+		 * Valid 802.11n MCS indices are 0-31 (four streams x 8).
+		 */
+		if (idx > 31)
+			return -EINVAL;
 		txrate->flags |= IEEE80211_TX_RC_MCS;
 		txrate->idx = idx;
 		break;
 	case MT_PHY_TYPE_VHT:
+		/* Same overflow risk for VHT: mac80211 expects the MCS
+		 * nibble (bits 3:0) in range 0-9, nss packed above it.
+		 */
+		if ((idx & 0xf) > 9)
+			return -EINVAL;
 		txrate->flags |= IEEE80211_TX_RC_VHT_MCS;
 		txrate->idx = idx;
 		break;
@@ -493,18 +505,21 @@ mt76x02_mac_fill_tx_status(struct mt76x02_dev *dev, struct mt76x02_sta *msta,
 		first_rate = st->rate & ~MT_PKTID_RATE;
 		first_rate |= st->pktid & MT_PKTID_RATE;
 
-		mt76x02_mac_process_tx_rate(&rate[0], first_rate,
-					    dev->mphy.chandef.chan->band);
+		if (mt76x02_mac_process_tx_rate(&rate[0], first_rate,
+						dev->mphy.chandef.chan->band))
+			return;
 	} else if (rate[0].idx < 0) {
 		if (!msta)
 			return;
 
-		mt76x02_mac_process_tx_rate(&rate[0], msta->wcid.tx_info,
-					    dev->mphy.chandef.chan->band);
+		if (mt76x02_mac_process_tx_rate(&rate[0], msta->wcid.tx_info,
+						dev->mphy.chandef.chan->band))
+			return;
 	}
 
-	mt76x02_mac_process_tx_rate(&last_rate, st->rate,
-				    dev->mphy.chandef.chan->band);
+	if (mt76x02_mac_process_tx_rate(&last_rate, st->rate,
+					dev->mphy.chandef.chan->band))
+		return;
 
 	for (i = 0; i < ARRAY_SIZE(info->status.rates); i++) {
 		retry--;
-- 
2.47.3

