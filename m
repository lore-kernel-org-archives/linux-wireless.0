Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:46762 "HELO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758084Ab2FUC7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 22:59:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Ying Luo <luoy@marvell.com>, Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: enhance power save for USB and PCIe chipsets
Date: Wed, 20 Jun 2012 19:58:37 -0700
Message-Id: <1340247517-4593-6-git-send-email-bzhao@marvell.com> (sfid-20120621_045922_560265_DAC79FE7)
In-Reply-To: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
References: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

FW will not explicitly notify about host sleep activation to the
host for USB and PCIe chipsets. Hence host should generate Host
Sleep Activated event as soon as Host Sleep parameters are
configured to FW successfully.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 51e023e..ea37b88 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1102,7 +1102,8 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 		&resp->params.opt_hs_cfg;
 	uint32_t conditions = le32_to_cpu(phs_cfg->params.hs_config.conditions);
 
-	if (phs_cfg->action == cpu_to_le16(HS_ACTIVATE)) {
+	if (phs_cfg->action == cpu_to_le16(HS_ACTIVATE) &&
+	    adapter->iface_type == MWIFIEX_SDIO) {
 		mwifiex_hs_activated_event(priv, true);
 		return 0;
 	} else {
@@ -1114,6 +1115,9 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 	}
 	if (conditions != HOST_SLEEP_CFG_CANCEL) {
 		adapter->is_hs_configured = true;
+		if (adapter->iface_type == MWIFIEX_USB ||
+		    adapter->iface_type == MWIFIEX_PCIE)
+			mwifiex_hs_activated_event(priv, true);
 	} else {
 		adapter->is_hs_configured = false;
 		if (adapter->hs_activated)
-- 
1.7.0.2

