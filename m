Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EB63C2BAF
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 06:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440504; cv=none; b=HYx+17SKPiAcDvEnVztyZLzrH2g8rqWZ1fSzbeVvFUgn75IACfwq3wirhQHYYJw4Mn/tFfYdG8lGq8cOO6emnssr4oebPHgI4g92uM1+E8mZr77rRYwj0yGv3iKyHhbSIutuxwmW9M55IadnE/hjRVB4XU2DdAeMKAJT79WUFYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440504; c=relaxed/simple;
	bh=bsLDRyl0aAGyDLXnNq1ocy9lVC2yGRvfVfbGSNSB7os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF4Z2z6aX2DSr5hTiBUAKAyq/xSYaLEMxUJsyvThA+ru0Qq5FHefDHkDCuNhH0Scp5bf6ggXhDMZGQBy4qNI5jSA4VOsGBTXb5wGkpwKL2e1u48B7r/w6llX22C/P/r8+D9ZIZAkaEN2zqBeBfcpBWJNns8Bn4CY6U8YQr0aaFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyGYNsKP; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyGYNsKP"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so23539835e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 23:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791440492; x=1792045292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zSjbzlFloq9QXjkiUjFLP1ZspHUOtztmi3mM6sYoevs=;
        b=eyGYNsKPyaIpOSLqsCQWPTEA4CgIWZ9N4B/Q0rgkctNHUDzsY08yYTKKhIbR7hccCP
         jM32QummxetyWVWcKncEQUHGZ5KvgY2W2RSgPHDY1b4di7WV/CdkZSmFC7JjKlvxvbKz
         m+aNlVj/ns3akxpbJtNS+3kmO3myDF8AqBUDe2cAsrAXTgAK+F8EvqbFdOMWFo6hW0Ge
         hEyalzyJn8kP5KyvN53GoCgYaxdAZPlBpDdLwX3FXeBkpQ0mzHFwavNjYjH3tDKW+NR7
         SOV+Uc4rp8sgjFqVE4WKkdQjydXexmuXytCup2u9ZOfzmcXIRRGHiCgIZcZnN+mUHEzy
         KeEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791440492; x=1792045292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zSjbzlFloq9QXjkiUjFLP1ZspHUOtztmi3mM6sYoevs=;
        b=DGuMm2Oa7b2H+pQIhG0ipwkqM69Pk+aIrU3lrbZMFGNquL3WdPIA42SSAYSFTAvCEw
         3sQugjeYJ5pJd7OtNs2AUmoK/Ico6CBSwIz5+pIVkaWomxZegqJpATDYtffLkMXXyWAo
         LCGugtl8pVLNaHADOwAkLlJ6Odq6qrqgLvZG/S+oxydypveghbEUc+VXxTJDJRLPPBzJ
         92HwFsHr1nCdqs7viHkWKJ07Mz9KadEzxUNPdpwRQI/4wpgbYxvXgpolywS4slchNOh3
         UR2pX5dcgD4Ep2Dzf5AQFOLEO7TsTIcAGaqSPIE2n/jxf0CFh1QXGRpBvINqecpOrvJv
         0qjg==
X-Forwarded-Encrypted: i=1; AKwUvBzPnGqdJVly7WKvaSBo5AabqvBdXWQmFOfUE+gypBGHf33mB6D0i56Krv8Pn5V2p35SebPEXNIXhpUCiyzK4A==@vger.kernel.org
X-Gm-Message-State: AFuF++loMQbmfQG/f+dg+01r9JvA9OnA5TOZApy+NoVb2OWEOlN/rQYv
	3ugFRd4U32UtELdXOQGCbvP7FSuf7fH+MyKEQStV9stbiYVvjACeG8wW
X-Gm-Gg: AYBFou0dZEeiQgAFwPasekTyOjtUSxhgKmC4sMyYU1+pUdp6ILeTtbacsCn+vcCK7Zn
	nB3hIc2jlt5eRVXhFuk3RjnS0hPrLslffsb94Xrc16kaGwsMHsnRRMsi8tZdRxlwvH+AaFeeUeG
	b0iP/kQuI80wXJ8MYRs51IOA3ZYXvBQIw7p3i8ErHgOkWPhQ8PDAvJHEylY7HEXHKsmPiVucFby
	SCQXPczn6y014RLLr/oCiLfzOOVmjtwcAeXL4BlgtbhuLzo4TarPZa280sSn4bTdJi5xwSpq5eN
	DI23oknuIhx68vKJI6+MmPW0wEorCAUsX0vmPaTuissQaVUW5TV1Rd299IBfnqNYTUBvigiiR+h
	OPV5KpJQ9PiWM0MKHbeYW+D4zHmA6rtTFe2DgNc5FpGyGspT8HeNMxwBtWMjspoOiIE66GGGbi4
	nDnlkG6EL7BmCCXXANQgUBN75WPnVyr1IS7joaehc+nQD6Y0afFOedU9d1vWvhvJ75Ur2xvfkHx
	q7b
X-Received: by 2002:a05:600c:821a:b0:4a0:3a3:33e2 with SMTP id 5b1f17b1804b1-4a1803038cfmr76364385e9.5.1791440492138;
        Wed, 07 Oct 2026 23:21:32 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843e3356sm40309455e9.14.2026.10.07.23.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 23:21:31 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v5 1/3] wifi: rtw88: download the beacon the reserved page was built with
Date: Thu,  8 Oct 2026 08:21:27 +0200
Message-ID: <83291fa9c7b78458599a9bfbd8371658b0d3c5e5.1791362281.git.mehmet.fide@screeningeagle.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791362281.git.mehmet.fide@screeningeagle.com>
References: <cover.1791362281.git.mehmet.fide@screeningeagle.com>
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
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
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

