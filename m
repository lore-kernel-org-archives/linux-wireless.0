Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529239;
	b=n+eB3YeiOucLPHGs5vuu1Nwe8eyUlmx3X+9G1Qgc7jom8VBHQeo+TAbS5wbf9wvNNesl
	 0NlDsPrrswrQz8zHWFnUNhYgxUAz2F1ftbqEpcSP0r6dGuaa7amIdvebvAfueRX4p5KtD
	 EQ9cnD8yWLLBOmaAWjQzzi8lxKGuq897ODZnOBoxo4hBGHCocN/C9mZuzmaPMl+bs4bv+
	 WLvE/S0t0gs9/DmUkRdAtYwzJmtfehZXw5kPQ4prSyI2Jl7L5iTk4inc3GLtpmk4uuLi/
	 RdakDr3PE77W3dG4dKvM0kkFXVhMGjC6eEXotnICdtpsp6obwDWbO6kZevHTZNi135g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529239;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t9+2/srT1Yl5WnbPtJ2ZD+njESSgBUCFGexaWMTctmk=;
	b=fYaqEWIHlmUr93+EWG0Ki73gUhJjmVi5jGN1JPFUYgALF3vPAEzmynMQm7M+LYHOWTia
	 JBz9X9u2b5oIjPbkJhQ/uFBYBLX2RrhfwpGoA94VmDbwzEZ8pQs5Zvr5Ga34JMDdja6An
	 ZMBYLRoUjdcqwuxMwNAzCxjdmkBQh4nTU2J4NgeX7PBPyWTbavXG63TWsPjnJnWMahOGi
	 s4WVphawAy9OROSqQ0JsOECdFI3OltC0DCToSnBnFlyUURWraLB8jDXEm+ULsHRE6gueF
	 a2LGsjtqMFIRJ1BGMD1Q9fCUj6IUZvZDAblg5afNwP2IlC+2T2CmNNhCYD/dl/2vxVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=crqextMF;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C1606A32A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 20:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C93C1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=crqextMF
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9179bfa9e9cso1541616d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792529238; x=1793134038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9+2/srT1Yl5WnbPtJ2ZD+njESSgBUCFGexaWMTctmk=;
        b=crqextMFfwmDnRvuRX6JR2gVYRyXbtV8mDsJ6NuPXSGM1mhSo/I8DO6v1oYiQ7vxmu
         lounEC1uysS+By7uGvwb6r17YxuUwgdPa0ewms3xhEebk7gO/8F8z2A3Bb9nLGgYD0i0
         8cbHVhApgKotf5X51U+KCHax7Upzr95TO7XobjOXvxoAe4w7FnYCgXo3DbEiNJ4OObu0
         ZYlwOGpcte5kzyTAbx+Se1tiPUTPrSOdL9UL7jjrOmd10R2gis8ezWF/VapA4iL8g6XW
         IsGdUbi0Jo1bmqdh24teLZKslra5kRdB+lEilwIFujPVSTXIQTRPGLMKbhww3EG3YVsk
         GICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529238; x=1793134038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t9+2/srT1Yl5WnbPtJ2ZD+njESSgBUCFGexaWMTctmk=;
        b=AulSSlboQzZt1rCa2/EWvCe1V0U2Dwd/8LNXFFgEqF0ouqUGN8Oaq0czcITJpdg1q2
         khYOdN+r3RPB0h42sy3VpQwi0CwCkqFTeuxIzUrFmOjRtGaByr5CKOAea2pdltAh74T1
         9t5rx5dA0amSs20YbeSDJONkclv8Vi/QcLJYZKRCwqhvdR/qCSNMP3YbVke9yGoZmC6O
         +Jqu9mwOtELEHvaA5d6YiZ9UHRi8CbDYjTvGoJ6GcoQRMfqRLzci1A2GKGsFx4yMC8S7
         WMHt1RPQuy/Tf9cAThBiVBPqjuYeKh2SyjFKAUyg5BVCD39ojmlRUkjsvyjls3VOaHr8
         VhEg==
X-Forwarded-Encrypted: i=1; AKwUvBzMvV9eG7cOXgNyN3irjBx/zIYRIc4qtUopsvthJwLgT56ZOnAhAA/B9FS7ucOWAfytnQsY6pTrTDAmAvXMig==@vger.kernel.org
X-Gm-Message-State: AFq9FYJy0v8YLJ5JPc5DaxnY3iYbUiZKc11V7yrk2T8IuNTZ3y862f3x
	NuNGlm88BMboZ8f+dBrMRFtrW0GHo/WSPOiwxwH8P3iPwdYUPA83F/SO
X-Gm-Gg: AYBFou1WNNAL0aV08CXUn5IiIT25x583eDclnzIjL+AT1n2hY+gesWqkqQLkaKKSsjU
	ysJrO5Xt/hkw3BoPN+ORAx1WpEZZcndlTdBx3EGr1gHPTro9v71/ERAgYn5o0BazWdt/aVpXJ4m
	BS0zFCyueA57XqRp8pIVoXRVy/lNuOhjMSdDKJllhJzWQwWVVmGPjtwgd3qTt1DrlpASrUGBJHk
	s6XBH9EcWneqvnhZlZBQI4Hj8PtU4pRHei5ZzbRXO1R84w2jyxXJ1zTefwv3+iSyjVca4Hl4k78
	nHJUdDX4hgUXLRLpymdy2hGWF4xNb4bwh/Hcc4c1hBnyZLJsaK0lG/E6I4aVzdQXuR0Jt5+YEH+
	/h8Pm+1nQBdjcFO69pm+vYc6zF/3ZQ/yXeSEj9/81Fae2AQfP0V6hO9EU/xwmtWq1C7EGpt9i4N
	tKts27CsivlT5doWV3u/C3GhSk72HwpM1LZsjvkcbgp9srrxF4fqMemuAw8aOgzajt1sVCMccEj
	BU2
X-Received: by 2002:a05:620a:1708:b0:93e:f9ba:690f with SMTP id af79cd13be357-93f57f961cbmr81026085a.73.1792529237738;
        Tue, 20 Oct 2026 13:47:17 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56c6f16dsm79336785a.4.2026.10.20.13.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:47:17 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v7 1/3] wifi: rtw88: download the beacon the reserved page was built with
Date: Tue, 20 Oct 2026 22:47:10 +0200
Message-ID: <20261020204712.3252023-2-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020204712.3252023-1-mehmet.fide@gmail.com>
References: <20261020204712.3252023-1-mehmet.fide@gmail.com>
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

