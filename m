Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793526583;
	b=sMdwF1j5QhGsDf5vjEeTqtm5aCfYKJ4o7czRhXvDQcQ+1ammlmyMOFa7W3YB5LL8CoSR
	 hUwJ+BqNBhl5hGKETgJHvd3yfU1qVS7Wi9p0q5ZLXt0qbQKwMbtNHaV8eQYUVZtyBUHeQ
	 dSB48SC4yYvkCsE0M2X05vDEVqY0GbvKcTLkrCC1KKAARo12rAIMA+QfM9yMrNl6Yuf71
	 rUNu+LxmUmRKLdjFPu0ojRKbpmHNFX6BLj2K7cN+mvAqUInQiFp4RcFMOkPXpoE68dcXJ
	 DnBldoM2Zg5P2ByFllVOKZUikCwHEdLCcbN1YBgkBPnPQkfBh/pyIPQMaKDB6CKA38Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793526583;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=iZ66pNG8GoqKxl3dX3y81a9lvY+mrvP5917Q/wYwODo=;
	b=TGWUVHljwaoOUJCCbtiamRYEvFTM547EslX0jMCjiUhiHmpqplS2hbOvYN5BtZ6TWKGp
	 6+pxRHVksuFwQlh+6w0N73Ti2qHbjA1xpxElnIH3Txb3U3hch02ThqCN8GGzizO49TuOh
	 BsnQuN7A2ij7cBnWWzCj/J19hLNC/WzzJ/k5PWeSLG4WtCKTjkgAzXAzypQXlKuvSZc3P
	 +54sReq0X2hIXG4Sw6B3aVuOiFcrQ+YxQpisrs/hzj71FNdqb2SJq8aoxuCteHWFXHq/e
	 mCh3WfqSqvyloVSqHGSja2e14bNDg89QD+2svgLFS89PTB2ScB+3NzM60mUh902oqMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="u/8/bRD2";
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD880606A325
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 09:49:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD880606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u/8/bRD2
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-15ea896ddc8so3589975c88.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 01:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793526582; x=1794131382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iZ66pNG8GoqKxl3dX3y81a9lvY+mrvP5917Q/wYwODo=;
        b=u/8/bRD2Dahmc0w+8YjW5sCXVv8pBLBhfsD7KwtcQcOwHHzPoh6cjpKX0Z6g5DE+gD
         H+58U/JOUsoRluOzRy8yqgVG+wg9oQjifvZi0qkBbZsv4y4ekkOcJdBY5bQAcI4NGRO6
         8TF3h7sUd+KOPV8YKEmwSwmoBewcbmkDYo0PNdEb92k7x9ATgR/W/u8LPZPDe8Cm+sNb
         gXM5/GHMc/Rxa7wk/6he6aFUZCTNbWTUAcba+lhBL3KsnSix4zSf9hjGN6T9ywzZcKd3
         z2NSLxulHjwTz7yAQGz7D0nWoamsmjdWk2SQUGhKs5WP9sBzu/GTeBwTA53KPy7BwWYA
         64Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793526582; x=1794131382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iZ66pNG8GoqKxl3dX3y81a9lvY+mrvP5917Q/wYwODo=;
        b=VWwNn2peoxAoP05FjBMZnbZ8V/eaJDyIo8vlVYeRxKIr+oKgNofHfvVXbsogDhXTv6
         v9jDzu5CCuPDviBmG7SaZx2XNGre7caKELMInTrW1CNqU5uVWyjAYyLJ22GRl8wZKIZ+
         Yvkz/eeRnH9MQ285ZvMsYvd7vxD1d0navO6tWzFvVWIbtAeRQK4QPxXs54NpHSVjNv/r
         n9vYtCCqrFbQDWB332ILo4VDJT7QZ+jMaaOAqgxdgNaylo/nDf5jsrQWWpp3buRRmMaY
         HVoqGk710hzh45t2mAYEaZl1z+oAk6dSvdZC3P04uPs59P59ZOgvSIhQj02S1jCn/StR
         YWiQ==
