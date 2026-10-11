Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4908E3A1D0C
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 20:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791751516; cv=none; b=LlPmsbPQI/gL0pCqkPFOo9mU9KzBTrAUb5T9KxBmsU9ZUkSnSLj8XLsOeAJOGZsD1PTqw4VR7Viu/N6r9v6vdVFys2HOo9099Q4cJGO9PH7xC0eZ61chE92gxA8b646duiBhdtE5zeMIS6Q56g3a52H/DEVqGzSTmW6QPJBFkdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791751516; c=relaxed/simple;
	bh=tWqAn/OUpkb2HG3yB67Tqx2X4I8nzTHsSrSc53lI5NU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tHoTd0lGriVR4TOE5mr/opuHXDVIjTDwNnN7HdDVCzXg+rmm/qbSWv2aaK2ldtFuY9wFidmnUGtUaiTuBaJfuxQk/3EZGMKYDj/h4oTaIp2M4g7QW0ErLR8RmIjAuFRVRUtXLrVGlATAZHb1bh/r9zSrfqZ9CxwNbCJ8r1f4xFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EV6hgzbt; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EV6hgzbt"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48870973bddso721015f8f.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 13:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791751512; x=1792356312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vKik4orISgwbKLaMdm/aK2JrSIR2rz6tc/MAnoXx/B8=;
        b=EV6hgzbtHudD4HFWSjEX3V8qFTZD4Oip37uLl3iaGQQUiXA0dWAzRrRiC2s8SpTKui
         0dh7qdS/DodrjmVkK9l40sN8Gj59Zj9W8AFTTpYNxessqZXyQd3Au1+wiVw9FxMiceAQ
         3+9Z4J/4Zbpd2EfwVHZ/Mx/jrsUtqLHNY3ZMGybkvCCb0hQs1YGigUnl3aYxVyx6LdCQ
         +chYXdZJ1t0IkgE91ag5NS6scuFMkiRtBLjrnsYUpZiDOXKDw0JSkpgeDN8Y8tKxSmfv
         Hk2L1lcJU4DXMrbTrysEuT1LszghTAtnnvs7cD41zK9IhQhBqrAn9vzQUjeN/jaSYb2l
         jniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791751512; x=1792356312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vKik4orISgwbKLaMdm/aK2JrSIR2rz6tc/MAnoXx/B8=;
        b=CAzYE2vSTk6NQ1gjQfFZtIHfrmNjL8MrdTJtpgKE3wc0N4H7m3afm1cjDl7kjlbR1K
         WmAqEyt8rN+PRUM+8vU8szerGWKg8PVF76MyIysFLtbvnlPHe7And75x99vw3/oBNDw7
         kpzFFra5/s3aPDG+AGe++d7ZD2OXedG9AzP3thKm1zOuKhduEs2Hj15VNsynYKR5h8hj
         fqGBaB4EocE38rvTyiOenwI4Gz2f41+680fz8qpuOizMKJYSvwgaOjSAPwD2lrmTokcO
         GDFQDFGvjwcgG01/fmZgCHN9MYC1ouSvJv5fz6Rcq7i8yKMYvSQOOuWSp+bfAF/1zn+2
         H2+A==
X-Gm-Message-State: AFq9FYJfjCvQw3rmN3b7dEgaJp4utj80pv0uU1uCzsgcXA66g3420942
	sLflNLKf6ox0AtV0S8l9ijRFN0lLd0mxcgw2VZoifXQHgf/XJvSciOP9IvPrKaLV
X-Gm-Gg: AYBFou2xB9Qt17KV27e5TGkvgmNxInJ5pElR98WHhCFMcNPxEx71OUIFlS5otARc+KN
	Hm2YH6yx96hXoH7SsoHIkTEl4Ps13uWYisU7wB9U07wTxC5rTUf/s+BxLEPR7EvUoiZpSxCBz+C
	jFNTXLh7ZH6MQrNiUjdh94bo4JI9MBHvAjeUmAdwdPCDg64xEgMwidm/MDvEVg3vbyfG+SORc2B
	sYjMaWcJBvp0/x/ssbkoyxfEaw80/IwK5YfI6fR0J/mC3ZStwuACCSbcZgu8Up0RTOr3rmnaGJ7
	xxCByp+k0Bv4eiP3EXcSe3kxtS2EnaqpH3dYBDsN/6Z9alX6Jrnk4wnz8xiTZYu41LKiOeBJbRA
	Z3IRT4b00Ve7/eFhgqUptFrly0gd0vgebIrDqypy4q8IU5CDvMBbLOghsnji5cRziE2EfeUNcxa
	d2zdtDcr8Iri1vJjoXWCtQiN8F9RugsBH5WSF0No04T/cp3TfkGcpWgb4QpzbFHzueoQwcsWp+l
	0JNpDPd1oip4DizHu1ygnf339tL7xIWtHjTyOtkUFEW+w8ldp6iciUsmoOZQNDKHdxQjv0cEcIe
	ahSdw1AZkaOAyEP+VO2foav3LB+pWN+1PaW/Lz7lbSPNOMhax08cCbteIefXgnRb9tTW2/uJX49
	G2tFLp8zsVx0GWEmyJcydmg==
