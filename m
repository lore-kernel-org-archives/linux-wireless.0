Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36436 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbdGUJ5o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 05:57:44 -0400
Received: by mail-pf0-f196.google.com with SMTP id a11so4491061pfj.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jul 2017 02:57:43 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: disable uapsd in tdls config
Date: Fri, 21 Jul 2017 09:57:37 +0000
Message-Id: <1500631057-32395-1-git-send-email-huxinming820@gmail.com> (sfid-20170721_115757_002194_FC6AFB46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Tdls uapsd support capability is default disabled during
tdls setup, correspondingly it should also been disabled
in tdls config.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Zhiyuan Yang <yangzy@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 534d94a..eeef69b 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1755,7 +1755,7 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_vhtcap *vht_capab;
 	struct mwifiex_ie_types_aid *aid;
 	struct mwifiex_ie_types_tdls_idle_timeout *timeout;
-	u8 *pos, qos_info;
+	u8 *pos;
 	u16 config_len = 0;
 	struct station_parameters *params = priv->sta_params;
 
@@ -1789,12 +1789,11 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 		put_unaligned_le16(params->capability, pos);
 		config_len += sizeof(params->capability);
 
-		qos_info = params->uapsd_queues | (params->max_sp << 5);
-		wmm_qos_info = (struct mwifiex_ie_types_qos_info *)(pos +
-								    config_len);
+		wmm_qos_info = (void *)(pos + config_len);
 		wmm_qos_info->header.type = cpu_to_le16(WLAN_EID_QOS_CAPA);
-		wmm_qos_info->header.len = cpu_to_le16(sizeof(qos_info));
-		wmm_qos_info->qos_info = qos_info;
+		wmm_qos_info->header.len =
+				cpu_to_le16(sizeof(wmm_qos_info->qos_info));
+		wmm_qos_info->qos_info = 0;
 		config_len += sizeof(struct mwifiex_ie_types_qos_info);
 
 		if (params->ht_capa) {
-- 
1.9.1
