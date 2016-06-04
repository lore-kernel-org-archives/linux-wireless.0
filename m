Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34357 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbcFDNVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 09:21:10 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: add QCA9887 chipset support
Date: Sat, 4 Jun 2016 13:21:01 +0000
Message-ID: <87twh9t7ib.fsf@kamboji.qca.qualcomm.com> (sfid-20160604_152114_946497_4D8EAA20)
References: <1568876.Six5hABE57@bentobox>
	<1463755272-12912-1-git-send-email-sven.eckelmann@open-mesh.com>
In-Reply-To: <1463755272-12912-1-git-send-email-sven.eckelmann@open-mesh.com>
	(Sven Eckelmann's message of "Fri, 20 May 2016 16:41:11 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:

> Add the hardware name, revision, firmware names and update the pci_id
> table.
>
> QA9887 HW1.0 is supposed to be similar to QCA988X HW2.0 . Details about
> he firmware interface are currently unknown.
>
> Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>

I added the warning we talked about, diff below. Full patch in the
pending branch:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ed730faad11df99f2aba3b8d78ac5587c3403e69

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d34c32a075ac..3e8e7ed6faa1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3005,6 +3005,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
 		break;
 	case QCA9887_1_0_DEVICE_ID:
+		dev_warn(&pdev->dev, "QCA9887 support is still experimental, there are likely bugs. You have been warned.\n");
 		hw_rev = ATH10K_HW_QCA9887;
 		pci_ps = false;
 		pci_soft_reset = ath10k_pci_warm_reset;


-- 
Kalle Valo