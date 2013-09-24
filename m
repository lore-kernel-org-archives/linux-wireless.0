Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:64900 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3IXMGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 08:06:44 -0400
Received: by mail-ea0-f169.google.com with SMTP id k11so2449445eaj.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Sep 2013 05:06:43 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath10k: make monitor vdev down before stoping it
Date: Tue, 24 Sep 2013 14:06:24 +0200
Message-Id: <1380024384-30512-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20130924_140648_315405_08AC578A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following sequence causes FW crash:
-monitor vdev up,
-monitor vdev stop,
-monitor vdev delete.
Making monitor vdev down before stoping it works ok:
-monitor vdev up,
-monitor vdev down,
-monitor vdev stop,
-monitor vdev delete.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 51988d9..24b94c8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -567,12 +567,9 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	/* For some reasons, ath10k_wmi_vdev_down() here couse
-	 * often ath10k_wmi_vdev_stop() to fail. Next we could
-	 * not run monitor vdev and driver reload
-	 * required. Don't see such problems we skip
-	 * ath10k_wmi_vdev_down() here.
-	 */
+	ret = ath10k_wmi_vdev_down(ar, ar->monitor_vdev_id);
+	if (ret)
+		ath10k_warn("Monitor vdev down failed: %d\n", ret);
 
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-- 
1.8.1.2

