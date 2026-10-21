Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792583147;
	b=d1GZ/1LmvP1UiYPVytmbbOBLI8mQX5gqM817viTnJMSI8KzDxInC6aaxj9TUwd2vrxco
	 H7DDyHUw4w1rtnkDpuqMGZw4NKhWno+8cI9ouUfWYAtJACtPFTnOmpSThwsz+Y2VCOrYF
	 kuS/XFzy6VR9rsRflR3aqZsekceqV0tOCFMvAzh81Xau3tDRCcyZJZeOzDSGKP+anodgM
	 O8ZUCAodG6wiUUsEAdkVIZBHgciidcwufSW8HjDPXl2QcE3p6WRHr6aH4RfF1Cjiew5XA
	 EiAt1IhNVyusqBetnvmAbwJVTw/aqfXNM8y+rh5fkx+AP/gKgdnkxcFkygJTNO7Pc7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583147;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OLSzbZwTah1lb4z6xJl5nPx6T5ilbqNZndGrpqDN92E=;
	b=HuOq166yQP0GR+HX+Uz5FNxUgC4FSUXG28WHDQk+fPVkDL3jhH4FfXNQp2wq6gJwFzJi
	 UFdtAWXg5kvr34Kwr7rgKAR4slGYQgMnWPWWs9o0sab5lGuIsorTU6RcheP9kxfF/5RD8
	 PD6e9QzSpzPzdwdryUtSrXGiDAKnnrcPxMM3iIQjj4YjP8q6FsveN4z8vSCxJpZzaXoLA
	 f7jcsX5HyHvhgP7iq6QaGpMDkq8Ql+bXPGss/np0LDIAhq+HKl9PrFbQsc63Xd2SO7dGo
	 4l0VNboidK3pGHgHEkZXB2NEAULrI/kYm7386J6B/0R5pk448+vww6OsaUz8J4FvhlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qVparbtV;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75423606A333
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 11:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75423606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qVparbtV
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48c5358fc28so585091f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792583146; x=1793187946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OLSzbZwTah1lb4z6xJl5nPx6T5ilbqNZndGrpqDN92E=;
        b=qVparbtVQ5RuvrLjjqkXkEuK2bHHxRpL6y80TDSOiFHUd0j0isCUPsEe5wQS6bImWv
         VIT2sLp4DVsIhRsA12xHcwgkrF60nMRCfqRfeDPaJYFIawm3v9xxUWu+7CXtf+jeWaj9
         NpET8tPBlMyT2MEpiW6QrhgZu+Cyzfi6Wje9FETmOZ9wrHnxTXASlSkfcGd+/9ZSHnEG
         rk4O23rMrv29/POHAsL2xpdKi5dO7XaFti/YpY2FoTHEVj4I3nzZTO4e2co6cJVvql+s
         r8Xh/AOcRnXt/NdKC5hKBH2Wh6cU8tAOl+qtzy7Eaf9NAIZrguag+2/XuHjBN8kJTFmb
         cDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792583146; x=1793187946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OLSzbZwTah1lb4z6xJl5nPx6T5ilbqNZndGrpqDN92E=;
        b=oIhnpHZ8P87z4Mu2pWeXtufgdsj7brWwD91s1auJBYEqngRBWC4IQyCHnB3L7ZRLrB
         A5Q80IsWxZQlPV6F+Jj+K+PDr44B3M6THj0r+XQyEiInklNfkKw7li4UCSc+GpiAJRyB
         rifBtZ3zJJTSo1psy2oqNjdgE4RfavUaag9X5EQLlFeocm+jSNJF5FjZn4PmAyI5CoFK
         bDrjufJtmDt2b6J8kB4kcE0OETBCfW6/lG35ddfdtnBaIK/8HX7+nVApgHEl51gjUFBN
         ws+NyM4dqLZGycxAnyeGyjzrDa4+y9mcdOFOtjlx/WjKGRFhcyxI9r6Vv9r0Jd6DEMmM
         AvpA==
X-Forwarded-Encrypted: i=1; AKwUvBwEmCd1+eWQbtJZqrUhnaWdGEB63RNiKEYf57d4WJ7KMncmKk6opNsmyxEIG9IuzWYZ+yv+f7p/Ub0hVRilzw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLzmBgO2A6PQwO967+hJb4qYidBbeOQenDDxUPOKfW0CA0cp4g+
	fBhnjVEzAtiOmBo9OWO08Uy2PmklMch15mBV1H7IpZPZ9mWLIMB5CJZ2
X-Gm-Gg: AYBFou0/radq1lFovxxRpO3Tuin2PXds6pFptjkGmv43HJE71KofKV1OY2Z/6ASP/NV
	5iFiW5WpSfUhqZbc8EYSAbPJ8Y/SWcgJX8DicKOe5VHH0DSuPHkJj6QttNlsYdPfGf9lMnKR49h
	D0x9YufF7qM+FCUFTNalp0QprgXJcrSOLEppe6yeTNZkt3dY28LZWOELjiRfZHivg79YbedYGct
	vUPY1ur3CowLm0t4X8pHmnW92cGRT+/5l1dmFTQBm0a7MzpiF5p6xx4EVLV8rbUloc9WH1Z+Hog
	J8OCchQFgobBacmrtuaAqHtlFI53GB6VMYECduTt1EYlURjxzw3zuxhEHwfxxtH8GsRKe2YoEXV
	XmbXLiSlRWTVvSCbQ0iweBZRwkNIy24vAOmpUfURUEPB7lwy3aGtGZ345Jm+RflcP+Jhs9il9r/
	mjaTa9XpN1md/R8q6Az+JCz4dD8aujv8TAlk+4xBRUZqq9DaDl4XZFh3UUAqZJNZYyS8HM8Dbxw
	CehdseKxmw4C6MH4sGnl0PjTUmjPKDH/nWpyeQUQb5YT/Yb6kFQh8u6/7bfzA==
X-Received: by 2002:a05:6000:46c8:b0:48e:f10:ce6e with SMTP id ffacd0b85a97d-48e264a38cemr2234684f8f.13.1792583145627;
        Wed, 21 Oct 2026 04:45:45 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828ca3sm4944112f8f.25.2026.10.21.04.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 04:45:45 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v8 1/3] wifi: rtw88: download the beacon the reserved page was built with
Date: Wed, 21 Oct 2026 13:45:41 +0200
Message-ID: <20261021114543.4132776-2-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021114543.4132776-1-mehmet.fide@gmail.com>
References: <20261021114543.4132776-1-mehmet.fide@gmail.com>
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

