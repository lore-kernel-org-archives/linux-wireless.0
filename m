Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793564869;
	b=y4o2dwq6W/gwBTfnvCQh8pcBGFwwtAvi+GT5VInp1tZRfJIokiJDTxd5kfU50qOczNKp
	 d2N49lo+eIFW7FaTpN3Wt10iAkXp0ntFs5E/K6diDeO+9OkKmt9eWl81Vsk7urs3er41I
	 sSJCAd4D2ebC0GvRaoQYYRAA/MWqR6xrckMN/d/3r+vmI/r1LKWEXpVKjm09pk41Vz6J3
	 NZg+4p+Q4DGcfxhzn/Vkflq7IRgKDFI7fER9wxG9uzw4R7QM6NW//9qsGvQKnqB9R5SSw
	 K63Gf1QdwhK6ow0MagrrFHzHnDKe3er8xROEeEw1bjD9Jtv85/ilHw5N8FuJLazgqlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793564869;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VzoqmSGTK2p7iNyBmDYghxEoApvenhg3wCg4KbKbjoQ=;
	b=PTQZl5ZPbZRu3KHdZHySU2QJCcwfd7VNLgJzTm+edvOn6JCoM2VaM4oHpe4sol3fZGER
	 y0vJZnHm/efvg+p1MN/deruEO3XkPalVd+HZJ83ZQ9LVM6IGbxWhJ34Bn1WfRJJzIsUbe
	 n0jKdtTzI1KAHPybyPQxfpqhyl1ZPk9L0IsOUF4RNv3zRr1+vJ5dXO4yvMTfyjbob6h1j
	 dh9yI3/GV2GFztRL5MLa7hMjJi8hVvyp9pSOAVKdobBAy9vQ8Nl2imqIZyHGBY/1cG3DO
	 MxJSCRX5ecWGTk2l9B2gd+p6P/NuZjEf/Lp/uJ/T4nLUH18GTViIPwQPBA6fF+1nHtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mtu.edu;
	spf=pass smtp.mailfrom=mtu.edu;
	dkim=pass header.d=mtu.edu header.i=@mtu.edu header.a=rsa-sha256 header.s=google header.b=c4w417zC;
	arc=none smtp.remote-ip=74.125.224.48
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F65606A325
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:27:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5F65606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mtu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mtu.edu header.i=@mtu.edu header.a=rsa-sha256 header.s=google header.b=c4w417zC
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6790844c9b0so1570043d50.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mtu.edu; s=google; t=1793564867; x=1794169667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VzoqmSGTK2p7iNyBmDYghxEoApvenhg3wCg4KbKbjoQ=;
        b=c4w417zC4zAv2wWSq6YtWYQN0CSFIn4rw0NGe120+U3sV7WX/EzqNWT9Qgg/Z5IkcQ
         d7QE0PSPPMXHY1zVpK/eJ6z2XNgDDTBruwnil17xGlpHLcBZCk6ra6wcuW/siKXmBwWl
         3PmVGNPG05FNL8MjDOUk9YbQsblqpYFcaK7t+HWXV6o+sJi2Y4+VK7ly5wqeN28Vx2Je
         KBBsY8W6w+57BMdbxeHzX2IlT0NC3vwA06MUMrJvTRe9khiEau6i7zJwbRCHeCJvG35a
         j9DjOPf6nW2jQyoHyGmCYS0kLXoRPmzwW1N59v+tn//1LKhpMMYUvoOdJy34xDx+YEXa
         4pmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793564867; x=1794169667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VzoqmSGTK2p7iNyBmDYghxEoApvenhg3wCg4KbKbjoQ=;
        b=2PkqiKuKLIbIDRTkWEFQq8XAiUZbbKdMmz9mM81gmCn7Mjo1Ax41TMMum3az+N0YJ4
         T4Y/8le6syXXylWGDi46JqhF0570S+1Jl7Ot/P/hPEUPh5FJvlpr9LEOwT+bl3TjPdsK
         HnLB40OFmSahl9xhqm0LoItn9t1XD84GMegbJfD/888PucdMjc24PHqiq0hUo3BRo8eT
         Pz+haVMp5M7O7kr4QGXp2k7DALDRZYrXL9uso41Lc+tVZYlEXA0dMsIAYQAPS/ds2R4Q
         NOyVAkDX0sjyTh6+kFbML2KYKanFGLB8VoQWdu3kVXLIkIWq67btJW8IcVXMHDnAjb2N
         G46A==
X-Forwarded-Encrypted: i=1; AKwUvBwdfQqN/RjFK41wjh0qDDCYgPxjbDyRtKFpwtetw2gUZhKVDyhBN9VQrpXs7RZ0tztFINUTS97D84HW+unH3g==@vger.kernel.org
X-Gm-Message-State: APuU4Z9C6EtRUqtlqLFvWwVI9t/sYa123ZyVnkOqUxz4LIHM/N/xQoxj
	0Hm2Fpabf+Gp1wTyyRXYO7O5fVnkzGGDzdYM5IMReiKnkYKoau2YsqdvvzT4DQczIqfGa5g7T6f
	9ghccYmB4
