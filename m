Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18415 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbbLDNQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 08:16:55 -0500
Date: Fri, 4 Dec 2015 16:16:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] iwlegacy: cleanup end of il_send_add_sta()
Message-ID: <20151204131645.GC12792@mwanda> (sfid-20151204_141700_021770_FFDE88E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code causes a static checker warning because we check for
"if (ret == 0)" but we have already had verified that was true.  Clean
it up a little.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I have preserved the original behavior but it's possible that the
original code was buggy.  Please review.

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 8871145..e49bad2 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -1865,14 +1865,14 @@ il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags)
 
 	cmd.len = il->ops->build_addsta_hcmd(sta, data);
 	ret = il_send_cmd(il, &cmd);
-
-	if (ret || (flags & CMD_ASYNC))
+	if (ret)
 		return ret;
+	if (flags & CMD_ASYNC)
+		return 0;
+
+	pkt = (struct il_rx_pkt *)cmd.reply_page;
+	ret = il_process_add_sta_resp(il, sta, pkt, true);
 
-	if (ret == 0) {
-		pkt = (struct il_rx_pkt *)cmd.reply_page;
-		ret = il_process_add_sta_resp(il, sta, pkt, true);
-	}
 	il_free_pages(il, cmd.reply_page);
 
 	return ret;
