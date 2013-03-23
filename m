Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51295 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755489Ab3CWEtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 00:49:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: avoid waking up device in awake state
Date: Fri, 22 Mar 2013 21:49:06 -0700
Message-ID: <1364014147-13986-3-git-send-email-bzhao@marvell.com> (sfid-20130323_054931_268034_1057B0F0)
In-Reply-To: <1364014147-13986-1-git-send-email-bzhao@marvell.com>
References: <1364014147-13986-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

We have received interrupt from device means FW is not sleeping.
In this case make sure wakeup handler for PCIe is not invoked by
setting adapter->pm_wakeup_fw_try to false.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 112649a..63c2921 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1984,12 +1984,13 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 				}
 			}
 		} else if (!adapter->pps_uapsd_mode &&
-			   adapter->ps_state == PS_STATE_SLEEP) {
+			   adapter->ps_state == PS_STATE_SLEEP &&
+			   mwifiex_pcie_ok_to_access_hw(adapter)) {
 				/* Potentially for PCIe we could get other
 				 * interrupts like shared. Don't change power
 				 * state until cookie is set */
-				if (mwifiex_pcie_ok_to_access_hw(adapter))
-					adapter->ps_state = PS_STATE_AWAKE;
+				adapter->ps_state = PS_STATE_AWAKE;
+				adapter->pm_wakeup_fw_try = false;
 		}
 	}
 }
-- 
1.7.0.2

