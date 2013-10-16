Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:42544 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:45:49 -0400
Subject: [PATCH v2 2/8] ath10k: add sanity checks for monitor management
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:45:48 +0300
Message-ID: <20131016134548.25095.6014.stgit@localhost6.localdomain6> (sfid-20131016_154552_067251_5408C3A5)
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Add a few checks and warnings to make it easier to
track any kind of monitor vdev mismanagement.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 527343d..da23c3f 100644
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

