Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43612 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbK0Nnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 08:43:43 -0500
Date: Fri, 27 Nov 2015 16:43:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] brcm80211: fix error code in brcmf_pcie_exit_download_state()
Message-ID: <20151127134327.GA16802@mwanda> (sfid-20151127_144348_480849_CB76EDC8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original code returns 1 on failure and 0 on success but the caller
was expecting an error code on failure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 83d8042..e149541 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -622,7 +622,9 @@ static int brcmf_pcie_exit_download_state(struct brcmf_pciedev_info *devinfo,
 		brcmf_chip_resetcore(core, 0, 0, 0);
 	}
 
-	return !brcmf_chip_set_active(devinfo->ci, resetintr);
+	if (!brcmf_chip_set_active(devinfo->ci, resetintr))
+		return -EINVAL;
+	return 0;
 }
 
 
