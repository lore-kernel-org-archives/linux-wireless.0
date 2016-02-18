Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:29890 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425363AbcBRLdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 06:33:22 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 05/24] staging: wilc1000: removes potential null dereference
Date: Thu, 18 Feb 2016 20:30:05 +0900
Message-ID: <1455795024-26978-5-git-send-email-leo.kim@atmel.com> (sfid-20160218_123343_603615_29529685)
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the error reported by smatch.
 - wilc_wfi_cfgoperations.c:674 scan() error:
   potential null dereference 'strHiddenNetwork.net_info'.  (kmalloc returns null)

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d4705b7..a71c01d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -665,6 +665,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 		if (request->n_ssids >= 1) {
 			strHiddenNetwork.net_info = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
+			if (!strHiddenNetwork.net_info)
+				return -ENOMEM;
 			strHiddenNetwork.n_ssids = request->n_ssids;
 
 
-- 
1.9.1

