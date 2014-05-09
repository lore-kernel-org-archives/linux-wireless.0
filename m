Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45211 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaEIMm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:42:59 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so2639578eek.6
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:42:58 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/7] ath10k: make wmi timeout trigger hw restart
Date: Fri,  9 May 2014 14:35:56 +0200
Message-Id: <1399638957-20449-7-git-send-email-michal.kazior@tieto.com> (sfid-20140509_144309_715231_16471D8B)
In-Reply-To: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If tx credits aren't replenished for too long
firmware and driver state get out of sync. It
doesn't matter if firmware recovers a little later
on its own since by then it's already too late.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 159d744..e33c811 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -634,6 +634,11 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 	if (ret)
 		dev_kfree_skb_any(skb);
 
+	if (ret == -EAGAIN) {
+		/* no credits for 3 seconds means fw is practically dead */
+		ath10k_core_restart(ar);
+	}
+
 	return ret;
 }
 
-- 
1.8.5.3

