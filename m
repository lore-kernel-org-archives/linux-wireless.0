Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B295435E95A;
	Sat, 22 Aug 2026 21:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787432433; cv=none; b=uCH2yhpwKOoVgQKXHefEmb4OJi4q6mCfGPmsZbMv+lytL4ldYrLD3a2+/MUTVa6+ZVAVXta0KCygj6HnbwbCgUvJJbtEdHLH48Pp4hHOfiHfORrgSxVz9eHUM7W0ElkPXOel5BueJGdtT8NqUvORKC0FsIewNXZr/E9FNFCo+xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787432433; c=relaxed/simple;
	bh=wDPoPuk/ukzUrysfCrl6e7MPZBORB307fjCc0yo/Si4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=CJiAVeeLdscwNrLeoaDEjQZcHghAZ4ugdI6QmGU4E/m5G7RTdU4Tfzq0cLa7FLsqq2J4toTThguh/F8xN4qMr0SuMv8tk90vd4ax4taF5Hl0mjMBPEQRW0eYXgy9bWXFqaj6SYIrphyrUkUP/XFBQ1LFKEtd7/sJf7WsKHs4MvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMdobrGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMdobrGz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D35AC2BCB3;
	Sat, 22 Aug 2026 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787432433;
	bh=wDPoPuk/ukzUrysfCrl6e7MPZBORB307fjCc0yo/Si4=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=vMdobrGzzD4yiqCszYrIKFfsiqnu3VZVU5jN0CUsVG8zD/aVsjfH5AYT6C0flEx/f
	 9fz6JsFU+VVTV99TNtoIGrgXDLLL6AVc4nrorhaMZUny+HZo4X5Ty+/HbP6aQ7neFA
	 xBMuJD+pfss5Jk82BBhakeGvsAfRQiPETYLScZn1sf84qQdwPNbuWq901K4T04RYzl
	 wfg9VZO4prpqWk4SACi0Zo86esorDuP75TSyIXqdcCclybk+VM9yvPIlq0EtJDIeQZ
	 NQ2+2CpUeqJNLc87DJe4JdZXywW7wARphT2aHAIoQfJpFYoLQWJMT2px6yezWpCSKZ
	 MRPlGM8T+6HoA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0489AC5B572;
	Sat, 22 Aug 2026 21:00:33 +0000 (UTC)
From: Rahul Kumar Rai via B4 Relay <devnull+learn.rahul.rai.gmail.com@kernel.org>
Date: Sun, 23 Aug 2026 02:30:32 +0530
Subject: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming
 A15 FA506IH
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-fa506ih-rtw88-quirk-v1-1-ef0984d59e72@gmail.com>
X-B4-Tracking: v=1; b=H4sIAO8NimoC/yXMQQ6CMBBA0auQWTvJtIbacBXiAssURhKUKagJ4
 e4WWL7F/yskVuEEVbGC8keSvMYMcykg9M3YMUqbDZasI2+vGJuSnPSo89d7nBbRAV0w5a31FCg
 ayOVbOcrvuNb302l5PDnM+wq27Q9nRYTvdwAAAA==
X-Change-ID: 20260823-fa506ih-rtw88-quirk-6c157d80c0f1
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Rahul Kumar Rai <learn.rahul.rai@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787432431; l=2531;
 i=learn.rahul.rai@gmail.com; s=20260822; h=from:subject:message-id;
 bh=Pz6whzycVyQSyKGgPZ2rblAwgpB9ScAj/UQo4bzF9mM=;
 b=JguIOYUlo7J0TlQpd98nuZmMhoY9B1cNYh/4IdTS6bSWZk4aK5KYYHbZ2xST7iyQZd3kOkH9E
 1LCTLu7fZzOAzWuL0xj6F6pvhZVglcdPCQ8mb/lI7ZaMpT+SOViOWSc
X-Developer-Key: i=learn.rahul.rai@gmail.com; a=ed25519;
 pk=FKMDyIZj21KmruJbeSaCjxqun1AusvFUl0dM21tRMF4=
X-Endpoint-Received: by B4 Relay for learn.rahul.rai@gmail.com/20260822
 with auth_id=970
X-Original-From: Rahul Kumar Rai <learn.rahul.rai@gmail.com>
Reply-To: learn.rahul.rai@gmail.com

From: Rahul Kumar Rai <learn.rahul.rai@gmail.com>

The RTL8822CE on the ASUS TUF Gaming A15 FA506IH fails to return from
PCIe low-power states across system suspend. The device is inaccessible
on the way back to D0, so the MAC power-on sequence and the firmware
handshake that follow it fail, and the driver gives up. Wi-Fi stays
unavailable until the machine is powered off completely:

  rtw88_8822ce 0000:03:00.0: Unable to change power state from D3cold to D0, device inaccessible
  rtw88_8822ce 0000:03:00.0: failed to poll offset=0x5 mask=0x2 value=0x0
  rtw88_8822ce 0000:03:00.0: mac power on failed
  rtw88_8822ce 0000:03:00.0: probe with driver rtw88_8822ce failed with error -114

Reads of the ASPM link-configuration register over DBI also time out
around the same transitions.

This is not a one-off. It has been recurring on this machine for a long
time. The kernel logs still on disk begin at 2026-07-20 and already
contain six failed D-state transitions and three probe failures of this
kind, and the problem was present well before that window.

This is the same platform ASPM inter-operability problem already handled
for other machines through rtw_pci_quirks[], including the closely
related ASUS TUF Gaming A15 FA506II. The FA506IH reports a different DMI
board name, so that entry does not match. Disabling PCI ASPM and deep
power save stops the failure on this model as well.

  DMI_SYS_VENDOR = ASUSTeK COMPUTER INC.
  DMI_BOARD_NAME = FA506IH

Signed-off-by: Rahul Kumar Rai <learn.rahul.rai@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 5b00c1e1eec6..fcb6f4c4cc2d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1789,6 +1789,16 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
 		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
 					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
 	},
+	{
+		.callback = rtw_pci_disable_caps,
+		.ident = "ASUS TUF Gaming A15 FA506IH",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "FA506IH"),
+		},
+		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
+					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
+	},
 	{}
 };
 

---
base-commit: 66fb95a521110da673090294561844c9f76ebe64
change-id: 20260823-fa506ih-rtw88-quirk-6c157d80c0f1

Best regards,
--  
Rahul Kumar Rai <learn.rahul.rai@gmail.com>


