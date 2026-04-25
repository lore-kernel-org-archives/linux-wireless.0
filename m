Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9E830595B
	for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2026 19:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777146731; cv=none; b=r3JxZwcDoPvlIL6CZwD842UCW0FeE10xW+C/DO2rQhCkc9KsGrCFZ0qTxtCB0ka1Qt51SWQX8OyMYMc8PZud14lSqyy25ENowY8hS0SfB4mYI6g3BElvsyCfZ/0kkVid9sL36EpxD0sbcsZHSgPBlgp315ch4JFSouGObX0Sk38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777146731; c=relaxed/simple;
	bh=/xqsv0h7fdXY8vVSTpGTpCuzXfMR1s36jvA0JpdcoBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdrDcI0sdQZOVQ2KfGvKRluKoBzM3gfU3JPuwXnl+4lGM20XIUtz3iMJBILoZxsyLZSEvVXltDAjndGN6cegfQK/vIw7nsy0fzLiRlaACxgwx3fD8fi0Z0KEelHm3xPA8FI09J7FvdrjjZWwbV4l01Aqf1TFJNOJxh7cLpZ5tuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dbcb467f2bso8198774a34.3
        for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2026 12:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777146729; x=1777751529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NMAgSidrHOjcG4s8cbGWbijYESRhf2FNOdS6mzEMeJs=;
        b=gBxoR8pnwZqRHW3FJWRAdjz1zVkzOYWR5L1NR28Egp4+RrZ4RPoY0JrlET4aCqPEpO
         j8zJ8X2K9a8uWS7MYFt4TFNlMBd49omrg7aIv4qPeiPIrWsqivuoEJzTCcBIAm7JC1eJ
         iUJMUEaohbM4IMx1h9hULJXbnT9u+h1LvE3nAFT45rNRb+WkFB2u8FSKBYwuCT13qj0v
         qjFNyjR3oy3TxsuFX+ULBAs9LtZwmTP3frSkZgoDgu8mF6nlCLHkZAQ0/MFMFYCaefGy
         enO2EsYGxZUYl5CpHUWjxceweut4PrVi77mJmUIWnb02RketikrOZeFefcTSemU8Ttmv
         2PVw==
X-Gm-Message-State: AOJu0YzQlkaTw630nQahZmJB9V0MPVLLz/rov2oOeLZXYrQCYJ7oGD86
	h4mYFYVvvt5iBiB09CJOwgBy8j7+F8hzLcv11JiK0MV4UEAR1nA/++tY
X-Gm-Gg: AeBDiesiVIPsxF4isz1Oqr05q/4DrX/57EbwntXnPk2lzaIobtxHh9fVxYO17JK3gx3
	fATOHqqznPgdX0+VitnBUeSnrx6arj4fKFjQB8gy4IYgbnnfPtf4f0crOy2//c6cL2tN0orsOQL
	ioDMkiayh0Qenfj7eRPdr+od4SVw1zvN+LAw6YNxkod3VwpFfi8DPn+OmHSlK7e90YMq0R3V0t3
	cnGbW8mgyC24RolaEWkoEy2ejWpGzVguBngwFrL2dAMCN6hvFXHXHutYnt1F1W8zE5QI68q6G4U
	iUQQP7Go3N2/ynZbsVO5WzYQzCJF1hNh+4po+jaC2bpn8MvVS26Uod144y/LhZ5hqhtBthvTkXV
	gySTr2jpVwgf6t/nx2mGWGRjwimqjI1GEbexmLieDrcs3KQ8RRZqso9yoNP5Ik49BBqHnZoq+ll
	LBMzdJOO8f+QGpe7RE4H+UCCVwurFXTNjJlR0ljhc1vgNXd5Z9hyEoh2D/xcxuKdMRo33imIzke
	g==
X-Received: by 2002:a05:6830:411a:b0:7d7:570b:6800 with SMTP id 46e09a7af769-7dc951fc052mr23532285a34.23.1777146728925;
        Sat, 25 Apr 2026 12:52:08 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:2e29:c3c3:de27:ce76])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcd164d2c3sm13987624a34.24.2026.04.25.12.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 12:52:07 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v5 21/21] wifi: mt76: mt7925: add MT7927 USB support
Date: Sat, 25 Apr 2026 14:50:11 -0500
Message-ID: <20260425195011.790265-22-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260425195011.790265-1-sean.wang@kernel.org>
References: <20260425195011.790265-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

Add the MT7927 USB device ID and normalize the raw 0x6639 CHIPID to
MT7927 so the shared mt7925u code can use the proper chip-specific paths.

Restore the required band setup after USB MAC reset before restarting
the device.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 15 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/usb.c        |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index d9968f03856d..7c64f3c1a2d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -10,6 +10,8 @@
 #include "mac.h"
 
 static const struct usb_device_id mt7925u_device_table[] = {
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x6639, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7925, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
 	/* Netgear, Inc. A9000 */
@@ -120,6 +122,12 @@ static int mt7925u_mac_reset(struct mt792x_dev *dev)
 	if (err)
 		goto out;
 
+	if (is_mt7927(&dev->mt76)) {
+		err = mt7925_mcu_set_dbdc(&dev->mphy, true);
+		if (err)
+			goto out;
+	}
+
 	err = __mt7925_start(&dev->phy);
 out:
 	clear_bit(MT76_RESET, &dev->mphy.state);
@@ -198,6 +206,13 @@ static int mt7925u_probe(struct usb_interface *usb_intf,
 		    (mt76_rr(dev, MT_HW_REV) & 0xff);
 	dev_dbg(mdev->dev, "ASIC revision: %04x\n", mdev->rev);
 
+	if (mt76_chip(mdev) == 0x6639) {
+		dev_dbg(mdev->dev,
+			"MT7927 raw CHIPID=0x%04x, forcing chip=0x7927\n",
+			mt76_chip(mdev));
+		mdev->rev = (0x7927 << 16) | (mdev->rev & 0xff);
+	}
+
 	if (mt76_get_field(dev, MT_CONN_ON_MISC, MT_TOP_MISC2_FW_N9_RDY)) {
 		ret = mt792xu_wfsys_reset(dev);
 		if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 632ae755c7a6..9bd61c9e94ed 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -925,6 +925,7 @@ mt76u_ac_to_hwq(struct mt76_dev *dev, struct mt76_queue *q, u8 qid)
 		q->ep = q->hw_idx + 1;
 		break;
 	}
+	case 0x6639:
 	case 0x7961:
 	case 0x7925:
 		q->hw_idx = mt76_ac_to_hwq(ac);
-- 
2.43.0

