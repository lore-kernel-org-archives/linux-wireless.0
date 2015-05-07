Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23532 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbEGJ7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 05:59:54 -0400
Date: Thu, 7 May 2015 12:59:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] brcmfmac: cleanup a sizeof()
Message-ID: <20150507095919.GB17996@mwanda> (sfid-20150507_120001_424027_FE988AB4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"flowrings" and "*flowrings" are both pointers so this always returns
sizeof(void *) and the current code works fine.  But "*flowrings" is
intended here and static checkers complain, so lets change it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 1831ecd..d371f1e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -1609,7 +1609,7 @@ static void brcmf_pcie_setup(struct device *dev, const struct firmware *fw,
 		bus->msgbuf->commonrings[i] =
 				&devinfo->shared.commonrings[i]->commonring;
 
-	flowrings = kcalloc(devinfo->shared.nrof_flowrings, sizeof(flowrings),
+	flowrings = kcalloc(devinfo->shared.nrof_flowrings, sizeof(*flowrings),
 			    GFP_KERNEL);
 	if (!flowrings)
 		goto fail;
