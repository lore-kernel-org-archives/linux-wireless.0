Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15928 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbJTILE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:11:04 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: fix the bug on copying bssid
Date: Tue, 20 Oct 2015 17:10:46 +0900
Message-ID: <1445328646-32178-1-git-send-email-tony.cho@atmel.com> (sfid-20151020_101117_486219_D81C4AD0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reverts the commit, d79fd35b8c5d927695b48fa35aa586919818cce9.

The WID_JOIN_REQ_EXTENDED among WIDs needs two parameters for the request to
be sent to the firmware, which are the SA and the BSSID. For this case, both
is the same bssid in the handle_connect function. So, it's required to be
copied twice.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 646e7e9..4c7e1e4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1127,6 +1127,10 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->bssid, 6);
 	pu8CurrByte += 6;
 
+	if (pstrHostIFconnectAttr->bssid)
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->bssid, 6);
+	pu8CurrByte += 6;
+
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->beacon_period) >> 8) & 0xFF;
 	PRINT_D(HOSTINF_DBG, "* Beacon Period %d*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
-- 
1.9.1

