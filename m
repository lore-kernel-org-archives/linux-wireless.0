Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from que11.charter.net ([209.225.8.21]:47646 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1FCDR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 23:17:58 -0400
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 2/5] iwlegacy: remove unecessary if statement
Date: Thu,  2 Jun 2011 21:06:07 -0500
Message-Id: <1307066770-27309-2-git-send-email-Gregory.Dietsche@cuw.edu> (sfid-20110603_051808_039582_D78B21EB)
In-Reply-To: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the code always returns ret regardless, so if(ret) check is unecessary.
Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-4965.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index f5433c7..ffda05c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1185,8 +1185,6 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv,
 
 	ret = iwl_legacy_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
 				     sizeof(rxon_assoc), &rxon_assoc, NULL);
-	if (ret)
-		return ret;
 
 	return ret;
 }
-- 
1.7.2.5

