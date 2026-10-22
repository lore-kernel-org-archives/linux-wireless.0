Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792697176;
	b=Qk7/L9Hogq7hh8RhiYE3zZm4x//1ydN4E5OMHw6aKd3nsCdA0l6SLKuayDwzCFOiBnYz
	 oHVwR8MtaUeeUs6+FghgxHXBtoUjOEQjXg/gI22VCHIZwF/0qxdeOIijYEMuax60u7Jjt
	 9wP9y1CgP3BlJdqup2x5Kquw4PyvFyS7ee9O+NiLVTp3dTPX0NZ90IoMs0r99aduV+jVP
	 svJBgzvDb7YLZQk2uixiKTTiOF3zvrQng7rbZGfgbHd0u+j5iP6gWBQ4432DFUHcBIO7I
	 l/14vYefIqfoxYyVL4PmQLLZ3orD8cTKlUOu2K9oV4qjKwtnPmLvo+j3ggZeXMU4zBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697176;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=gK7izGGtZVYQa86HMWiLhtBvLLYZxvuYYPXUeMfCAJs=;
	b=af+vDMdIVdYWfCCiFieevhUQYYRK4uOCwAnGNSzyO4ggdphK4OOZIah9T2/QPexVlKa8
	 0DBheYIYXKgmjOOfqRgjNHbXaeBy01VPcZgXVsXMBE7WJJ/9FNOF09w2fB9J3wegSTEOV
	 t+6RZmJuqPykyOA35LxflLXFBl9mgOgZA0ziU6VC4nziCB8zRw5ZN0P8fiFKueK6u9pbF
	 pEzG+1vWS9qDSZDCe6JU/mtwF9I/JruqAeon7z2eOgO7iwy9YjkbPIVxjVOPOWrb/M6VR
	 IKtJv9JAcqMuQTgyxzMyytpBOJLKqm7zHxE2vhOQ88/I1LYadghYQRehtat+F054AsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Qju46AX/";
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F130606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:26:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F130606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Qju46AX/
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-368581df789so99249eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 12:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792697175; x=1793301975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gK7izGGtZVYQa86HMWiLhtBvLLYZxvuYYPXUeMfCAJs=;
        b=Qju46AX/WWhzm85wKH0dV9cGY9cLEKbV/bpBBPt4d4j1X8gO8+sNByrdzXiuMN2cW+
         4PvQ49wMXxZeMy1TcFmwdh95p55HDma5/PBjcRGuwwA2+8gr0DAvekmbMfxK4vPH5+e4
         3IooWl2cRb0PC5JO04IgnkeSyxPEC+JAujgQUf/ooLSLMCwuiTLDGQg5zHb6VSNbQbOU
         NdLjQ8xRr3RBxKkCBCbHHoP+xsbDkPqTDYY+H9SMVEWlT/I3ajRIWAk4WaF+4aZZ5Lbb
         xk/wdfDChc95Zvrt/HBGQDaEVLUj+zdcwBrO8gKPIOr1OM6z+uqcKyO+W5Kf2SpeIct7
         C5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792697175; x=1793301975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gK7izGGtZVYQa86HMWiLhtBvLLYZxvuYYPXUeMfCAJs=;
        b=V+Mh3cXJn81FdfgTMs4yezemhx36V+ZCr/oecmwEccRAkEqsCCyElpIzigupopyIzz
         VM2Z3p/QZgQl2WKOwed2mpjLZm0VQlKZozgkF7oyxkZGwapCzxryQIjwKiPzz9BNJBad
         cpITzU2cEaIqdq//M7KCZw/mHiKELgapOCDfb8bzKdQQJleEZdsFH6rS+0dK6ImZ++A+
         Zsl2PrIzvt3GnzMKBalGqDuW3r7UshdD4K5EvGlj3+l0aRiHxKsxEvnWG2WdxounyEFr
         fRtaC8uhSb2DiPTjIWBw5w8DRjBG6ZWEpv8QyDixFD7fJcUdPizG32lgJ3pz7WnzlLqd
         zvdg==
X-Gm-Message-State: AFq9FYIj4L7hUpMOVDg9LTEdZ8aIfi2pIByV1FMXiNKDw3iNFrgGj+IR
	0Jj/XnekwAcNTbVV7+hKGBxSZkXrR7vi4SDuTceM8UKXGZKlRBibm4rtM9PKHU5Y
