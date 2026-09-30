Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3963E3DB8
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754291; cv=none; b=HcSX2eP2tAvsgIB7vDjT5NiEI2g4ywjTk7nB3xHJMgm3ebuAXTcXgYOxk3PCV+aEBfJW03S3CnddGkwAeqagjPJI+asyYdnlt6ghoAhHlKy8mWdHtA6GS9B+JcJ/qWE/ggmUdLxpcJ1exzbvW9C2kHqKtkndZHQrX1CXEdZV0/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754291; c=relaxed/simple;
	bh=Yy6dRQgeJ8tMc5+MrxlgmHK1jiVIY+TczXighUwSduU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPLE6zDXE3i5ro1k5MDAZsSYXVFNyE/4GXBv//caixYOIVvel7Q12NmH9df04dCKzQ544U0y4tf4UVAyHUYO4U7/8TAjIvulbYiJpQYkPsXcMjwIc4l5elLMgocgPJeu/1SwMewbtutTTOqL/C417jvXDNmZaeklYRAc7hEUnF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EGzVaZd0; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EGzVaZd0"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ffe817151so20875115e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 00:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790754288; x=1791359088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3uPv6p67nR3Am4gjvZbFjvoBpqKH7vmcE+P+gVbuLG4=;
        b=EGzVaZd0iyNomJzIvLqh9+bjoBuIj+GLwENCbse2iUlOiEomXYvIAAeW4shYi3YtgV
         1S9FWBBYpPFQ1r36yNzdoJ0t+YW6NA+mzfRZxb/lnx2raRU4DuI+sFatt+ZMNQX2iQXC
         ZG61mhRcgHUc1ngDYdi1+fmM0P8UUzjh3eVv1uFhIOokKUK0dabSqQAG++ynA3/kboVZ
         sHotX91fjkI3qji3fq4NK0q9WDHWQJf28fR5b+nXmfsy0RCLnH4NPNV0GkZLjtBnox7I
         fpJyaLeo7Z2DNs1IIDHv0CNwYps3jxKZTQvZIa4NDmx5oWvCsCnqLn6azF9edndYiHgq
         7yfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790754288; x=1791359088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3uPv6p67nR3Am4gjvZbFjvoBpqKH7vmcE+P+gVbuLG4=;
        b=lYEyYjKlikL39luVMplM3bvCfTzKqQZkJlgTKgrmrfUJk2wTMMggC0d+EYu2WrL4Ub
         NMFOATgJpsFeFMK177RsrUw7jxPXWe6E9FHYeDf/6zAGHy6CX52DI8oCRVE7Y891NYOk
         MQf4Uym67jWGT1f3XBnj0CKWffFpp7I395mj4cSxyisiGRWy3+JnwclRkffRfXO2Sffs
         f8PlVKBNTND8AwWa8+2cWjLinscWyqKOZCCQ2azHChkgH9T2WjGS49dlfhAQAHC1ogKe
         uOGr5nPeidzFKNTrbHMv61rJ5N3WhKsIJo3ObC6FJ3Lc7bP9HzbTJoIOvdbYybPq9z47
         tSnA==
X-Forwarded-Encrypted: i=1; AKwUvByPm1OEvXRIODPXrI9OTH6lA6qwMBkseoXkEhEwbAPtwsru3c7UpNBAPkjgRt1QRRe4L01K3uk/WpNApury3w==@vger.kernel.org
X-Gm-Message-State: AFuF++m/eATiizw7+JHR6waTzvIVKH4U/Hmj8WzlvsqfsX59VbgP+Rzq
	fXgbThgfoiGCuxy76N3OAPV8JiWCi6Vy9qHXSMjAMSeRJ2s9DcLKBe8I
X-Gm-Gg: AYBFou1u0hRAwd+TCEMrBknzMVh9f69U7l+w6NorBVyqnH1yIhNdwJplKymIRX08fKJ
	BqCXhcvjQq2xBsGU9nAt0Hq/5ofDxyDuCi7liXofplP8FVYv121ZdXG0iAGTD4iTGO/v3YsdfgD
	SyHN3xrXNiZTs7oiTNa+CxNVvFC08Uh3UErInXHVnoQvtzRbCYgbpLVmtI8csXofL8JALsbPcMV
	Nl++HTwJ5wV0M89hYZ4RnLOJhnw8ffUrbAr+lD+fglGToBmOZ3YC72wbmExZ1DKztMvm84Pt1Fd
	xf7a7hWujartvtS7DRS0WTbgG3yfb38XuCe8kRNbSqCh8M39v9luYOICB4iNqWbfxRrdopqW4XV
	V1NcWeqW5jFSy1DHlIBwBL3hpw6lhuo1OxxHr5yxDOeE9w+xoUmzn0gjVym5Y3RtdCxTNapKGWp
	s042dBkvJ1Kgi4BUSenvrQ4hpffJ4h/9Y/+069xhqZDhcm6NzQP+JKAi2OKKjeF3tSbIXY8TJI6
	1i2
X-Received: by 2002:a05:600c:4691:b0:49c:fa21:e749 with SMTP id 5b1f17b1804b1-4a01b126e5dmr6586575e9.31.1790754287936;
        Wed, 30 Sep 2026 00:44:47 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a017bad33fsm23934595e9.4.2026.09.30.00.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 00:44:47 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v2 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Wed, 30 Sep 2026 09:44:43 +0200
Message-ID: <20260930074444.1991223-2-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930074444.1991223-1-mehmet.fide@gmail.com>
References: <20260930074444.1991223-1-mehmet.fide@gmail.com>
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
warns about. Hand the beacon skb out of the page build and download
that. The hw scan, which downloads the beacon without a page build,
keeps fetching its own.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 34 +++++++++++++++----------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..49f09a9f4ed6 100644
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
+	struct sk_buff *beacon;
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

