Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609558;
	b=swMdoq1Zh/FbliHbqK5VI1V010RzBVEOn8LETZQwVyAVxM11z/ltJZIvAMJzpUnbaXAv
	 WCnRPXrDgznL+7tifgcu3QdRYA93mjyB3UW9f3SRIg3ReWul0woFcJKt+9yiZi4ALLWMg
	 geORGUnqC9A4sXLLMl8kqmrz2EBfJ1sg+aplfLiej4PXduEPx5ueRMrrBZDxH+YgJuTbZ
	 9uBizfy4VdD0MWnAe3xm/oFBgHdj1d5DW2TPZYMjEeUBnh9eYOusEwRS3cTG9uWXVcTwP
	 djkB19NrvGr4IDVUrT/w45kqqVZlaY1IfME53ZjWfd+d2+SxY1lgQekUGQ7stUpqq1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609558;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ePWd681afzvLCcTQLEINIKvezHGVpjqyaOueP0JVcPE=;
	b=G5iF87Y+w8Yj5k7FbP2UCm/nzyIWFgp7P/mDi4Pq4paPil3GetDiOg8arp0vEUYUDrLK
	 nkrOjCoyt4AkgaPcSHV75z2d9htNMrhgYPBKhZTJB9HQMj+G5J+IKRmA17xovtWefQyX6
	 harkm4Gk96p4F6jRmNN4zmqF1wACPKaKBi4fwKrG2mCh9EBHLyQnjeF9HV7SNLFrilZbB
	 ZXUT0KEuhTyUUsnCPpaAIWcLs0IjkyxbjBc3Yzo6LSBXgYf7bXuGRG8dXfxz35HCFnQNV
	 FteSlgT4SIyFMIZQ0QYyw2NIEEiuaE/MzVs7/fSFBFazB0NUre+nTINyqdzhRvy4SOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=mXLw2yY5;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC128606A333
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC128606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=mXLw2yY5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792609556;
	bh=mIXhkEOIQHsUypoCiE7v+d4BgCGr8Y2/140c0YFz4E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXLw2yY5NnXIK/6hqiRrUTTDcYeE+enmodGD0EfUox6s3Jjp8IUu7SlJ7HrjmEqkZ
	 QMCpG6tKVsF78CDdVhTdJeW9nDApm+xcf5hT8a5/i3pDGD2ZGK+I2f9+ZtWt3HZ46V
	 WXlgf+3JFg+h/mWCoormzkwZTq2uzEm0C1NIjm8psuZ0jefOAAf0IjXC6XXBoOnVve
	 hLEZlwo4rhxtaY25xmgSx/aSGYqd6LAKxw9lrkRIkaALYsDhZvF3v1jjpspoXFSRvd
	 MLc5nvQhIg8tXnfCamM/1A2cT12Wz1MemKTCHX5/WqJkHI3z9DKX2wH2Z5vKZrIkot
	 3BQGgfj5JnuVQ==
Received: from hermes-devbox.localdomain (unknown [100.64.1.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbeckett)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EDEA317E08D8;
	Wed, 21 Oct 2026 21:05:55 +0200 (CEST)
From: Bob Beckett <bob.beckett@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>,
	matthew.leach@collabora.com,
	kernel@collabora.com
Subject: [RFC PATCH rtw-next 5/5] wifi: rtw88: pci: clear CLKREQ/ASPM enables when disable_aspm is set
Date: Wed, 21 Oct 2026 20:05:24 +0100
Message-ID: <20261021190529.3893821-6-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021190529.3893821-1-bob.beckett@collabora.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
 <20261021190529.3893821-1-bob.beckett@collabora.com>
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

From: Robert Beckett <bob.beckett@collabora.com>

disable_aspm only makes rtw_pci_clkreq_set() and rtw_pci_aspm_set()
return early, so the driver stops setting BIT_CLKREQ_SW_EN and
BIT_L1_SW_EN in RTK_PCIE_LINK_CFG but never clears them. These bits are
device state and survive rmmod/modprobe, as nothing resets the function
in between. Reloading rtw88_pci with disable_aspm=1 after a load without
it therefore leaves CLKREQ, and possibly L1, enabled in the device, and
the parameter only takes effect after a platform power cycle.

Clear both bits in rtw_pci_link_cfg() when disable_aspm is set, so the
parameter does what it says from the moment the driver probes.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index d65408084f72..a047409bc0b0 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1501,6 +1501,21 @@ static void rtw_pci_aspm_set(struct rtw_dev *rtwdev, bool enable)
 	rtw_dbi_write8(rtwdev, RTK_PCIE_LINK_CFG, value);
 }
 
+static void rtw_pci_link_hw_disable(struct rtw_dev *rtwdev)
+{
+	u8 value;
+	int ret;
+
+	ret = rtw_dbi_read8(rtwdev, RTK_PCIE_LINK_CFG, &value);
+	if (ret) {
+		rtw_err(rtwdev, "failed to read link config, ret=%d", ret);
+		return;
+	}
+
+	value &= ~(BIT_CLKREQ_SW_EN | BIT_L1_SW_EN);
+	rtw_dbi_write8(rtwdev, RTK_PCIE_LINK_CFG, value);
+}
+
 static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
@@ -1537,6 +1552,13 @@ static void rtw_pci_link_cfg(struct rtw_dev *rtwdev)
 	if (chip->id == RTW_CHIP_TYPE_8822C)
 		rtw_dbi_write8(rtwdev, RTK_PCIE_CLKDLY_CTRL, 0);
 
+	/* The CLKREQ/ASPM enable bits live in the device and are not reset
+	 * by a driver reload, so a previous load may have left them set.
+	 * Clear them explicitly when ASPM is disabled.
+	 */
+	if (rtw_pci_disable_aspm)
+		rtw_pci_link_hw_disable(rtwdev);
+
 	/* Though there is standard PCIE configuration space to set the
 	 * link control register, but by Realtek's design, driver should
 	 * check if host supports CLKREQ/ASPM to enable the HW module.
-- 
2.55.0

