Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56304 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbaIAHak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:30:40 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 01/17] mwifiex: fix probable memory corruption while processing TDLS frame
Date: Mon, 1 Sep 2014 18:28:49 +0530
Message-ID: <1409576345-13717-2-git-send-email-patila@marvell.com> (sfid-20140901_093042_982096_CB1B0932)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Size of RSN IE buffer in driver is 254 while maximum size of received buffer
to be copied to RSN IE buffer can be 255. Add boundary check to copy maximum
of 254 bytes into RSN IE buffer.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/tdls.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 4c5fd95..e294907 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -871,7 +871,9 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 			break;
 		case WLAN_EID_RSN:
 			memcpy((u8 *)&sta_ptr->tdls_cap.rsn_ie, pos,
-			       sizeof(struct ieee_types_header) + pos[1]);
+			       sizeof(struct ieee_types_header) +
+			       min_t(u8, pos[1], IEEE_MAX_IE_SIZE -
+				     sizeof(struct ieee_types_header)));
 			break;
 		case WLAN_EID_QOS_CAPA:
 			sta_ptr->tdls_cap.qos_info = pos[2];
-- 
1.8.1.4

