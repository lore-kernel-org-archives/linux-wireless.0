Received: from mail-qv2-f7.google.com (mail-qv2-f7.google.com [74.125.230.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB121FBC8C
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 09:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787736225; cv=none; b=DHj2/7+y3BB6VCaWY0jaoJSFlkPF4MwVGZECzx6l2sPSDfuMajw8HZnIM+5LCUCZTzg5No8cpzzAb2RMHAHOihIevWPVeCvIkg4ojF9gNqoyxkWeDlQSUmOLPRUx4SPTtmfdMnA7ENMyaMPsxR1LIYVWxQGvTGGEsgdD5mfJqAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787736225; c=relaxed/simple;
	bh=J5zNJQ3X4/N9a6M+pUzl/r33rH88D8R2hEMYOhygnB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HbYjMSs0AihnZpI7gO757a09ZNFVLcVvICgnf2AyuC1iQQrMm6LVBR9pcWvwf2TATV5eKuvdBT/2YZ8KW3jclh2sGNa1Q3khYs1ycGF3P7WoTqBJXGySckTL2wwI4F70A6eBoHiiWp+aHA2xKzD7+zKA3z6B+1YNqUZzxUj2iWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mlXB1oXI; arc=none smtp.client-ip=74.125.230.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlXB1oXI"
Received: by mail-qv2-f7.google.com with SMTP id 6a1803df08f44-90ccffc2654so505586d6.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 02:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787736223; x=1788341023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iLS2FTkBwTZO9cFIxC30lB3zfdCwRmbbW10fAQY6Wo8=;
        b=mlXB1oXIPYXbvUujLmUz61qITi1xf3hJUij42nHx8jN7O2dYnZa6ao2T2sdji6WaQb
         MuaNGIyXokHrORx9BUJJvuUp9/0oZ3M6oYJFrlsMhiZiGG1z2ZL4ChIi4kTkAgr3fHVJ
         DYCJ//miFlerQi7bIj83c7+wWy8OHJGc5wP3NwMixH0PIEqBYjisQb7jWNR+T3k1ZFTW
         IKnVGPGdVRhGuNGov/ojgoYSoAH/9266pzeYWwySYQbB2qJzroV8UJZlNCG/MDdhmPbt
         UZpQeQg5OZOeyT9iBlMNIJfkvyftGiWDz/murxiG2ucVs+gqRurHzseIYnn1APT5rKdX
         un+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787736223; x=1788341023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iLS2FTkBwTZO9cFIxC30lB3zfdCwRmbbW10fAQY6Wo8=;
        b=IV1z8il5PePvt+VCBRA5j5ny2N/rj530gNIm9miBbi8NemEsmtpQefVxnwEzLzI+Nv
         4QcuAVEdgUc+AVq6nPsxL67yEdDTc1RHjJ9KrId1BcCKQLy0+19rQZrYDTu90Gj5K8NJ
         Dzkh+J0msiuQxNTtqwnaqmKypMO+NSRaXCuuBBnoXjIjL3bwIG+HhO4jyGKZufYxoWDH
         I8BNaGzCdyriSMAJWmrdXIqrVHCgdoZCLjM6fizq6Hi1Q0GJj+rftuIDM7bc2T0sveJ/
         ddyCMp4m1g3uWvBnlZ2uu5D/XeU3zYPbXRj2Pt7OlAsg5RJPuFUXJibEaN3sqpuyoUQg
         bIXw==
X-Gm-Message-State: AFuF++mOW0mNjc7N7/jl7sJxhQ/MNK9RC/WTy+CFXaLtH+GBZmiOPbAO
	Nz+fdOgW3V+5rMJ7JN7Z7Vf/cYIXPBltAhqc/vn1TSNxLojV8kqchXHA3Q33IxQVACw=
X-Gm-Gg: AR+sD11KtbY3prpuOnIYmheKbec4Jka3+9y538OUn07fe5JuPb7MyljhwDbddKaCmBP
	6bvyT3V2kN/hk7tvczXBPPIUMDF5MUtPsIB+9M20g/ncHTVrXr9EDOEMlse1e6m2FTLB/AnT/ae
	xGJo64N2I3TBdZJAcdXvTEIZXrrORzpmYY/OB9vVyCjsV9VwBrEgdEQVC1uHhyKakUpEFnMfsV4
	DqIv8CZ5Xuqj2pzv3kIDOS7TSWstltl5qFGvlepmsGDmWw0f1HgAgGe9HjI8XDSEtfMq8ibTuNA
	Y0F6Q5omwKazthfk4uMJcYtafvZDmUAWr270OZZdS7KMBBVgvmGphdimEbP7+7tOE2DM1paIhFX
	xu/vhC7TmLN7dQagyqcnLriubNSDIODOPpLiSs2ojaySTaV1dOTGqetxvqXrtgtM5iR+oNtCQUt
	Wtlbyh0DVd1N5eCdFfRdgw3TCe3h5bEpk4DJT4xvFwXCVuOa6gq946RC7VOQjEkAhdXILLrYzlG
	t7PVx1xrjvqag==
X-Received: by 2002:a05:6214:4102:b0:90c:c39e:486 with SMTP id 6a1803df08f44-90cc7976c14mr43064136d6.31.1787736223075;
        Wed, 26 Aug 2026 02:23:43 -0700 (PDT)
Received: from localhost.localdomain ([2606:6d00:39f:4500:5acb:2301:2b5a:c076])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63e3108sm21248046d6.11.2026.08.26.02.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 02:23:42 -0700 (PDT)
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
	rajeshkc-lx <rajeshkc-lx@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: [PATCH wireless] wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
Date: Wed, 26 Aug 2026 05:23:31 -0400
Message-ID: <20260826092331.476016-1-markanthonyagarro@gmail.com>
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
Reported-by: rajeshkc-lx <rajeshkc-lx@users.noreply.github.com>
Closes: https://github.com/morrownr/mt76/issues/88
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
---
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

