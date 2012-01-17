Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab2AQLjP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 06:39:15 -0500
Date: Tue, 17 Jan 2012 12:38:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Patrick <ragamuffin@datacomm.ch>
Subject: [PATCH] brcmsmac: fix tx queue flush infinite loop
Message-ID: <20120117113849.GB3091@redhat.com> (sfid-20120117_123919_046996_5DFA2C42)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch workaround live deadlock problem caused by infinite loop
in brcms_c_wait_for_tx_completion(). I do not consider the patch as
the proper fix, which should fix the real reason of tx queue flush
failure, but patch helps with system lockup.

Reference:
https://bugzilla.kernel.org/show_bug.cgi?id=42576

Reported-and-tested-by: Patrick <ragamuffin@datacomm.ch>
Cc: stable@vger.kernel.org # 3.2+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f7ed340..f6affc6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7981,13 +7981,21 @@ int brcms_c_get_curband(struct brcms_c_info *wlc)
 
 void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 {
+	int timeout = 20;
+
 	/* flush packet queue when requested */
 	if (drop)
 		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
 
 	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0)
+	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0) {
 		brcms_msleep(wlc->wl, 1);
+
+		if (--timeout == 0)
+			break;
+	}
+
+	WARN_ON_ONCE(timeout == 0);
 }
 
 void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
-- 
1.7.1

