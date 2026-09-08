Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B19556BBD;
	Tue,  8 Sep 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881185; cv=none; b=HWQjVrMY1jXuU2VqtJE3rIf/366SvHwAJrhd0LeimqTwV1eQ0dsJnYZZ31OAFVkJM0c+uLOwJ3pOlJR8DON3wd+Uk5P2stlUsIRoXcHFQxOWwPR2dVfs+LAdkd/2UeGpWCcgm2Ae9cQ3/VHUw8bS/GiQFxG9Atjr01xsrcxvKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881185; c=relaxed/simple;
	bh=SJCZgyDPI7ofyvbsizKHWeIokAakDBKF0XCm339rtOA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=R3Nk5FPdawIJIW5W06YwRNhg9sPEJK7WGLpZG04UeoXwQ106EWwd2I2XA8D5OQUyrdogMOgmAJu+uoY/p1Ma8bzsKmp8hy/AyTAXg0TT7UtS9CVpDSPoxsAM0zoHlx9uTGUIJg/5Vvtk5N1yMQMTWpuOeRuwOMIXzoYBS+rdo4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=gaAIT9aA; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="gaAIT9aA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1788881178;
	bh=SJCZgyDPI7ofyvbsizKHWeIokAakDBKF0XCm339rtOA=;
	h=From:Date:Subject:To:Cc:From;
	b=gaAIT9aArrsjo4DzGu1RO4uOO2aGh4S1jrBf0pmwEFwGO5L8RFa/GToC2V+E5rNww
	 vK03nOXFYZnyISozqv5mnFgpn3mBqwns2fohntPwhuelt+fMuqtHvON72/jouQ2eDr
	 Uf6IBk5He+k2V4tbYGWxn5k39Hk0jmMpZd38H1jWLaJGco46atxkZC9xwHbL1zVONY
	 H2b62Gob5IhEtIwabQfxcyfaw8PDwGTAiJSz3pV2HA3geq2g4rnlMjePUxyz+W2bnt
	 /l5bl15d9t2G/4nKTFPfo28ZwLt1XolLZb1QJnmR+Je3jIBRASCaFCAB18PkmYvQOR
	 NEvzAfElNMuiw==