X-Received: by 2002:adf:e005:0:20b0:48b:437:8fbb with SMTP id ffacd0b85a97d-48db948204amr10389955f8f.19.1791751512041;
        Sun, 11 Oct 2026 13:45:12 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a00-1028-c000-0ddf-8d69-e528-bbfd-9e4d.ipv6.o2.cz. [2a00:1028:c000:ddf:8d69:e528:bbfd:9e4d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9aac6a4sm15893409f8f.28.2026.10.11.13.45.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 11 Oct 2026 13:45:10 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH rtw-next] wifi: rtw88: 8822b: Relax ETSI EDCCA threshold on 2.4 GHz
Date: Sun, 11 Oct 2026 22:45:09 +0200
Message-ID: <20261011204509.46062-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RTL8822B has no firmware-managed adaptivity, so rtw88 sets
the EDCCA thresholds in the driver. Under ETSI, the current rule
uses L2H = min(IGI, 36), at most about -74 dBm.

On a TP-Link Archer T4U v3 (RTL8812BU) operating as a 2.4 GHz AP,
in-band energy, mostly from the adapter's own USB 3 link, kept IGI
at 0x2a and L2H at 36. The AP was not seen in any of 5 scans, and
the driver reported "failed to get tx report from firmware".

With min(max(IGI + 8, 48), 50), the AP was seen in 4/5 scans on the
same port and boot (16/19 across repeated runs), with no TX report
failures and no change in the false alarm rate.

EN 300 328 V2.2.2 tests detection at -70 dBm/MHz for a 20 dBm EIRP
transmitter, about -57 dBm over 20 MHz.

Use the normal threshold, max(IGI + 8, 48), on 2.4 GHz under ETSI,
capped at 50 (nominally -60 dBm). Keep the existing rule on 5 GHz
and in JP.

Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
---
How other drivers handle ETSI energy detect: rtw89 has no regional
EDCCA mode (it does not block without a station and never goes below
-62 dBm once linked); mt76x02 and mt7603 keep their ETSI ED/CCA
blocking off by default since 2019 ("stability issues"); ath9k caps
its CCA noise floor at -60 dBm for non-FCC boards; Realtek's 88x2bu
vendor driver ships adaptivity disabled and its 802.11ax driver uses
-60 dBm for CE.

 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 6 ++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index a56c8befa..cd39888ae 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -1565,6 +1565,12 @@ static void rtw8822b_adaptivity(struct rtw_dev *rtwdev)
 	if (dm_info->edcca_mode == RTW_EDCCA_NORMAL) {
 		l2h = max_t(s8, igi + EDCCA_IGI_L2H_DIFF, EDCCA_TH_L2H_LB);
 		h2l = l2h - EDCCA_L2H_H2L_DIFF_NORMAL;
+	} else if (rtwdev->regd.dfs_region == NL80211_DFS_ETSI &&
+		   rtwdev->hal.current_band_type == RTW_BAND_2G) {
+		/* follow the normal threshold, capped for EN 300 328 */
+		l2h = max_t(s8, igi + EDCCA_IGI_L2H_DIFF, EDCCA_TH_L2H_LB);
+		l2h = min_t(s8, l2h, RTW8822B_EDCCA_ETSI_2G);
+		h2l = l2h - EDCCA_L2H_H2L_DIFF;
 	} else {
 		l2h = min_t(s8, igi, dm_info->l2h_th_ini);
 		h2l = l2h - EDCCA_L2H_H2L_DIFF;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 9fca9ba67..1083953e0 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -151,6 +151,8 @@ _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
 
 #define RTW8822B_EDCCA_MAX	0x7f
 #define RTW8822B_EDCCA_SRC_DEF	1
+/* nominally -60 dBm: 3 dB below the EN 300 328 level at 20 dBm e.i.r.p. */
+#define RTW8822B_EDCCA_ETSI_2G	50
 #define REG_HTSTFWT	0x800
 #define REG_RXCCAMSK	0x814
 #define REG_L1WT	0x83c
-- 
2.54.0 (Apple Git-157)

