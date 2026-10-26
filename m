Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028585;
	b=j0MBmsQUGWHyWLKgge7QQUvQMdcJ/bjAkgx8ndscYJygIyyem6bONnKhX5FENYYvE95c
	 HchMbzwyxroH33ZpS+Z/8TLOFFqDBSV4yOSEp7yvO/81coRIqnY9X4A0fIoTKkOF5qyXh
	 6tzpm9CnAB99KQ8/owOYNP9yoq56yrxwxqUPd4UfjdXM339mE8DhJT1/KiqnFd3Bfg6tw
	 YSa+ZadIeToM0KFZFnk/0DE7IchnrcMvCb7Btnz7cNvAvhSM9Kv+Z1M/F7Zjlo7IqfJh6
	 9M226dLn0xFo5XPREQJrH0CcBvK5l1LcTLkaeBRlMY6is9UbXzZexu8YYIkGUO/T9tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgmulRLKrW7tQEaXo/z3vIG+CpDs5q5KiagK/MmeFLo=;
	b=CTcl25XRET4Ca1UyDbF96zMuCkwazlplKuL5XXEpqDMRYo6HIdWELQaRcG3V2Kyae+uj
	 Pd3lJezfp8HTB7jRLP2I/bSCK2stc9sfNhW2g1h19qabQ9h1iA1+0wBKWuz1cfqEAhXq+
	 s6ii+MqFhejDp9lMSa71j9NoGa0xhD8IxxfwlrGTIxQ9y+RzRvq6D6IlrtRNfEE/lS386
	 lBbML0Ju3dX455N/E7eRQ+h2bswztHRdr7KJbPPQIyW4BmRTU911hJA18t1nfJtRps5+C
	 /SmBMU8E94KVQhL3RwmnlYH1YHooBJAYyFY8qjgQ01PFKl3ph/zSzRUoATBEO0PsJJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W+sDuWlW;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B28606A324
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2B28606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W+sDuWlW
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so23986445e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 08:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028583; x=1793633383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZgmulRLKrW7tQEaXo/z3vIG+CpDs5q5KiagK/MmeFLo=;
        b=W+sDuWlWiNzSRkkpY65k70p/Rmnz9jLZTBL4Eqy6KxH+22jfRdLRkUs7LOkVDfCnBR
         Rpw7xlv+6Ay3sCZ/Q13g8431y4UeiEvw/Qp7wOIbQdNGiK/+qEwjNB4byvvIlPULNeKD
         VswW86ODYjTvxMwN4bOwOZelKWYYz4TFjoNzAXJ8P72NoBjDtDsv+Mc9L1rPKJiMhX1j
         xVHVOdhOv50Ap70wRrGTA/oaem+V4dfHbyhA6NVcEmxGmMuYOGtMyk/W9+6Ekc5OzWDj
         ijYtm/0xbDWjHeog8vcXZ+kZUA2qGz/Jq/BRi07AjclrYpnCNRT4nftLr7weGUfqIpOk
         Oy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028583; x=1793633383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZgmulRLKrW7tQEaXo/z3vIG+CpDs5q5KiagK/MmeFLo=;
        b=PSMEa9KWu7f/O/jfpul9295NXVAusOrnNCXim0itbC+d9sutb+5c9Yl/CUU6y4AtIv
         2aLhzMUbgRPViuohAn9rGR0wIfHDwUiqDZ30IvOEr1njIkq9bi/UrHZJJ+SbUcXAIsJX
         3aSMPQMXaW0jGjjWoJqaIOj9f8H8VStV1UZpTt2/Clbrb55PNtq3fAWD1K1MbHEPtclq
         wdoMrz2vmQIn4/hbS3sVV5Vwj+nxLqZ89eyWezKJHgsKLzdqiw+YyvqYvAjhnw0BoKxz
         MOIwcbuCMnmhgy9/VAlgqlUt8OJfNFz34yLUMVbT0crLB8uYOcDbtL1gVcYIl3GFKAOS
         Numg==
