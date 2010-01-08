Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58357 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0AHR2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:28:15 -0500
Date: Fri, 8 Jan 2010 18:28:14 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] mwl8k: undo transmit queue 0/1 swapping in mwl8k_cmd_set_edca_params()
Message-ID: <20100108172814.GV1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comment and code in mwl8k_cmd_set_edca_params() suggest that the
mapping between SET_EDCA_PARAMS queue numbers and transmit rings isn't
actually 1:1, while tests show that the mapping is in fact 1:1.  So,
get rid of the transmit queue 0/1 swapping.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cc16041..3f5fdb6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2397,12 +2397,6 @@ mwl8k_cmd_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	/*
-	 * Queues 0 (BE) and 1 (BK) are swapped in hardware for
-	 * this call.
-	 */
-	qnum ^= !(qnum >> 1);
-
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_EDCA_PARAMS);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(MWL8K_SET_EDCA_ALL);
-- 
1.5.6.4
