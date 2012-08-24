Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38697 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2HXFZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 01:25:32 -0400
MIME-Version: 1.0
Date: Fri, 24 Aug 2012 13:25:30 +0800
Message-ID: <CAPgLHd81cZS4K-wzcLycRTVF3pGy-S6=YR9UZ++Ot=6OXZp-5Q@mail.gmail.com> (sfid-20120824_072552_923154_8492AB3D)
Subject: [PATCH v2] mwifiex: use is_broadcast_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: bzhao@marvell.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_broadcast_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is broadcast
address.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/mwifiex/sta_cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index df3a33c..323b91b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -551,7 +551,6 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 	struct host_cmd_tlv_mac_addr *tlv_mac;
 	u16 key_param_len = 0, cmd_size;
 	int ret = 0;
-	const u8 bc_mac[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_KEY_MATERIAL);
 	key_material->action = cpu_to_le16(cmd_action);
@@ -593,7 +592,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			/* set 0 when re-key */
 			key_material->key_param_set.key[1] = 0;
 
-		if (0 != memcmp(enc_key->mac_addr, bc_mac, sizeof(bc_mac))) {
+		if (!is_broadcast_ether_addr(enc_key->mac_addr)) {
 			/* WAPI pairwise key: unicast */
 			key_material->key_param_set.key_info |=
 				cpu_to_le16(KEY_UNICAST);