X-Forwarded-Encrypted: i=1; AKwUvBz9yuf4pxvo1HNw5rvAVlHEtN06BUJCMfhmCpPMVXjY18jJ91aSmfcLksLqYAxhmN1skg8B5tI2IQFmLhGqgw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIhcNkbqCSdkiaCuabgRbTFYfyj42+wCnNgphhuvqHq56EwXSDn
	HOy4eC6i2wj4ejNg3s7SmkLKoafaPb8I/lcASBtQi9EW+BLYfVx7f4Fc
X-Gm-Gg: AYBFou0tjW71cCJ/S1j2YTM4QyZoa9GjYxXlSM/qs6AuTh/OBIF68DVQw0HH+wJA6mx
	TO46Z6XwRzjKNIshs5qvSgefSnQJu+Mw6AMVGlfsTYTeGKivvvdukJuR2Xk+6pTrr8M+yz3+TXc
	QA2Vyzz/NtL9canpwnDdN9qKnsh3tJggQILSnlXISzGyknDg4fBWclpSED2FH/T3H9UMihiwcSr
	8lY4qbdzs4VmrTcAwFSJaVfZjjIxaT1JotMSc3pzPNIXxh/aqxa2Z4h9jOc1tym3ofXE5BIa5LQ
	51Nq2btkbKjhCS2ue1h5VIqomERcbjZzxMpERkxhI0IxVRW38Pdaz7/4kdZsLhI4/Lo42AVIzlr
	qpq+SmxRRkYUU3grpcVNyiStRDq4CoOf6iYES0BJn4Rv2XYgCP9AUdh0YvbaobFsCHQ7r1Z1Z80
	ExZUnWv0n5NH4tIkZjzsc/TwWhnuMzFiAyVaRxDN8jt6hNxs4qTQ3ZKF4wr3ADiHFILMRM/JDbs
	oN4yQHabFEFK2rWfWRdxk2f/fTri+Fw1OQweN99ByFVTgXCyr8bSKBy1Av/lg==
X-Received: by 2002:a05:600c:6088:b0:4a1:fae5:f2e2 with SMTP id 5b1f17b1804b1-4a35ac3b010mr120429325e9.4.1793028582721;
        Mon, 26 Oct 2026 08:29:42 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4ba7sm17255244f8f.33.2026.10.26.08.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:29:42 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v9 1/3] wifi: rtw88: download the beacon the reserved page was built with
Date: Mon, 26 Oct 2026 16:29:38 +0100
Message-ID: <20261026152940.1274382-2-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261026152940.1274382-1-mehmet.fide@gmail.com>
References: <20261026152940.1274382-1-mehmet.fide@gmail.com>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

rtw_fw_download_rsvd_page() downloads the beacon twice: once as part of
the reserved page and once more on its own, so that the firmware ends up
with a TX descriptor that describes the beacon rather than the whole
page. The second download fetched a new beacon from mac80211 instead of
downloading the one the page already holds.

Besides the extra work, every beacon fetch advances the DTIM count and,
while a channel switch is announced, the CSA countdown; doing it twice
per update lets a countdown that starts at 2 reach 0, which mac80211
warns about. Hand the beacon skb out of the page build and download
that. The hw scan, which downloads the beacon without a page build,
keeps fetching its own.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes in v9:
    - none
    
    Changes in v8:
    - none
    
    Changes in v7:
    - none, rebased on rtw-next
    
    Changes in v6:
    - none
    
    Changes in v5:
    - none
    
    Changes in v4:
    - none, rebased on rtw-next
    
    Changes in v3:
    - the beacon out-pointer is initialised in the caller

 drivers/net/wireless/realtek/rtw88/fw.c | 34 +++++++++++++++----------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..3cd17a3bb494 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1622,7 +1622,8 @@ static int  __rtw_build_rsvd_page_from_vifs(struct rtw_dev *rtwdev)
 	return 0;
 }
 
