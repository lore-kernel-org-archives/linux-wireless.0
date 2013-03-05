Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:38057 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3CEA2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:28:19 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/7] mwifiex: fix [-Wunused-function] warnings on pcie suspend/resume
Date: Mon,  4 Mar 2013 16:27:54 -0800
Message-Id: <1362443279-6064-3-git-send-email-bzhao@marvell.com> (sfid-20130305_012821_874998_D0BCA106)
In-Reply-To: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
References: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/mwifiex/pcie.c:204:12: warning:
  'mwifiex_pcie_resume' defined but not used [-Wunused-function]
drivers/net/wireless/mwifiex/pcie.c:166:12: warning:
  'mwifiex_pcie_suspend' defined but not used [-Wunused-function]

The suspend/resume handlers ought to be under CONFIG_PM directive.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index c3270e8..44902a3 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -76,6 +76,7 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 	return false;
 }
 
+#ifdef CONFIG_PM
 /*
  * Kernel needs to suspend all functions separately. Therefore all
  * registered functions must have drivers with suspend and resume
@@ -149,6 +150,7 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
 
 	return 0;
 }
+#endif
 
 /*
  * This function probes an mwifiex device and registers it. It allocates
-- 
1.7.0.2

