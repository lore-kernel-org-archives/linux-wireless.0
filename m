Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:51732 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030391Ab2CNCsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 22:48:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: correction in structure name passed to sizeof()
Date: Tue, 13 Mar 2012 19:36:49 -0700
Message-Id: <1331692609-5845-1-git-send-email-bzhao@marvell.com> (sfid-20120314_034804_647644_113CC689)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

"hscfg" is declared as struct mwifiex_ds_hs_cfg. Use same structure
name for calculating it's size.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 64e0b10..d7b11de 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -425,7 +425,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 
 	adapter->hs_activate_wait_q_woken = false;
 
-	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
+	memset(&hscfg, 0, sizeof(struct mwifiex_ds_hs_cfg));
 	hscfg.is_invoke_hostcmd = true;
 
 	if (mwifiex_set_hs_params(mwifiex_get_priv(adapter,
-- 
1.7.0.2

