Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11399378D9C
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787838511; cv=none; b=Wba7Q5WkAQkwW4Gs9oytz+sV45zvOGXcCj7s45HDC1RN/Qs2wdmhqyzfespK2/3ZviT1VUwUoLCb0hoUmeK5rSDZ5F2E3lFrP4xsiy7gPLZxMcuZGUt3M++f/zJf7gMD7YNzemkgRvD4oAf6UTRiHCB28RJLwJGJwb/NvQ5t/nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787838511; c=relaxed/simple;
	bh=B21WIJfF3OL4nulXscrdt7J/PoHva+xwa0r/5bkgZf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PtIn+7SLgqGacqoXNNwIiQ2h1RylkGNsGw0VDMHp28wxEYKZKLLImOGC2kEwm+813jAi8z4kIoxIKx4/C0EKwDSd+QIisWKtNUB/AawPy45FNBklq5ldj+jaL69rQcL2Nt5Bd4X6qI5YUsQacfxdRIJmlu5iZY1a6mvxqdmlleU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kCqK5JZu; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kCqK5JZu"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cedda2ce6fso4749785ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 06:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787838509; x=1788443309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hWIouarLBH7JuHWJjN8tUII0KICbScsgCYFIy7YWfw0=;
        b=kCqK5JZum+Bo9MOmGMAYxYUYIGzrgW5hrXgNYPNCseBfszBJ2Y6BUp9yehBuTQtQiU
         wLKnoapYl+TgN6uD+cPbDJBN0De3L2W0qnksiwzhctD4eOkASbq4OVtdiZr9/1XDDBe+
         7d7VQqnOUFU5YUK8Se48oG5tIIQ0bTz8jKhoEZcmmAcpyfGio1howNE8WSGVJ2x8guaH
         6pVjhT1ZJUXoseNAvqs3woFStzF5qFfm1Si4f0hKSilHqOW7ERGHUosHEi+P+2kC67Oo
         4RtAuVRD4M0jJ7pbwE958gYJ4/ViVsPtrmqDrKWhm0+Fm5hrnYtcOZdr1/lPUP9z9Laz
         +uKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787838509; x=1788443309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hWIouarLBH7JuHWJjN8tUII0KICbScsgCYFIy7YWfw0=;
        b=q0lddf3aE/7CinhIFZKcVasOeb8FbcfthMYnYHapFCfG4BN/c4VnR5Lqli7pL7OJsL
         D3atmpiM9nmpOig4bqBsw6CAMPfhKFYetKc+tytai6SLixKZdzDm94j0kK8S4+wOfaiH
         D5+vMGe48Q+AOQCAEitshD/hmK4n5XnIOuiNd5xGWjzyNp3kMmZuI14lnxJsA6r5QvEf
         5PMuXkOvGfy0+v3xipBfMIHvu+DTDA1DOazGLdqxnfzAgu/RHn/gMxXcd2Y0OqGoBcx4
         3sMGZNKoLcpFjcgmTdv2/DUz0vz3cw95WVBZ3UtFqIxoH2qD3vLs5T/PvwQFGM4q35Ag
         dkUA==
X-Gm-Message-State: AFuF++mlWZsNUmVY5S49a/z/Jbg6JqS4yy+gCW0kS5RcCBYsK/XisDws
	/jO4wXzjI6+DvLR+Gx9OZKhv1cJiyXKypQKNe+11EGwG3G81mw0sEYZWzkmxRcVZ
X-Gm-Gg: AR+sD10G5ufUyNw9RSN/jGHHXvTugoa7GmIsl/U2NZaTwqXQvp+FZR1wrd7nY+CbAVr
	HDXMt95BFjUfSV3dShg8KwWV46wmdDcChFHtek6AImGqx+6rMeCtAjl6CjgCVnpEtQnwTGj/P6G
	gu1zpQr0fACWQBMksZe1e5kSfmIBqMwCzL1KWyY3EO4zrMgALsxV2ejZZs7kmGOeZKZnf5EIFoa
	JTVnyt3eQNJG/BQvZNbmbLU3pRIAsdeDWrdYvBAqlYG8uK+jvbmsdd+L49VK+g6O9iZCq2cemS4
	zvjrg+3dXLC+n/KFM1wkDQc+eB+Csw2uYTyzOS4kRvJkuMTS4eHJEGxZluVBJJYRcv2YhhzEB22
	llI5AAI5CeU+tcLa/nzJovD6j63k5SIsW+fpa4z6p05bQGPB+RrRivT0aGcemfY/n0VV4YpZ/dp
	938ijikK3LtcMhvL7j4isrPcpAcCIEWPxOwlJe7EyjM1EjrkO1GTSnM0QmJjphUP1NYKFey9nTP
	1Ca5bLBhcGhEW4OOtzUcj/HhaNisN0oOV786wmPZVkhNbbl0iDbdv+vX4Zar7AnR8DsL7plnUt7
	xEU+MO0idyM8D3h2Vz1BWS/slvVrbcS0fXFA+m+16v+YhQHdmk+gouGLX/iTUYOr32BUhokZerg
	BtVbtrGmFjx0FDXxd
X-Received: by 2002:a17:902:e550:b0:2ca:1479:d9dc with SMTP id d9443c01a7336-2d707b64aecmr290601105ad.12.1787838508938;
        Thu, 27 Aug 2026 06:48:28 -0700 (PDT)
Received: from silver.tail241a39.ts.net ([2402:800:63a6:a199:ad96:d99:29d:5e21])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283da25c09sm33302987eec.31.2026.08.27.06.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:48:28 -0700 (PDT)
From: Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org,
	nbd@nbd.name,
	lorenzo@kernel.org,
	Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>
Subject: [PATCH RFC] wifi: mt76: mt792x: treat ACPI MTGS 0xff as no geo limit
Date: Thu, 27 Aug 2026 20:48:20 +0700
Message-ID: <20260827134820.2607530-1-huynguyendinhquang@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some OEM ACPI MTGS tables fill unused geo power/offset slots with
0xff. Windows treats that as "no cap". Linux assigned the u8 value
to s8 and min()'d it, clamping every rate to about -1 dBm
(txpower_sku tmac = 3).

Skip geo capping when pwr is 0xff, and do not apply offset when it
is 0xff.

Tested on ASUS Vivobook S 14 M5406WA (MT7922, mt7921e):
- 5 GHz: tmac 3 -> 25, TX ~40 Mbps -> 200-350 Mbps (80 MHz)
- 2.4 GHz: tmac 30 after the change (channel 6, 20 MHz)

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Signed-off-by: Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd79..fa539cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -280,7 +280,15 @@ mt792x_asar_get_geo_pwr(struct mt792x_phy *phy,
 		return dyn_power;
 
 	geo_power = (band_pwr + idx)->pwr;
-	dyn_power += (band_pwr + idx)->offset;
+	/*
+	 * ASUS (and some other OEM) ACPI MTGS tables fill unused geo
+	 * slots with 0xFF. Windows treats that as "no cap". Linux took
+	 * it as s8 -1 dBm and min()'d every rate down to ~3 dBm tmac.
+	 */
+	if ((u8)geo_power == 0xff)
+		return dyn_power;
+	if ((band_pwr + idx)->offset != 0xff)
+		dyn_power += (band_pwr + idx)->offset;
 
 	return min(geo_power, dyn_power);
 }
-- 
2.55.0

