Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44471 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab2DKA4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 20:56:39 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: trivial@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/11] prism54: replace open-coded ARRAY_SIZE with macro
Date: Tue, 10 Apr 2012 18:56:34 -0600
Message-Id: <1334105794-9325-1-git-send-email-jim.cromie@gmail.com> (sfid-20120411_025643_508436_5E951A18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/net/wireless/prism54/oid_mgt.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/prism54/oid_mgt.c b/drivers/net/wireless/prism54/oid_mgt.c
index 9b796ca..a01606b 100644
--- a/drivers/net/wireless/prism54/oid_mgt.c
+++ b/drivers/net/wireless/prism54/oid_mgt.c
@@ -693,8 +693,6 @@ mgt_update_addr(islpci_private *priv)
 	return ret;
 }
 
-#define VEC_SIZE(a) ARRAY_SIZE(a)
-
 int
 mgt_commit(islpci_private *priv)
 {
@@ -704,10 +702,10 @@ mgt_commit(islpci_private *priv)
 	if (islpci_get_state(priv) < PRV_STATE_INIT)
 		return 0;
 
-	rvalue = mgt_commit_list(priv, commit_part1, VEC_SIZE(commit_part1));
+	rvalue = mgt_commit_list(priv, commit_part1, ARRAY_SIZE(commit_part1));
 
 	if (priv->iw_mode != IW_MODE_MONITOR)
-		rvalue |= mgt_commit_list(priv, commit_part2, VEC_SIZE(commit_part2));
+		rvalue |= mgt_commit_list(priv, commit_part2, ARRAY_SIZE(commit_part2));
 
 	u = OID_INL_MODE;
 	rvalue |= mgt_commit_list(priv, &u, 1);
-- 
1.7.8.1

