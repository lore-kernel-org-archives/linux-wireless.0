Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23664 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaI3FaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 01:30:20 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <maithili@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>, <yangyang@marvell.com>,
	<akarwar@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: add client mac address while configuring keys on GO.
Date: Tue, 30 Sep 2014 16:29:38 +0530
Message-ID: <1412074778-5596-1-git-send-email-patila@marvell.com> (sfid-20140930_073023_966187_26A4018E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

When mwifiex device becomes GO, unicast traffic between client1 and GO stops
when client2 connects to GO. Reason behind this was PTK getting
overwritten by key_material command for client2 as it did not have client
mac address. So, client1 can no more decode GO's ping packets though it
responds to its broadcast packets.

This patch adds case to check for BSS_ROLE instead of bss_type to set
client mac address while configuring keys when device becomes GO.

Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 225f749..1c2ca29 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -938,7 +938,7 @@ mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
 		cmd->size = cpu_to_le16(sizeof(key_material->action) + S_DS_GEN
 					+ key_param_len);
 
-		if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
+		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
 			tlv_mac = (void *)((u8 *)&key_material->key_param_set +
 					   key_param_len);
 			tlv_mac->header.type =
-- 
1.8.1.4

