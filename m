Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:40787 "HELO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751480Ab2EQEdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 00:33:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: invalidate bss config before setting channel for uAP
Date: Wed, 16 May 2012 21:24:54 -0700
Message-Id: <1337228696-22312-1-git-send-email-bzhao@marvell.com> (sfid-20120517_063324_438957_CBD224CC)
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

