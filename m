Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59210 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JORca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:30 -0400
Received: by mail-pd0-f169.google.com with SMTP id r10so9193550pdi.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/7] ath10k: add sanity checks for monitor management
Date: Tue, 15 Oct 2013 10:29:51 -0700
Message-Id: <1381858196-17000-3-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193234_127211_FB77FB31)
In-Reply-To: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a few checks and warnings to make it easier to
track any kind of monitor vdev mismanagement.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9f26fcf..1878e8f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -516,6 +516,11 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (!ar->monitor_present) {
+		ath10k_warn("mac montor stop -- monitor is not present\n");
+		return -EINVAL;
+	}
+
 	arg.vdev_id = vdev_id;
 	arg.channel.freq = channel->center_freq;
 	arg.channel.band_center_freq1 = ar->hw->conf.chandef.center_freq1;
@@ -566,6 +571,16 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (!ar->monitor_present) {
+		ath10k_warn("mac montor stop -- monitor is not present\n");
+		return -EINVAL;
+	}
+
+	if (!ar->monitor_enabled) {
+		ath10k_warn("mac montor stop -- monitor is not enabled\n");
+		return -EINVAL;
+	}
+
 	ret = ath10k_wmi_vdev_down(ar, ar->monitor_vdev_id);
 	if (ret)
 		ath10k_warn("Monitor vdev down failed: %d\n", ret);
-- 
1.8.4.rc3

