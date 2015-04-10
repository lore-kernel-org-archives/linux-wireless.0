Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33343 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475AbbDJNao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 09:30:44 -0400
Received: by lbbzk7 with SMTP id zk7so13756911lbb.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 06:30:42 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] ath10k: don't use reassoc flag
Date: Fri, 10 Apr 2015 13:23:20 +0000
Message-Id: <1428672203-8604-2-git-send-email-michal.kazior@tieto.com> (sfid-20150410_153053_190729_662BB9C7)
In-Reply-To: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com>
References: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware actually re-creates peer entry when
reassoc flag is set. This is undesired and could
cause trouble with IBSS crypto-wise. This is also
important for upcomming bitrate mask improvement.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a7a84f52b8b4..6664bcc9ba88 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2593,7 +2593,6 @@ static int ath10k_station_assoc(struct ath10k *ar,
 		return ret;
 	}
 
-	peer_arg.peer_reassoc = reassoc;
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to run peer assoc for STA %pM vdev %i: %d\n",
-- 
2.1.4

