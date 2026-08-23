Received: from mailsrv.dsidata.sk (mailsrv.dsidata.sk [80.87.208.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E2B24DD17
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.87.208.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787499914; cv=none; b=BTrta1qkGBH/7cF//TTZ/wgm6kUVAAGRwE+W74BDZcdsHUxD0dDVVkFdFDyGr5KJTzNvqpGINJSkJoxA2z9wxJz+ydKLPJmt998oJuPLN2BNGOKOg5v/oSP3lV/7SrQmxzctc0eSX+44b3xUifiKVWK9zSoVrzfZCmHsafTMPDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787499914; c=relaxed/simple;
	bh=8NgnQCE6aR7d9HJwLU4A8zHGmTeWADVZhCuH3Z1M1Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VkVudjgiIT5wzpwG3lDF2KiMhQ2Yle8oVIwbtzI6mflbVH6yhWkp4iuQ+SZGjuxB0qq3WVDk2bGh3FS5TLfNX5pN1X/aImUsgYmoIigYoVN+iVI2ThDpnwq3ktCLBz23CVn2Tue8qyhS8vWVdIXWDPWIY9i1jaH+837TlmxFsj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orava.sk; spf=pass smtp.mailfrom=orava.sk; dkim=pass (1024-bit key) header.d=orava.sk header.i=@orava.sk header.b=wA25p9be; arc=none smtp.client-ip=80.87.208.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orava.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=orava.sk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=orava.sk header.i=@orava.sk header.b="wA25p9be"
DKIM-Signature: a=rsa-sha256; t=1787499782; x=1788104582; s=2018; d=orava.sk; c=relaxed/relaxed; v=1; bh=Hi12nOeMabzc0Zlu0H9auVAYwwuKtqILX5U2Nlo7mX0=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Transfer-Encoding;
   b=wA25p9bejoVA3xRh73ra1ODb8YVGpRrBJM9EHWAeemImEnEMrR+DkRlfNC+xTIlF24I2xywIm9cDgJFCLGS3KJvrKUGKZszz0QLKhmxfDU+fhZ4zqvCTwWYN7YwsQUiiU9uvqayjAwT43R/Zs2pIT1FbirZN2EvnAgy7GHjqzB8=
Received: from brko-notebook.localdomain ([213.81.222.48])
        by mailsrv.dsidata.sk (14.2.0 build 16 ) with ASMTP (SSL) id 202608231742414447;
        Sun, 23 Aug 2026 17:42:41 +0200
From: Branislav Klocok <branislav.klocok@orava.sk>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	Branislav Klocok <branislav.klocok@orava.sk>
Subject: [PATCH] wifi: rtw88: add quirks to disable PCI ASPM and deep LPS for Dell Vostro 15 3530
Date: Sun, 23 Aug 2026 17:42:28 +0200
Message-ID: <20260823154228.129848-1-branislav.klocok@orava.sk>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a Dell Vostro 15 3530 with RTL8821CE [10ec:c821] the driver floods the
kernel log with

  rtw88_8821ce 0000:03:00.0: failed to send h2c command

at roughly 220 messages per minute while the interface is associated. On
this machine that amounted to 143704 of 167707 journal lines in a single
day, or 86 percent of everything logged. The association also dropped
its DHCP lease from time to time.

Disabling PCI ASPM and deep LPS makes the messages disappear entirely.
Measured over one continuous hour with the card as the only route out
and 979 MB received / 341 MB transmitted: zero occurrences, against
roughly 13000 per hour before the change. The only rtw88 lines left in
the log for the whole boot are the interface rename, the firmware
version and "enabling device".

The measurement was taken with the rtw88_pci.disable_aspm=1 and
rtw88_core.disable_lps_deep=1 module parameters, which set the same two
variables that rtw_pci_disable_caps() sets for a quirk entry, so the
result carries over unchanged.

DMI on this machine:

  sys_vendor:   Dell Inc.
  product_name: Vostro 15 3530
  product_sku:  0C32
  board_name:   0RRJRM
  BIOS:         1.3.0

Signed-off-by: Branislav Klocok <branislav.klocok@orava.sk>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

Compile-tested on openSUSE Tumbleweed 7.1.8 with the equivalent entry, since
the ASUS quirk this patch is based on is not in that tree yet.

--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1789,6 +1789,16 @@
 		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
 					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
 	},
+	{
+		.callback = rtw_pci_disable_caps,
+		.ident = "Dell Vostro 15 3530",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 15 3530"),
+		},
+		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
+					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
+	},
 	{}
 };
 
-- 
2.51.0

