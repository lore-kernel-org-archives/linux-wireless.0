Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F82C10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 10:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F20F2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 10:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfC0KEZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 06:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfC0KEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 06:04:25 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDD8120265;
        Wed, 27 Mar 2019 10:04:24 +0000 (UTC)
Received: from localhost (unknown [10.40.205.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 506281949F;
        Wed, 27 Mar 2019 10:04:24 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Vijayakumar Durai <vijayakumar.durai1@vivint.com>,
        stable@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5.1] rt2x00: do not increment sequence number while re-transmitting
Date:   Wed, 27 Mar 2019 11:03:17 +0100
Message-Id: <1553680997-19511-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 27 Mar 2019 10:04:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Vijayakumar Durai <vijayakumar.durai1@vivint.com>

Currently rt2x00 devices retransmit the management frames with
incremented sequence number if hardware is assigning the sequence.

This is HW bug fixed already for non-QOS data frames, but it should
be fixed for management frames except beacon.

Without fix retransmitted frames have wrong SN:

 AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1648, FN=0, Flags=........C Frame is not being retransmitted 1648 1
 AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1649, FN=0, Flags=....R...C Frame is being retransmitted 1649 1
 AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1650, FN=0, Flags=....R...C Frame is being retransmitted 1650 1

With the fix SN stays correctly the same:

 88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=........C
 88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=....R...C
 88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=....R...C

Cc: stable@vger.kernel.org
Signed-off-by: Vijayakumar Durai <vijayakumar.durai1@vivint.com>
[sgruszka: simplify code, change comments and changelog]
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |  1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c   | 10 ----------
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 15 +++++++++------
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 4b1744e9fb78..50b92ca92bd7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -673,7 +673,6 @@ enum rt2x00_state_flags {
 	CONFIG_CHANNEL_HT40,
 	CONFIG_POWERSAVING,
 	CONFIG_HT_DISABLED,
-	CONFIG_QOS_DISABLED,
 	CONFIG_MONITORING,
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index 2825560e2424..e8462f25d252 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -642,19 +642,9 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 			rt2x00dev->intf_associated--;
 
 		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
-
-		clear_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
 	}
 
 	/*
-	 * Check for access point which do not support 802.11e . We have to
-	 * generate data frames sequence number in S/W for such AP, because
-	 * of H/W bug.
-	 */
-	if (changes & BSS_CHANGED_QOS && !bss_conf->qos)
-		set_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
-
-	/*
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 92ddc19e7bf7..4834b4eb0206 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -201,15 +201,18 @@ static void rt2x00queue_create_tx_descriptor_seq(struct rt2x00_dev *rt2x00dev,
 	if (!rt2x00_has_cap_flag(rt2x00dev, REQUIRE_SW_SEQNO)) {
 		/*
 		 * rt2800 has a H/W (or F/W) bug, device incorrectly increase
-		 * seqno on retransmited data (non-QOS) frames. To workaround
-		 * the problem let's generate seqno in software if QOS is
-		 * disabled.
+		 * seqno on retransmitted data (non-QOS) and management frames.
+		 * To workaround the problem let's generate seqno in software.
+		 * Except for beacons which are transmitted periodically by H/W
+		 * hence hardware has to assign seqno for them.
 		 */
-		if (test_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags))
-			__clear_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
-		else
+	    	if (ieee80211_is_beacon(hdr->frame_control)) {
+			__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
 			/* H/W will generate sequence number */
 			return;
+		}
+
+		__clear_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
 	}
 
 	/*
-- 
2.7.5

