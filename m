Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:58589 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752253Ab2E2WjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:39:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2 RESEND 3.5] mwifiex: invalidate bss config before setting channel for uAP
Date: Tue, 29 May 2012 15:39:04 -0700
Message-Id: <1338331146-13540-1-git-send-email-bzhao@marvell.com> (sfid-20120530_003942_629809_C4BA13EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Mark bss_config parameters as invalid before setting AP channel.
This prevents from setting invalid parameters while setting AP
channel to FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
Patch was sent as 1/3 for 3.5. As 3/3 was dropped, resend as 1/2.

 drivers/net/wireless/mwifiex/uap_cmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 76dfbc4..e9482c9 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -416,6 +416,7 @@ int mwifiex_uap_set_channel(struct mwifiex_private *priv, int channel)
 	if (!bss_cfg)
 		return -ENOMEM;
 
+	mwifiex_set_sys_config_invalid_data(bss_cfg);
 	bss_cfg->band_cfg = BAND_CONFIG_MANUAL;
 	bss_cfg->channel = channel;
 
-- 
1.7.0.2

