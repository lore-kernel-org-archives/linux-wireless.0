Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A551FCD9
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790685847; cv=none; b=RjDVapLy6+RUjSS9LyaHDzrSsvAmBDRdRk8nPHfpU/sKGo9HSKwjzzfD/jrx45rpQScjA3LdFLp4wlK4qLYmgiaMtcn4D5NZ6FuPWD4J6s49a9InT5OQoM9s+L5cl0Ai4ziy3Hpj2k2N/+tP2AdEVA5DM8J8tirLtrQzzPkBtiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790685847; c=relaxed/simple;
	bh=79wZlzQ49wErlqlRz3js7EniNh8G0Wbv3rp6tivWp2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES7XIkfWmMrkzYK6Tf+WHVwxRwHsJyyZcIR0sX3M4Ts35F836TtP5XHyzePR5B7LrJhrwxmUioSRG7rVAAfpp+50ZIa2txzHFdGlHvSV5nCnwp3rN51afRONXi3kYp+LRwbfgK2c7RxfVyzX5A6bHrsM0jbA3jUwGTLlm/Mjm0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mec+1vsG; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mec+1vsG"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843f22dc83so3475631f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 05:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790685843; x=1791290643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AuwF1jUMv0RHfuO3aC5AtKxcPPYP8nuD6Ys5ZP8s/VU=;
        b=mec+1vsGZTz0ijiU0pVQnjhXsfW5oaHB9SAVWp95Ss4RrPR4ccUmQ6GJdGE7HES9DL
         8x055nJmJX+ynzaHGJ2ROvpyvywyuQp4ECz1YLMlORmas1zRc+uxpsSxdrvzh3K412gI
         y1ukz0FScGD75psKkXbOtfFQ272GuKK/GWBmfAVj4Dz/zve4K3Ko+HZVGQiv0JidVkb+
         u9yOctE9y12kg4HnV4Nt8jtR22Fsms69lbTS4sah20biYtTxyCOtXNl9wHjoLOUVZaw8
         CA8QsZ6Xxi/oCNnt2I+3Upqkg5PLcd8kY+p0st/O/i5KgmswnuSbYWSAI/P3d+/hSfIl
         oZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790685843; x=1791290643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AuwF1jUMv0RHfuO3aC5AtKxcPPYP8nuD6Ys5ZP8s/VU=;
        b=qvo3weBCWqc1tJcLXcvTzV/j0kw+KP77tZQj+VW+xZY6oau1rQKsGead+t1MhEOavF
         nHwkeDJZrR9V+5RfnFp5k16xZklDj1c2v3/sP9UO39F4uKcmLpGg2VOL21JXYST2bHQj
         FdK+RDdDZlOofD2oWX52Ei/kUIPliU2sXfNZqmEXgA8psWX1ZWy8TzAEUWus7WCjqgiC
         9w3Q26wwMmN/qzfxIh43KtxqjJc+bfvqD/VzETMdEURo3aWuEAMxqV4OoMYpHNz9+5tH
         s+Osqd4oCiQTR7VtGTX5IIqc1CSjbMaVRRhhSseyv9pQsOVqCLQUMLWWjwKcUU+PaEqU
         WvpA==
X-Forwarded-Encrypted: i=1; AKwUvBxiFBfQoYiFLohmCZgfd2k9NFvfGAEn9Du4sgBBb9D+aBzf403m7RdtEDQsHYw0CN08hCoOtctQ7MtAN19C8w==@vger.kernel.org
X-Gm-Message-State: AFuF++mRD9T5w0wapD8HD4XShzHZOnEC0wZ2ePU4ZbZbwazFhiRWPQAt
	sslLP//fZ41GCNRvUe3sMECLjZvEQATuCirpamBU26FVr5LfQo4UGxLOnT8o8w==
