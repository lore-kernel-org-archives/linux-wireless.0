Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58766 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbcEQWa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 18:30:58 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] net: rsi: eliminate superfluous NULL check
Date: Wed, 18 May 2016 00:30:41 +0200
Message-Id: <1463524241-11351-1-git-send-email-xypron.glpk@gmx.de> (sfid-20160518_003124_144845_E19D33F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

msg is dereferenced before checking against NULL, e.g.
when assigning pad_bytes.
Remove the superfluous check in function rsi_mgmt_pkt_to_core.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 40658b6..35c14cc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -398,7 +398,7 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
 			return -ENOLINK;
 
 		msg_len -= pad_bytes;
-		if ((msg_len <= 0) || (!msg)) {
+		if (msg_len <= 0) {
 			rsi_dbg(MGMT_RX_ZONE,
 				"%s: Invalid rx msg of len = %d\n",
 				__func__, msg_len);
-- 
2.1.4