-static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev, u32 *size)
+static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev, u32 *size,
+			       struct sk_buff **beacon)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct ieee80211_hw *hw = rtwdev->hw;
@@ -1702,13 +1703,15 @@ static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev, u32 *size)
 	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, build_list) {
 		rtw_rsvd_page_list_to_buf(rtwdev, page_size, page_margin,
 					  page, buf, rsvd_pkt);
-		if (page == 0)
+		if (page == 0) {
 			page += rtw_len_to_page(rsvd_pkt->skb->len +
 						tx_desc_sz, page_size);
-		else
+			/* the caller downloads it once more on its own */
+			*beacon = rsvd_pkt->skb;
+		} else {
 			page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
-
-		kfree_skb(rsvd_pkt->skb);
+			kfree_skb(rsvd_pkt->skb);
+		}
 		rsvd_pkt->skb = NULL;
 	}
 
@@ -1723,11 +1726,12 @@ static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev, u32 *size)
 	return NULL;
 }
 
-static int rtw_download_beacon(struct rtw_dev *rtwdev)
+/* the beacon the page was built with, or a fresh one for the hw scan */
+static int rtw_download_beacon(struct rtw_dev *rtwdev, struct sk_buff *beacon)
 {
 	struct ieee80211_hw *hw = rtwdev->hw;
 	struct rtw_rsvd_page *rsvd_pkt;
-	struct sk_buff *skb;
+	struct sk_buff *skb = beacon;
 	int ret = 0;
 
 	rsvd_pkt = list_first_entry_or_null(&rtwdev->rsvd_page_list,
@@ -1744,7 +1748,8 @@ static int rtw_download_beacon(struct rtw_dev *rtwdev)
 		return -EINVAL;
 	}
 
-	skb = rtw_get_rsvd_page_skb(hw, rsvd_pkt);
+	if (!skb)
+		skb = rtw_get_rsvd_page_skb(hw, rsvd_pkt);
 	if (!skb) {
 		rtw_err(rtwdev, "failed to get beacon skb\n");
 		return -ENOMEM;
@@ -1754,18 +1759,20 @@ static int rtw_download_beacon(struct rtw_dev *rtwdev)
 	if (ret)
 		rtw_err(rtwdev, "failed to download drv rsvd page\n");
 
-	dev_kfree_skb(skb);
+	if (!beacon)
+		dev_kfree_skb(skb);
 
 	return ret;
 }
 
 int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
 {
-	u8 *buf;
+	struct sk_buff *beacon = NULL;
 	u32 size;
+	u8 *buf;
 	int ret;
 
-	buf = rtw_build_rsvd_page(rtwdev, &size);
+	buf = rtw_build_rsvd_page(rtwdev, &size, &beacon);
 	if (!buf) {
 		rtw_err(rtwdev, "failed to build rsvd page pkt\n");
 		return -ENOMEM;
@@ -1782,13 +1789,14 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
 	 * the beacon again to replace the TX desc header, and we will get
 	 * a correct tx_desc for the beacon in the rsvd page.
 	 */
-	ret = rtw_download_beacon(rtwdev);
+	ret = rtw_download_beacon(rtwdev, beacon);
 	if (ret) {
 		rtw_err(rtwdev, "failed to download beacon\n");
 		goto free;
 	}
 
 free:
+	dev_kfree_skb(beacon);
 	kfree(buf);
 
 	return ret;
@@ -2345,7 +2353,7 @@ int rtw_hw_scan_offload(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 	rtw_fw_set_scan_offload(rtwdev, &cs_option, rtwvif, &chan_list);
 out:
 	if (rtwdev->ap_active) {
-		ret = rtw_download_beacon(rtwdev);
+		ret = rtw_download_beacon(rtwdev, NULL);
 		if (ret)
 			rtw_err(rtwdev, "HW scan download beacon failed\n");
 	}
-- 
2.55.0

