Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15489 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbbLIKW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:22:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/13] brcmfmac: Change error print in debug print.
Date: Wed, 9 Dec 2015 11:22:50 +0100
Message-ID: <1449656572-16158-12-git-send-email-arend@broadcom.com> (sfid-20151209_112331_094264_684A65DB)
In-Reply-To: <1449656572-16158-1-git-send-email-arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The pcie suspend and resume routines contain some error prints,
which should have been debug prints.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Change-Id: Ibafe5d38301ee8f5e86889259ddeaea4dcae4cee
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5581
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 4ebc53c..3d2d790 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1875,7 +1875,7 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 	struct brcmf_pciedev_info *devinfo;
 	struct brcmf_bus *bus;
 
-	brcmf_err("Enter\n");
+	brcmf_dbg(PCIE, "Enter\n");
 
 	bus = dev_get_drvdata(dev);
 	devinfo = bus->bus_priv.pcie->devinfo;
@@ -1906,7 +1906,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 	struct pci_dev *pdev;
 	int err;
 
-	brcmf_err("Enter\n");
+	brcmf_dbg(PCIE, "Enter\n");
 
 	bus = dev_get_drvdata(dev);
 	devinfo = bus->bus_priv.pcie->devinfo;
-- 
1.9.1

