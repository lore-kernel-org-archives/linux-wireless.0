Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50230 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156AbaCDL6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 06:58:54 -0500
Received: by mail-ea0-f181.google.com with SMTP id k10so304702eaj.12
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 03:58:52 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: do not overwrite max_antenna_gain
Date: Tue,  4 Mar 2014 12:58:31 +0100
Message-Id: <1393934311-26154-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20140304_125908_732175_D4C0974F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Puzyniak <marek.puzyniak@tieto.com>

Seems like there's an old bug where we overwrite the
antenna_gain with zero value.

This patch removes the excessive assignment of max_antenna_gain,
which should be provided by regulatory domain settings.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 478e7f6..cb1f7b5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3393,7 +3393,6 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 		ci->max_power         = ch->max_power;
 		ci->reg_power         = ch->max_reg_power;
 		ci->antenna_max       = ch->max_antenna_gain;
-		ci->antenna_max       = 0;
 
 		/* mode & flags share storage */
 		ci->mode              = ch->mode;
-- 
1.7.10

