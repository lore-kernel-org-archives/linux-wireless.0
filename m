Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34832 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbbKRWxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 17:53:52 -0500
Received: by qkao63 with SMTP id o63so19980379qka.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2015 14:53:51 -0800 (PST)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH] ath6kl: Don't print error message when recv is canceled
Date: Wed, 18 Nov 2015 14:51:28 -0800
Message-Id: <1447887088-19018-1-git-send-email-steve.derosier@lairdtech.com> (sfid-20151118_235410_885558_393510F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An error message ath6kl_htc_rxmsg_pending_handler isn't appropate for when
the error is ECANCELED. This could be the result of a perfectly appropriate
RX cancel due to shutdown or suspend. This allows the right cleanup to
continue, but without an alarming error message in this particular case.

Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index fffb65b..65c31da 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -2222,8 +2222,9 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 	}
 
 	if (status) {
-		ath6kl_err("failed to get pending recv messages: %d\n",
-			   status);
+		if (status != -ECANCELED)
+			ath6kl_err("failed to get pending recv messages: %d\n",
+				   status);
 
 		/* cleanup any packets in sync completion queue */
 		list_for_each_entry_safe(packets, tmp_pkt, &comp_pktq, list) {
-- 
1.9.1

