Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A8F286425
	for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2026 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777133376; cv=none; b=pCs0eauZaZzFeE5bEOWMkQXSQXHr+C/1lhYb0qaSD/eSOHCf5bfS7BHbKC3ZLI8aMSGA2wTyzHj6lTaNP35yzIUxA4kINhFBNEUmJUK5q5M+1LmJazb5bwvvs7WiwvwjCvcdcUfYT95brAYfZX2DOnEUCn4uEV/xXGOEfMTA8p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777133376; c=relaxed/simple;
	bh=OCly5pv0Q7mkAEpPqyS59abJRLY8pftVOuLYspS+NTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q/dAWoc8DutF4SvYg8DgH5lwLbBMEXqUobDoYeKmUYffaGcqTmeV8pnRcXls0oe4nuScwpbbbWM/v3jRugNF7c7C6hZSxt1CMXgWen2SH23PbfFY6ahcEzOhS5IwsCPvVXaugE/R0c1MkFXmwdee86m+jL5ooQfQCSJICxj6Y90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-479d68a90a7so3666281b6e.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2026 09:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777133374; x=1777738174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/5EfUHW/KaKsY8UZlwc43ngiZ2mWe3FR2S4/3mx4C2w=;
        b=RZMM18HBSmTpYlW2QinIq4bXKVmthKBK7BB8bxuDwSbtr1QlWzxbgf2dmrEkOmdQ2r
         cKnSsFWjy+dR0grkRpLBrjBRwlg4NGY/w1riCxqH7nAEOPhOAKzuBhjBn1ryFlEFW8Xs
         bUFztILO7Ip/3kl5AUg2i1sNT1wfZPJOBpgHozdafEmzllrMJHkEI+sCFDzXC1DFkpD1
         JaCmU33S5R6M0V2hH4kiVzfsBm0VDYkR3SwN5MN7ign1HPpf1MhiDC5ZEJOwtgJEUaHU
         EsZb2uE74uyGP+gzrp5RhYkn0uEI0vrgDhdUD+R+BpSCB1fkAvp+CBOeeRZ4j8c5qrMo
         7IOA==
X-Gm-Message-State: AOJu0YwZi4rrKsHxejvq9aYzjB3YG/jPvapXNr0FtebrqIEkbpzsgbIp
	BbVdPbJsntgcCMRX0YHbaW7xUBpQbj7A0nQ4JqB0uSLMoPdrqH+05w+ko5p3eQ==
X-Gm-Gg: AeBDievUmXU4hxWcVNgxKFlWUmrNtkZiowmVH1RxpDNEcFxWtbqObr7eAHZKKZ2WEEE
	Af/IDMUvngGKBbFT18ApQXsYoC0sNHQkAZI66YuXMmEMlPMkA+nlPUTiNo4HVWncnVazm/O9UaD
	y1rt3Ay69enuAlWqnPczsgocC7csAJ9757WqgRMipd1njKP51gZ60a6+QIkBPVycI36H40wd5ir
	aMFjDcLANbg2+FhtWgS6EtwVrHtqIa8tupg2imoAtRhVQWuac/Q8Hs8HODDcc4kmayfksBCLpkD
	RpAAYKoGAfqXzGg6SVJpJPO1mUBcfSNdUR0aUvyNwl3vR87OdhnvNqWCtaPelEPyu0dTaX/OlzO
	NH3YnrizomFBu+oOs6O587GV07Urss09HxWnIvgMG1Ds34ryj0uvcL2+OoT3fAgDwb3aAKeM7pi
	mimTMF3Syk0jmGwd8KttnibQ6e2PRa0lSxqbrmJvwOzLJjpXMMGhrWplpWF844A7lP7kFt1AcR1
	Q==
X-Received: by 2002:a05:6808:1919:b0:479:f9df:ab44 with SMTP id 5614622812f47-479f9dfb0a6mr11399113b6e.35.1777133374439;
        Sat, 25 Apr 2026 09:09:34 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:9f96:11d3:5f6c:5582])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-479ff935c40sm8099624b6e.17.2026.04.25.09.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 09:09:33 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7921u: add MT7902 USB support
Date: Sat, 25 Apr 2026 11:09:30 -0500
Message-ID: <20260425160930.739237-1-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

Add the 0e8d:7902 USB ID and select the MT7902 WM firmware.  Use the
same USB queue mapping as mt7921/mt7925 so MT7902U can bind and probe
through mt7921u driver.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 2 ++
 drivers/net/wireless/mediatek/mt76/usb.c        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 17057e68bf21..d86969a096ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -13,6 +13,8 @@
 #include "../mt76_connac2_mac.h"
 
 static const struct usb_device_id mt7921u_device_table[] = {
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7902, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7902_FIRMWARE_WM },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7961, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	/* Comfast CF-952AX */
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 632ae755c7a6..d16439416891 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -925,6 +925,7 @@ mt76u_ac_to_hwq(struct mt76_dev *dev, struct mt76_queue *q, u8 qid)
 		q->ep = q->hw_idx + 1;
 		break;
 	}
+	case 0x7902:
 	case 0x7961:
 	case 0x7925:
 		q->hw_idx = mt76_ac_to_hwq(ac);

base-commit: e8c819df02436f2c2379766946735e1f06a7c923
-- 
2.43.0

