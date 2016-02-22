Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20043 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbcBVKRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:17:37 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V4 05/24] staging: wilc1000: removes potential null dereference
Date: Mon, 22 Feb 2016 19:14:12 +0900
Message-ID: <1456136071-10502-6-git-send-email-leo.kim@atmel.com> (sfid-20160222_111739_468382_38C101C9)
In-Reply-To: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
References: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
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
index 76f4375..8a3da2d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -668,6 +668,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				kmalloc_array(request->n_ssids,
 					      sizeof(struct hidden_network),
 					      GFP_KERNEL);
+			if (!strHiddenNetwork.net_info)
+				return -ENOMEM;
 			strHiddenNetwork.n_ssids = request->n_ssids;
 
 
-- 
1.9.1

