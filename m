Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52551 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdFBI4n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 04:56:43 -0400
From: Colin King <colin.king@canonical.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][-next] mwifiex: make function mwifiex_ret_pkt_aggr_ctrl static
Date: Fri,  2 Jun 2017 09:56:39 +0100
Message-Id: <20170602085639.29338-1-colin.king@canonical.com> (sfid-20170602_105715_148736_FC2247DD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

function mwifiex_ret_pkt_aggr_ctrl can be made static as it does not
need to be in global scope.

Cleans up sparse warning: "symbol 'mwifiex_ret_pkt_aggr_ctrl' was not
declared. Should it be static?"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 3348fb3a7514..2945775e83c5 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -1154,8 +1154,8 @@ static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
 	return 0;
 }
 
-int mwifiex_ret_pkt_aggr_ctrl(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp)
+static int mwifiex_ret_pkt_aggr_ctrl(struct mwifiex_private *priv,
+				     struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_pkt_aggr_ctrl *pkt_aggr_ctrl =
 					&resp->params.pkt_aggr_ctrl;
-- 
2.11.0
