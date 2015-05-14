Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:34448 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbbENLtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 07:49:40 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] wil6210: match wait_for_completion_timeout return type
Date: Thu, 14 May 2015 13:41:26 +0200
Message-Id: <1431603686-24029-1-git-send-email-hofrat@osadl.org> (sfid-20150514_134945_210200_6FFF5D2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return type of wait_for_completion_timeout is unsigned long not int.
As remain is exclusively used for wait_for_completion_timeout here its
type is simply changed to unsigned long.


API conformance testing for completions with coccinelle spatches are being
used to locate API usage inconsistencies:
./drivers/net/wireless/ath/wil6210/wmi.c:827 
	int return assigned to unsigned long

Patch was compile tested with x86_64_defconfig + CONFIG_ATH_CARDS=m,
CONFIG_WIL6210=m

Patch is against 4.1-rc3 (localversion-next is -next-20150514)


Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 9fe2085..e8d5335 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -805,7 +805,7 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 	     u16 reply_id, void *reply, u8 reply_size, int to_msec)
 {
 	int rc;
-	int remain;
+	unsigned long remain;
 
 	mutex_lock(&wil->wmi_mutex);
 
-- 
1.7.10.4

