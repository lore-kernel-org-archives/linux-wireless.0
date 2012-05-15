Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:54872 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339Ab2EOGEr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 02:04:47 -0400
From: Soumik DAS <soumik.das@stericsson.com>
To: "John Linville (linville@tuxdriver.com)" <linville@tuxdriver.com>
Cc: "linux-wireless (linux-wireless@vger.kernel.org)"
	<linux-wireless@vger.kernel.org>,
	"Johannes Berg (johannes@sipsolutions.net)"
	<johannes@sipsolutions.net>,
	"Kalle Valo (kvalo@adurom.com)" <kvalo@adurom.com>
Date: Tue, 15 May 2012 08:04:32 +0200
Subject: [PATCH] mac80211: Remove race condition in sending null frame to
 check AP status
Message-ID: <2E48302EED53D048A7BA72B0A307FB511FB906BC9A@EXDCVYMBSTM005.EQ1STM.local> (sfid-20120515_080451_370994_6627F936)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 tries to verify the existence of the current AP by
probing or sending a NULL frame in function
ieee80211_mgd_probe_ap_send. It 1st sends a null frame to the AP,
increments probe_send_count and waits for the ACK to the NULL
frame for a finite duration of time. At times, it happens that
by the time mac80211 gets to increment probe_send_count, the ACK
for the NULL frame transmitted has already been processed. This
leads to a race condition where mac80211 times out waiting for
the ACK for the NULL frame causing unnecessary disconnection with
the AP.

Signed-off-by: Soumik Das <soumik.das@stericsson.com>
---
net/mac80211/mlme.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c index dbd4bd9..a1213e4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1522,6 +1522,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
    * anymore. The timeout will be reset if the frame is ACKed by
    * the AP.
    */
+    ifmgd->probe_send_count++;
    if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
        ifmgd->nullfunc_failed = false;
        ieee80211_send_nullfunc(sdata->local, sdata, 0); @@ -1538,7 +1539,6 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
                    0, (u32) -1, true, false);
    }

-    ifmgd->probe_send_count++;
    ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
    run_again(ifmgd, ifmgd->probe_timeout);
    if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
--
1.7.5.4
