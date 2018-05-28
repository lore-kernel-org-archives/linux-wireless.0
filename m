Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1424585AbeE1LZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 07:25:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D31D818BAFE
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 11:25:08 +0000 (UTC)
Received: from localhost (unknown [10.40.205.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F39F22166BB2
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 11:25:07 +0000 (UTC)
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Revert "rt2800: use TXOP_BACKOFF for probe frames"
Date: Mon, 28 May 2018 13:25:06 +0200
Message-Id: <1527506706-6488-1-git-send-email-sgruszka@redhat.com> (sfid-20180528_132550_602489_191D3A12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit fb47ada8dc3c30c8e7b415da155742b49536c61e.

In some situations when we set TXOP_BACKOFF, the probe frame is
not sent at all. What it worse then sending probe frame as part
of AMPDU and can degrade 11n performance to 11g rates.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index a6884e73d2ab..7ddee980048b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -372,16 +372,15 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * Determine IFS values
-	 * - Use TXOP_BACKOFF for probe and management frames except beacons
+	 * - Use TXOP_BACKOFF for management frames except beacons
 	 * - Use TXOP_SIFS for fragment bursts
 	 * - Use TXOP_HTTXOP for everything else
 	 *
 	 * Note: rt2800 devices won't use CTS protection (if used)
 	 * for frames not transmitted with TXOP_HTTXOP
 	 */
-	if ((ieee80211_is_mgmt(hdr->frame_control) &&
-	     !ieee80211_is_beacon(hdr->frame_control)) ||
-	    (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
+	if (ieee80211_is_mgmt(hdr->frame_control) &&
+	    !ieee80211_is_beacon(hdr->frame_control))
 		txdesc->u.ht.txop = TXOP_BACKOFF;
 	else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
 		txdesc->u.ht.txop = TXOP_SIFS;
-- 
2.7.5
