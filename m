Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61194 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbcHBLn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:43:56 -0400
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 6/8] wil6210: Fix driver down flow
Date: Tue,  2 Aug 2016 14:42:10 +0300
Message-Id: <1470138132-18071-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_194930_975522_64220B40)
In-Reply-To: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>

Stations disconnection is executed as part of wil_reset so no
need to do it in wil_down.
Removal of the disconnect operation will also preserve the lock
of wil->mutex during the whole reset flow and prevent handling of
connect event while resetting.
Set wil_status_resetting in earlier stage in the flow to prevent
double resetting call in case communication with FW fails while
bringing the interface down.

Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index bbc54ee..dd0ee7f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1035,10 +1035,10 @@ int wil_up(struct wil6210_priv *wil)
 
 int __wil_down(struct wil6210_priv *wil)
 {
-	int rc;
-
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
+	set_bit(wil_status_resetting, wil->status);
+
 	if (wil->platform_ops.bus_request)
 		wil->platform_ops.bus_request(wil->platform_handle, 0);
 
@@ -1064,18 +1064,6 @@ int __wil_down(struct wil6210_priv *wil)
 		wil->scan_request = NULL;
 	}
 
-	if (test_bit(wil_status_fwconnected, wil->status) ||
-	    test_bit(wil_status_fwconnecting, wil->status)) {
-
-		mutex_unlock(&wil->mutex);
-		rc = wmi_call(wil, WMI_DISCONNECT_CMDID, NULL, 0,
-			      WMI_DISCONNECT_EVENTID, NULL, 0,
-			      WIL6210_DISCONNECT_TO_MS);
-		mutex_lock(&wil->mutex);
-		if (rc)
-			wil_err(wil, "timeout waiting for disconnect\n");
-	}
-
 	wil_reset(wil, false);
 
 	return 0;
-- 
1.9.1

