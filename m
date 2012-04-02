Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2DBLWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 07:22:18 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] rt2x00: do not generate seqno in h/w if QOS is disabled
Date: Mon,  2 Apr 2012 13:21:06 +0200
Message-Id: <1333365666-4413-2-git-send-email-sgruszka@redhat.com> (sfid-20120402_132225_438022_67A7E44F)
In-Reply-To: <1333365666-4413-1-git-send-email-sgruszka@redhat.com>
References: <1333365666-4413-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is workaround H/W or F/W bug, see in code comments. Without the fix
ping can receive duplicated ICMP frames while associated with legacy AP.

Reported-by: Walter Goldens <goldenstranger@yahoo.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    1 +
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   10 ++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |   15 +++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8de9bfc..5583214 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -693,6 +693,7 @@ enum rt2x00_state_flags {
 	CONFIG_CHANNEL_HT40,
 	CONFIG_POWERSAVING,
 	CONFIG_HT_DISABLED,
+	CONFIG_QOS_DISABLED,
 
 	/*
 	 * Mark we currently are sequentially reading TX_STA_FIFO register
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2df2eb6..b49773e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -709,9 +709,19 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 			rt2x00dev->intf_associated--;
 
 		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
+
+		clear_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
 	}
 
 	/*
+	 * Check for access point which do not support 802.11e . We have to
+	 * generate data frames sequence number in S/W for such AP, because
+	 * of H/W bug.
+	 */
+	if (changes & BSS_CHANGED_QOS && !bss_conf->qos)
+		set_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
+
+	/*
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f7403cf..5019a3e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -213,8 +213,19 @@ static void rt2x00queue_create_tx_descriptor_seq(struct rt2x00_dev *rt2x00dev,
 
 	__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
 
-	if (!test_bit(REQUIRE_SW_SEQNO, &rt2x00dev->cap_flags))
-		return;
+	if (!test_bit(REQUIRE_SW_SEQNO, &rt2x00dev->cap_flags)) {
+		/*
+		 * rt2800 has a H/W (or F/W) bug, device incorrectly increase
+		 * seqno on retransmited data (non-QOS) frames. To workaround
+		 * the problem let's generate seqno in software if QOS is
+		 * disabled.
+		 */
+		if (test_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags))
+			__clear_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
+		else
+			/* H/W will generate sequence number */
+			return;
+	}
 
 	/*
 	 * The hardware is not able to insert a sequence number. Assign a
-- 
1.7.1

