Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38554 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752786AbcJ0JNS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 05:13:18 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 1/5] mwifiex: remove redundant condition in main process
Date: Thu, 27 Oct 2016 14:42:39 +0530
Message-ID: <1477559563-18328-1-git-send-email-akarwar@marvell.com> (sfid-20161027_111348_075670_8238A08D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This condition while calling mwifiex_check_ps_cond() is redundant.
The function internally already takes care of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Same as v1
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