X-Gm-Gg: AYBFou3WaPSEJpYQuFHb8xoyfZQM4yMC4+xMwlQu88xoUjhS10xzVN6ZvOUPmR1+PsY
	A7tq52DzL6Zj7Mj9yoBxfBjpZVTl5RQBJFDUNhlHtjVDmr9soqbZaJ1NIqQFF46dIy8QkUwsNem
	pPDr4xS7ExTpL3hsStKWsO5tG0UlHU0gdL71huVrfJI8Bm85cPMnglQHHAr+aw1srD3mPssdos5
	dSg4w2MGQjnqf7eDIEsvctREB06rHMEDEiUxOXMP/xdLTdDT2JL2RnihVGSGswpFngJ0MhIjzE7
	xcBz079seohzFf9rVA5qwZcs8v7XxhJ/35LqCrX1dqnyhczVJr/toXzekEMev37wlaZe1BwoeIQ
	V/+amKrK8jHJfKHWNPHCtCIbDl4EimVXoCnztCz5x8h32MHoebDSPPdp1fAILx5OHnYOqCEZsKd
	UFhembgEcO4wAdfGbVoews6Dh4NoyPSJPLY2TSDNOVccrRNuwQIofp2ujMHOkYO0qJ6IyXbOGBl
	7EZWrZGyD2/3oWoZOOnf5jQslltc6aPyW0a/+jwOKxWmwQNlkSWd1EiqUzhlZDX4UbkRG23vwBf
	Zdc8mZSndXkMgzeGwOAII2v1hhZM2rlvU61L
X-Received: by 2002:a05:690e:4887:10b0:679:a190:cf25 with SMTP id 956f58d0204a3-67ba4f913c1mr3978327d50.53.1793564866791;
        Sun, 01 Nov 2026 12:27:46 -0800 (PST)
Received: from agent-virtualbox.mtu.edu ([47.6.6.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b714cb1csm41251707b3.18.2026.11.01.12.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:27:46 -0800 (PST)
From: Aaron Beckendorf <albecken@mtu.edu>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Aaron Beckendorf <albecken@mtu.edu>
Subject: [PATCH] wifi: mt76: connac: honour injected HT/VHT rate and bandwidth
Date: Sun,  1 Nov 2026 15:27:27 -0500
Message-ID: <20261101202727.392683-1-albecken@mtu.edu>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On connac2 parts (mt7921u/mt7925u) the fixed-rate TXD path uses the
basic rate from mt76_connac2_mac_tx_rate_val() and ignores the rate
carried in an injected frame's radiotap header, so monitor-mode
injection always goes out at a legacy 20 MHz rate and cannot choose the
modulation or channel width.

When info->control.rates[0] contains an HT or VHT MCS, set the TXD6 rate
from it instead: mode (HT/VHT), MCS, NSS, and the 40/80 MHz bandwidth.
Legacy injection and the normal (non-fixed-rate) data path are unchanged.

This makes 20/40/80 MHz HT/VHT injection work on mt7921u/mt7925u.

Signed-off-by: Aaron Beckendorf <albecken@mtu.edu>
---
Tested on MT7921AU (MT7961, USB): HT and VHT80 monitor injection select the
modulation and 20/40/80 MHz channel width, spectrum-verified.

 .../wireless/mediatek/mt76/mt76_connac_mac.c  | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 8481eac8d783..e593d1bb5623 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -602,6 +602,38 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 		u32 val = MT_TXD6_FIXED_BW;
 		u8 spe_idx = mt76_connac_spe_idx(mphy->antenna_mask);
 
+		/* Honour an injected HT/VHT rate and bandwidth from radiotap:
+		 * connac otherwise transmits at the basic rate picked by
+		 * mt76_connac2_mac_tx_rate_val(), so monitor injection cannot
+		 * select the modulation or channel width.
+		 */
+		if (info->control.rates[0].idx >= 0 &&
+		    (info->control.rates[0].flags &
+		     (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))) {
+			struct ieee80211_tx_rate *tr = &info->control.rates[0];
+			u8 mode, mcs, nss = 0, bw = 0;
+
+			if (tr->flags & IEEE80211_TX_RC_VHT_MCS) {
+				mode = MT_PHY_TYPE_VHT;
+				mcs = ieee80211_rate_get_vht_mcs(tr);
+				nss = ieee80211_rate_get_vht_nss(tr) - 1;
+			} else {
+				mode = MT_PHY_TYPE_HT;
+				mcs = tr->idx & 0x7;
+				nss = tr->idx >> 3;
+			}
+
+			if (tr->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+				bw = 2;
+			else if (tr->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+				bw = 1;
+
+			rate = FIELD_PREP(MT_TX_RATE_MODE, mode) |
+			       FIELD_PREP(MT_TX_RATE_IDX, mcs) |
+			       FIELD_PREP(MT_TX_RATE_NSS, nss);
+			val = MT_TXD6_FIXED_BW | FIELD_PREP(MT_TXD6_BW, bw);
+		}
+
 		/* hardware won't add HTC for mgmt/ctrl frame */
 		txwi[2] |= cpu_to_le32(MT_TXD2_HTC_VLD);
 
-- 
2.53.0