X-Gm-Message-State: AFq9FYKtjR5jIgxn/2juNWJnkD7Qq2zphbWTZxwXScy0oHlpHdYYm8BE
	o+PviQDU7BH1wScsuNFl3hzRIauZQhf6M3cjRGRnkYvK7wKbbL0GB7PR
X-Gm-Gg: AYBFou3rDMUJsJGGiqjsnj9sgl4g7M9oPnhbTAyK0rUqhOHYihNOsXIUb3PdYORCeOM
	KeV5cRW/mNbd5QNoqqGflw/Itk+aYVqFkcCk8MCBK+BVUCu/M6Zc1NCvpHMCzcrOeToMadLktGt
	h7TFPYiZMhRXDp6cQCNo7Vvn3Me3WnWy68+BgTLa8kiymK7GPdzzk9b3QuIZahxmT3IjTVVzfAT
	HSoND+pLuspermEm8Vr8m8qFKrLee6Sfm+DGofi82XSWt98XAaZrtaSjkXn8xvFfUbn+4GlMxMz
	0lYCuSsmvS1zLoOhzXW26kgfgpvk0CAcuMifW3/y2T85f5EmRPOCqMN3IW+c3vUnh0OQPHZyTBw
	OwxcSvjjJZ1okaljt6DQYtq7QQnhz1fji3ybJWVVETd6S1yTzktEyE+TXL3DDIGKw2GGw3QPIzx
	sbrV/Bs3IzbR9/mmW428Lw++WIyJ7h1HIOp+1Tz7lOqjU7D8IU4TfhRxAVQKq8ZHwT0x6S7Bnbz
	xwWdsqJzvn4g8aAg+4XarAJmHFfoDjh1tgGNLWKp1uLlbRv33kheWfiJ6p34J5ztjVT1JftAna8
	awk0gF0sfaStKgHdjmNeQygiF6mUQ/q6G2qYMnduKlfep9Jkfzi26jFC9A==
X-Received: by 2002:a05:7022:eb42:20b0:190:3950:43e2 with SMTP id a92af1059eb24-1ac5a0b8867mr10726412c88.8.1793526581606;
        Sun, 01 Nov 2026 01:49:41 -0800 (PST)
Received: from xploitoverload ([2406:b400:f11:1bac:4040:640b:8a1:8629])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac192c27cdsm40740627c88.10.2026.11.01.01.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 01:49:41 -0800 (PST)
From: Kalpesh Solanki <skalpesh942@gmail.com>
To: pkshih@realtek.com,
	kvalo@kernel.org
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kalpesh Solanki <skalpesh942@gmail.com>
Subject: [PATCH 1/2] wifi: rtw88: pci: Add DMI quirk for HP Laptop 15s-fr5xxx
Date: Sun,  1 Nov 2026 15:19:04 +0530
Message-ID: <20261101094905.1299638-1-skalpesh942@gmail.com>
X-Mailer: git-send-email 2.53.0
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

On the HP Laptop 15s-fr5xxx with RTL8822CE, PCIe ASPM L1/L1.2 and deep LPS
cause the card's firmware to fail to resume from low-power states,
resulting in repeated 'firmware failed to leave lps state' and
'failed to send h2c command' errors and stalled network traffic.

Add a DMI quirk entry for 'HP Laptop 15s-fr5xxx' to disable PCIe ASPM
and deep LPS, ensuring reliable Wi-Fi operation.

Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index ca4e779..30b7904 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1813,6 +1813,16 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
 		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
 					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
 	},
+	{
+		.callback = rtw_pci_disable_caps,
+		.ident = "HP Laptop 15s-fr5xxx",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15s-fr5xxx"),
+		},
+		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
+					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
+	},
 	{
 		.callback = rtw_pci_disable_caps,
 		.ident = "ASUS TUF Gaming A15 FA506II",
-- 
2.53.0

