Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34445 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbCXMm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:42:56 -0400
Received: by lbbsy1 with SMTP id sy1so139924768lbb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:42:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: don't call quiet mode if it's not implemented
Date: Tue, 24 Mar 2015 12:40:17 +0000
Message-Id: <1427200817-7407-1-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134300_183855_B766519D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca6174 and wmi-tlv doesn't have quiet mode
implemented. Don't even attempt to call it. This
fixes a warning when bringing first interface up:

  failed to set quiet mode period 100 duarion 0 enabled 0 ret -95

Fixes: 8515b5c79a54 ("ath10k: configure thermal throttle while powering up")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    (based on pending branch)

 drivers/net/wireless/ath/ath10k/thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 01bae867cae9..1a899d70dc5d 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -140,6 +140,9 @@ void ath10k_thermal_set_throttling(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (!ar->wmi.ops->gen_pdev_set_quiet_mode)
+		return;
+
 	if (ar->state != ATH10K_STATE_ON)
 		return;
 
-- 
2.1.4