Received: from jupiter.universe (unknown [100.64.1.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	(Authenticated sender: sre)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 58D6017E0420;
	Tue, 08 Sep 2026 17:26:18 +0200 (CEST)
Received: by jupiter.universe (Postfix, from userid 1000)
	id 19DD748002B; Tue, 08 Sep 2026 17:26:18 +0200 (CEST)
From: Sebastian Reichel <sebastian.reichel@collabora.com>
Date: Tue, 08 Sep 2026 17:26:12 +0200
Subject: [PATCH net-next] wifi: brcmfmac: Improve D3 substate entering
 timeout handling
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-brcmfmac-bcm43752-suspend-fix-v1-1-32585639d763@collabora.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMUQrCMBCE4auUfXYhTW21XkV8SJOJRkgs2VQKp
 Xc36uM/A99GghwgdGk2yngHCa9Uoz00ZB8m3cHB1Sat9KBGdeYp2+ijsTzZeOxOvWZZZEZy7MP
 Kfui7Ec60UI6qMWfU+edfKaFwwlro9n9kmZ6w5cvTvn8AkyjlTYsAAAA=
X-Change-ID: 20260908-brcmfmac-bcm43752-suspend-fix-f6539eda1e0d
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org, 
 linux-rockchip@vger.kernel.org, kernel@collabora.com, 
 Sebastian Reichel <sebastian.reichel@collabora.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2603;
 i=sebastian.reichel@collabora.com; h=from:subject:message-id;
 bh=SJCZgyDPI7ofyvbsizKHWeIokAakDBKF0XCm339rtOA=;
 b=owJ4nAFtApL9kA0DAAoB2O7X88g7+poByyZiAGqgKRo8y2VmGYf4BIyks2WRT+wE/N7Kfn9Yg
 qbvZOkA84uMX4kCMwQAAQoAHRYhBO9mDQdGP4tyanlUE9ju1/PIO/qaBQJqoCkaAAoJENju1/PI
 O/qakQYP/jMeJljX2hbuCoCP90y6a4SbH4ycGwWknxl8ru0BaUB1Ij0Oidm2uCBFsOYm9QlsuDH
 0kuucrywl1INoyFj5lxUiOGNRveJx4noJc5+oPiI4hS0IRZntjhIA6up/CpcBLK62T3P+LqsRMV
 klh/GCNgXzLpm6oi9xv8/H2XLvLPP1J+vrD0SzgxcTaM6RWFVqrDI7qbKMivVqYwiPHwulgPent
 v6+gBdSY5Mwfyi9RLvjTp9XtV6wpYBkWPIlRBWhlHQHeAkTgTSl4h2R7URgp/Oqp4pe7Q9jSZFe
 JJtq8CXPeKlssLgkN+eJW3Y/v9KHmpYLzCON/Pcoglv7GrqJvN58NRi42VzrGinAlTRb86eypHb
 WfkmuoJA+J+2sjjrI9sKYgL6UXixHsPSJDI3xOo+NVICEbjuNkFqsBfbFbkT0gDYxxM7NbkjORx
 BCzSoRVwcGHIJXiEt5VPqvyK4fLYfIOsbSgP08yuaHKQ98TzMt7ZG5SNEGo/vcxjEPk4vlDdguo
 /932eb4wIou2H+60AuYLV4CRRSLm7b7BWQVMtdn/5AbdIlr870q6i1DEHFOYGG75Ftefw6DRdh+
 0xsIDI4FBJrrB0SmwLdQrQyoPhAmpiWCm60dW8G8XAeped3Y5KLO2YQC5m1Tf8v+x6Od+W4mseF
 4NM4uQ1obeGa1I7v+/fwq2A==
X-Developer-Key: i=sebastian.reichel@collabora.com; a=openpgp;
 fpr=EF660D07463F8B726A795413D8EED7F3C83BFA9A

Some firmwares (e.g. BCM43752) do not service the D3_INFORM mailbox
handshake when idle, so the D3 ACK never arrives. If WoWL is not armed
the device is going to be powered off during system suspend and
re-probed on resume anyway (brcmf_pcie_pm_leave_D3() handles that), so
the missing ACK is harmless and must not abort the whole system suspend.
When WoWL is active the device has to stay powered with its state
preserved, so keep treating the timeout as fatal.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
This was tested with Rockchip RK3588 EVB1, which has a BCM43752 based
WLAN card (AP6275P). This card is also used by a few other Rockchip
boards (at least Khadas Edge2, RK3576 EVB1). Unfortunately
linux-firmware does not contain any firmware files for this chip,
so I used the files available from Armbian [0]:

3779bd4f629961cf060a83cc5047a3b9b2d23c9d  brcmfmac43752-pcie.bin
a471651d580b51da2a681e53c0cc3258eaa70e10  brcmfmac43752-pcie.clm_blob
87294b22f4bf7b7f718cf24076f102df07e3c414  brcmfmac43752-pcie.txt

[0] https://github.com/armbian/firmware/tree/master/brcm

At least with that firmware the suspend command times out blocking
system suspend. Testing on the Rockchip platform requires PCIe
suspend support for it, which has been send separately.

The patch is based on v7.3-rc1 and can go via -next as system suspend
with mainline kernel needs quite some work on Rockchip anyways.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 55f4d7b970f2..c1a029d86c0f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2653,8 +2653,13 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 			   BRCMF_PCIE_MBDATA_TIMEOUT);
 	if (!devinfo->mbdata_completed) {
 		brcmf_err(bus, "Timeout on response for entering D3 substate\n");
-		brcmf_bus_change_state(bus, BRCMF_BUS_UP);
-		return -EIO;
+
+		if (devinfo->wowl_enabled) {
+			brcmf_bus_change_state(bus, BRCMF_BUS_UP);
+			return -EIO;
+		}
+
+		brcmf_dbg(PCIE, "No D3 ACK, continuing to power the device off\n");
 	}
 
 	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260908-brcmfmac-bcm43752-suspend-fix-f6539eda1e0d

Best regards,
--  
Sebastian Reichel <sebastian.reichel@collabora.com>

