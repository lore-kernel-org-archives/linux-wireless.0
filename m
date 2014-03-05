Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:43828 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbaCEMLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:21 -0500
Received: by mail-ea0-f175.google.com with SMTP id d10so972580eaj.20
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 04:11:20 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v2] ath10k: do not overwrite max_antenna_gain
Date: Wed,  5 Mar 2014 13:10:33 +0100
Message-Id: <1394021433-19376-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20140305_131125_631781_51E50586)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Puzyniak <marek.puzyniak@tieto.com>

Seems like we have an old bug, where we incidently overwrites
the max_antenna_gain we pass to firmware, with zero value.

End of all we are artifically reducing the output power.

This patch removes the excessive assignment on max_antenna_gain,
which is being provided by regulatory domain, and consequently
improves the tx power.

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