X-Gm-Gg: AYBFou1mENvSP5HZKGFtYD5OhRsWU7yCEk0fBWto0IBEzc8njbkRahtAU81h12fgD7x
	dbcAdoiK3Od1eaTCrCzRsHFna3dFs0P8MWqSQ9SbsM9rFagA7WPO6XoE41KmwxfkcmlsAmar8ZS
	J99EE8Ojo7xpKk7mULGMm5ZRklA/NGkgOqyxRfyMnlo4MEjUojKZGHHfLn3Iim3+L7WXOCbZ1G3
	pm5RvN6silwEt02o0gxF1CrC1H3E7+w/g3PO24NbUhiMW9EBwbA2BX3qrs4FVFfQHR4EwujjfDn
	KrINEFRBWMytiqNN18+U4XCdvE4QBsCbvQgvInl84O8GJJ3x43yCXvHwb6hhrC4hwMbc3aO2kCx
	nC6+0LFeCsGgsuHzniYspyihD3HMDffgJnDIn2Y38wiwvbMgt147+X60RNreoXFSE6CvCLfbD5r
	Ooep5wP/IoUJvSwUlV1ZdQ0tnJ0YI+PLoPMhKpzK0NyZTYXrthYKVztmfOH20i0PykM3szCW5lj
	NN8
X-Received: by 2002:a05:600c:19d1:b0:49c:d818:8764 with SMTP id 5b1f17b1804b1-49fe7b62c5bmr277337645e9.11.1790685843266;
        Tue, 29 Sep 2026 05:44:03 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a012387337sm33002265e9.8.2026.09.29.05.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 05:44:02 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Tue, 29 Sep 2026 14:43:59 +0200
Message-ID: <20260929124400.3856049-2-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929124400.3856049-1-mehmet.fide@gmail.com>
References: <20260929124400.3856049-1-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
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
warns about. Keep the beacon skb from the page build and download that.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..a4400ff51372 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1702,11 +1702,13 @@ static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev, u32 *size)
 	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, build_list) {
 		rtw_rsvd_page_list_to_buf(rtwdev, page_size, page_margin,
 					  page, buf, rsvd_pkt);
-		if (page == 0)
+		if (page == 0) {
 			page += rtw_len_to_page(rsvd_pkt->skb->len +
 						tx_desc_sz, page_size);
-		else
-			page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
+			/* keep the beacon for rtw_download_beacon() */
+			continue;
+		}
+		page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
 
 		kfree_skb(rsvd_pkt->skb);
 		rsvd_pkt->skb = NULL;
@@ -1725,7 +1727,6 @@ static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev, u32 *size)
 
 static int rtw_download_beacon(struct rtw_dev *rtwdev)
 {
-	struct ieee80211_hw *hw = rtwdev->hw;
 	struct rtw_rsvd_page *rsvd_pkt;
 	struct sk_buff *skb;
 	int ret = 0;
@@ -1744,25 +1745,25 @@ static int rtw_download_beacon(struct rtw_dev *rtwdev)
 		return -EINVAL;
 	}
 
-	skb = rtw_get_rsvd_page_skb(hw, rsvd_pkt);
+	/* the beacon kept by rtw_build_rsvd_page() */
+	skb = rsvd_pkt->skb;
 	if (!skb) {
 		rtw_err(rtwdev, "failed to get beacon skb\n");
-		return -ENOMEM;
+		return -ENOENT;
 	}
 
 	ret = rtw_download_drv_rsvd_page(rtwdev, skb->data, skb->len);
 	if (ret)
 		rtw_err(rtwdev, "failed to download drv rsvd page\n");
 
-	dev_kfree_skb(skb);
-
 	return ret;
 }
 
 int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
 {
-	u8 *buf;
+	struct rtw_rsvd_page *rsvd_pkt;
 	u32 size;
+	u8 *buf;
 	int ret;
 
 	buf = rtw_build_rsvd_page(rtwdev, &size);
@@ -1791,6 +1792,12 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
 free:
 	kfree(buf);
 
+	/* free the beacon kept by rtw_build_rsvd_page() */
+	rsvd_pkt = list_first_entry(&rtwdev->rsvd_page_list,
+				    struct rtw_rsvd_page, build_list);
+	kfree_skb(rsvd_pkt->skb);
+	rsvd_pkt->skb = NULL;
+
 	return ret;
 }
 
-- 
2.55.0

