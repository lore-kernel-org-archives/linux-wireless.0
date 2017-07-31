Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34179 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdGaNHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 09:07:34 -0400
Received: by mail-pf0-f195.google.com with SMTP id t86so4168372pfe.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2017 06:07:34 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 1/2] mwifiex: make addba request command clean
Date: Mon, 31 Jul 2017 13:07:26 +0000
Message-Id: <1501506447-31851-1-git-send-email-huxinming820@gmail.com> (sfid-20170731_150737_728482_DE2520CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

uninitilized variable, such as .add_req_result might be magic stack
value. Initialize the structure to make it clean.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 16c77c2..7252069 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -572,6 +572,8 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 
 	mwifiex_dbg(priv->adapter, CMD, "cmd: %s: tid %d\n", __func__, tid);
 
+	memset(&add_ba_req, 0, sizeof(add_ba_req));
+
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
 	    priv->adapter->is_hw_11ac_capable &&
-- 
1.9.1
