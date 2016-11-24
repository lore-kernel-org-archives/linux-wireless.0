Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34335 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbcKXBZk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 20:25:40 -0500
Received: by mail-pf0-f194.google.com with SMTP id y68so1177369pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2016 17:25:39 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 17:25:29 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 3/7] mwifiex: Remove unused 'sta_ptr' variable
Message-ID: <3d66358c2079a1aa0e756a516f4daa3bc54a62b8.1479950323.git.kirtika@google.com> (sfid-20161124_022550_550643_8CCD80EE)
References: <cover.1479950323.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479950323.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 429d90d2212b introduced mwifiex_cmd_tdls_oper() which initializes
struct mwifiex_sta_node* sta_ptr, but does not use it. Compiling with W=1 gives
the following warning, fix it.
mwifiex/sta_cmd.c: In function ‘mwifiex_cmd_tdls_oper’:
mwifiex/sta_cmd.c:1732:27: warning: variable ‘sta_ptr’ set but not used [-Wunused-but-set-variable]

Fixes: 429d90d2212b ("mwifiex: add cfg80211 tdls_oper handler support")
Cc: Avinash Patil <patila@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index bcd6408..768c519 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1746,7 +1746,6 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_tdls_oper *tdls_oper = &cmd->params.tdls_oper;
 	struct mwifiex_ds_tdls_oper *oper = data_buf;
-	struct mwifiex_sta_node *sta_ptr;
 	struct host_cmd_tlv_rates *tlv_rates;
 	struct mwifiex_ie_types_htcap *ht_capab;
 	struct mwifiex_ie_types_qos_info *wmm_qos_info;
@@ -1764,7 +1763,6 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 
 	tdls_oper->reason = 0;
 	memcpy(tdls_oper->peer_mac, oper->peer_mac, ETH_ALEN);
-	sta_ptr = mwifiex_get_sta_entry(priv, oper->peer_mac);
 
 	pos = (u8 *)tdls_oper + sizeof(struct host_cmd_ds_tdls_oper);
 
-- 
2.8.0.rc3.226.g39d4020
