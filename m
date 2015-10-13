Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2757 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbbJMKwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:09 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/54] staging: wilc1000: remove duplicate null check routine
Date: Tue, 13 Oct 2015 19:49:39 +0900
Message-ID: <1444733419-17679-14-git-send-email-tony.cho@atmel.com> (sfid-20151013_125213_309883_6A93A2F8)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the duplicate null check routine. The same null check
routine is twice executed. Therefore the duplicated routine is not necessary.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b7eb272..1e2a4ec 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -957,11 +957,6 @@ ERRORHANDLER:
 		pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo = NULL;
 	}
 
-	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL) {
-		kfree(pstrHostIFscanAttr->pu8ChnlFreqList);
-		pstrHostIFscanAttr->pu8ChnlFreqList = NULL;
-	}
-
 	if (pu8HdnNtwrksWidVal != NULL)
 		kfree(pu8HdnNtwrksWidVal);
 
-- 
1.9.1

