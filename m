Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:35959 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3CJFvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 00:51:36 -0500
Subject: [PATCH 1/2] ath6kl: add an extra band check to
 ath6kl_wmi_beginscan_cmd()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sun, 10 Mar 2013 07:51:29 +0200
Message-ID: <20130310055129.18916.96742.stgit@localhost6.localdomain6> (sfid-20130310_065146_700352_7EE39ED8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan reported that smatch found a possible issue in ath6kl_wmi_beginscan_cmd()
where we might access sc->supp_rates beyond the end. It shouldn't happen as
ar->wiphy->bands always have just the first two bands set, but add an extra
check just to be sure.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 31a3081..87aefb4 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2029,6 +2029,9 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 		if (!sband)
 			continue;
 
+		if (WARN_ON(band >= ATH6KL_NUM_BANDS))
+			break;
+
 		ratemask = rates[band];
 		supp_rates = sc->supp_rates[band].rates;
 		num_rates = 0;

