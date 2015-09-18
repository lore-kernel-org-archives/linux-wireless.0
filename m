Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60618 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbbIRNdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:01 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	<stable@vger.kernel.org>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 07/16] mwifiex: fix NULL pointer dereference during hidden SSID scan
Date: Fri, 18 Sep 2015 06:32:09 -0700
Message-ID: <1442583138-2979-8-git-send-email-akarwar@marvell.com> (sfid-20150918_153306_932032_87E38F59)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aniket Nagarnaik <aniketn@marvell.com>

This NULL pointer dereference is observed during suspend resume
stress test. All pending commands are cancelled when system goes
into suspend state. There a corner case in which host may receive
response for last scan command after this and try to trigger extra
active scan for hidden SSIDs.

The issue is fixed by adding a NULL check to skip that extra scan.

Fixes: 2375fa2b36feaf34 (mwifiex: fix unable to connect hidden SSID..)
Cc: <stable@vger.kernel.org> [v4.2+]
Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 3675730..c20017c 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1893,7 +1893,7 @@ mwifiex_active_scan_req_for_passive_chan(struct mwifiex_private *priv)
 	u8 id = 0;
 	struct mwifiex_user_scan_cfg  *user_scan_cfg;
 
-	if (adapter->active_scan_triggered) {
+	if (adapter->active_scan_triggered || !priv->scan_request) {
 		adapter->active_scan_triggered = false;
 		return 0;
 	}
-- 
1.8.1.4

