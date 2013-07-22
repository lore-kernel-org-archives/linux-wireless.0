Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43240 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3GVMNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:13:47 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/4] ath10k: don't reset HTC endpoints unnecessarily
Date: Mon, 22 Jul 2013 14:13:29 +0200
Message-ID: <1374495211-20353-3-git-send-email-michal.kazior@tieto.com> (sfid-20130722_141351_131971_35A5335D)
In-Reply-To: <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
 <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Endpoints are re-initialized upon HTC start anyway
so there's no need to do that twice in case of
restarting HTC (i.e. in case of hardware
recovery).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 47b7752..ef3329e 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -958,7 +958,6 @@ void ath10k_htc_stop(struct ath10k_htc *htc)
 	}
 
 	ath10k_hif_stop(htc->ar);
-	ath10k_htc_reset_endpoint_states(htc);
 }
 
 /* registered target arrival callback from the HIF layer */
-- 
1.7.9.5

