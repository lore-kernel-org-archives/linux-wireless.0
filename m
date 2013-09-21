Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60242 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932Ab3IUC45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 22:56:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.12] mwifiex: fix PCIe hs_cfg cancel cmd timeout
Date: Fri, 20 Sep 2013 19:56:45 -0700
Message-ID: <1379732205-23419-1-git-send-email-bzhao@marvell.com> (sfid-20130921_045716_909668_D598D705)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For pcie8897, the hs_cfg cancel command (0xe5) times out when host
comes out of suspend. This is caused by an incompleted host sleep
handshake between driver and firmware.

Like SDIO interface, PCIe also needs to go through firmware power
save events to complete the handshake for host sleep configuration.
Only USB interface doesn't require power save events for hs_cfg.

Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 2d76147..a6c46f3 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1155,7 +1155,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 	uint32_t conditions = le32_to_cpu(phs_cfg->params.hs_config.conditions);
 
 	if (phs_cfg->action == cpu_to_le16(HS_ACTIVATE) &&
-	    adapter->iface_type == MWIFIEX_SDIO) {
+	    adapter->iface_type != MWIFIEX_USB) {
 		mwifiex_hs_activated_event(priv, true);
 		return 0;
 	} else {
@@ -1167,8 +1167,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 	}
 	if (conditions != HS_CFG_CANCEL) {
 		adapter->is_hs_configured = true;
-		if (adapter->iface_type == MWIFIEX_USB ||
-		    adapter->iface_type == MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			mwifiex_hs_activated_event(priv, true);
 	} else {
 		adapter->is_hs_configured = false;
-- 
1.8.2.3

