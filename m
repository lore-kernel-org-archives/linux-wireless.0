Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:63570 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLCUFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:39 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/7] brcmfmac: Add PCIE ids for 43602 devices.
Date: Wed, 3 Dec 2014 21:05:29 +0100
Message-ID: <1417637133-6966-4-git-send-email-arend@broadcom.com> (sfid-20141203_210545_731342_CC8492CF)
In-Reply-To: <1417637133-6966-1-git-send-email-arend@broadcom.com>
References: <1417637133-6966-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Some 43602 devices are band specific and identify themselves
with different PCIE device ID. This patch adds support for the
43602 2.4G and 5.0G devices used in for example R8000 router.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c       | 2 ++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index b0ae799..b87b727 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -1857,6 +1857,8 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID),
 	{ /* end: all zeroes */ }
 };
 
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index af26e0d..6996fcc 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -68,6 +68,8 @@
 #define BRCM_PCIE_43567_DEVICE_ID	0x43d3
 #define BRCM_PCIE_43570_DEVICE_ID	0x43d9
 #define BRCM_PCIE_43602_DEVICE_ID	0x43ba
+#define BRCM_PCIE_43602_2G_DEVICE_ID	0x43bb
+#define BRCM_PCIE_43602_5G_DEVICE_ID	0x43bc
 
 /* brcmsmac IDs */
 #define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
-- 
1.9.1

