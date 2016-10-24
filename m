Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S938751AbcJXOWU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:22:20 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <dmitry.torokhov@gmail.com>, <briannorris@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/5] mwifiex: remove redundant condition in main process
Date: Mon, 24 Oct 2016 19:51:28 +0530
Message-ID: <1477318892-22877-1-git-send-email-akarwar@marvell.com> (sfid-20161024_162223_985147_39D88564)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This condition while calling mwifiex_check_ps_cond() is redundant.
The function internally already takes care of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2478ccd..3b31ea2 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -355,10 +355,8 @@ process_start:
 
 		/* Check if we need to confirm Sleep Request
 		   received previously */
-		if (adapter->ps_state == PS_STATE_PRE_SLEEP) {
-			if (!adapter->cmd_sent && !adapter->curr_cmd)
-				mwifiex_check_ps_cond(adapter);
-		}
+		if (adapter->ps_state == PS_STATE_PRE_SLEEP)
+			mwifiex_check_ps_cond(adapter);
 
 		/* * The ps_state may have been changed during processing of
 		 * Sleep Request event.
-- 
1.9.1