X-Gm-Gg: AYBFou0Slbw8RLr0HrGfwTZQz/M3K5/S5Zl22ytfwbv2Vim0OhNElyNJUXyBIO24Fmc
	wtESKVA0ewJKn4aMKywQsMZiSuIt7Md4OeHoFyPHhgaxFI79pl7ky79YM5okMk72HgkQ3GAAhCF
	qXPUGDinTE26kc0dAKHZ/6UWTR2Tp7n7GhLtZdIsAThY954SednVi7K6LoSw6fnjAzyHtJm6aN0
	DwoUUJR/pTDnYKFjUIdCUEowKPikpdrHwCkTXOfn02GL/V8GuNAVJM3UUGq+EuOaUr5KjJF6hWv
	pI1jn3GSjSPaXjpm65sFtG6cw4Kbcf4kxEtyFo3RqLmsONnpGaSQ7NrynKzhyo8ACUNtBBjSVJn
	JM5ppyhbIvVF01nC6SyGJMglMUfQT6QRP252kWwcsF8mXgPZP+MWbTbrxYoTB4/0cbUWH74sRhF
	15BEhASFZR62HdNxu60+7x/BlRJhhiJ5AV3e92/ET7ByfdaN+oSEfs7pO92fKI5jNbzA6X0KYw6
	Ht0xyTRgxqY874Ylu5rxSVB1TxG82WnDtGT1YK7QFVe4+rluRS2IqVveM49RvtzX/apIf5tsgNs
	683FjBCmikZ50uTgZ3dAmb9WM/ptqoP2DhyQhC0MscdvfwFNLgN3u/RpE7A22/1daWYJtP3tF8H
	2qT3VTeQ/B40ANkT0wFO7+j+mpDG7
X-Received: by 2002:a05:7300:559a:b0:360:aeee:9b8a with SMTP id 5a478bee46e88-368afd86aabmr3963048eec.8.1792697175344;
        Thu, 22 Oct 2026 12:26:15 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e36])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d8fb1a06sm328384eec.23.2026.10.22.12.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 12:26:14 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: HT-PHY: read 32-bit table entries low half first
Date: Thu, 22 Oct 2026 12:26:13 -0700
Message-ID: <20261022192613.3329978-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
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

From: Erik Conijn <egc112@msn.com>

The PHY latches a 32-bit table entry on the access to the low data
register, as b43's N-PHY table code and Broadcom's wlc_phy_read_table
assume. The HT-PHY code read the high half first and got the stale high
half of the previous access: TX gain table entry 0x1a/0xc0 0x10f90040
read back as 0x10190040, so b43_phy_ht_tx_power_fix() programmed a
corrupted radio gain word.

Fixes: 1a9313923718 ("b43: HT-PHY: prepare place for HT-PHY tables")
Signed-off-by: Erik Conijn <egc112@msn.com>
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/tables_phy_ht.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/tables_phy_ht.c b/drivers/net/wireless/broadcom/b43/tables_phy_ht.c
index 1acf2df66e5e..a6db39c644e3 100644
--- a/drivers/net/wireless/broadcom/b43/tables_phy_ht.c
+++ b/drivers/net/wireless/broadcom/b43/tables_phy_ht.c
@@ -622,9 +622,9 @@ u32 b43_httab_read(struct b43_wldev *dev, u32 offset)
 		break;
 	case B43_HTTAB_32BIT:
 		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
-		value = b43_phy_read(dev, B43_PHY_HT_TABLE_DATAHI);
-		value <<= 16;
-		value |= b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+		/* the low half latches the entry: read it first */
+		value = b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+		value |= b43_phy_read(dev, B43_PHY_HT_TABLE_DATAHI) << 16;
 		break;
 	default:
 		B43_WARN_ON(1);
@@ -658,9 +658,8 @@ void b43_httab_read_bulk(struct b43_wldev *dev, u32 offset,
 			data += 2;
 			break;
 		case B43_HTTAB_32BIT:
-			*((u32 *)data) = b43_phy_read(dev, B43_PHY_HT_TABLE_DATAHI);
-			*((u32 *)data) <<= 16;
-			*((u32 *)data) |= b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+			*((u32 *)data) = b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+			*((u32 *)data) |= b43_phy_read(dev, B43_PHY_HT_TABLE_DATAHI) << 16;
 			data += 4;
 			break;
 		default:
-- 
2.56.0

