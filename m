Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58844 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaIJNfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:32 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/22] wil6210: modify confusing printout
Date: Wed, 10 Sep 2014 16:34:41 +0300
Message-ID: <1410356091-19219-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153539_254065_490F8F4C)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

When WMI event received when driver not ready to accept it, the printed error
message is misleading and hints that HW is stuck. Modify the error message
to make it clearer

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c71657b..ad48f14 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -660,7 +660,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 	unsigned n;
 
 	if (!test_bit(wil_status_reset_done, &wil->status)) {
-		wil_err(wil, "Reset not completed\n");
+		wil_err(wil, "Reset in progress. Cannot handle WMI event\n");
 		return;
 	}
 
-- 
1.9.1

