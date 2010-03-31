Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35144 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab0CaOIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 10:08:25 -0400
Received: by bwz1 with SMTP id 1so100619bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 07:08:23 -0700 (PDT)
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com, jal2@gmx.de,
	johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luis de Bethencourt <luisbg@dharma.ireland.sun.com>,
	Luis de Bethencourt <luisbg@ubuntu.com>
Subject: [PATCH 3/3] ath: fix coding style/readability in ath/ar9170
Date: Wed, 31 Mar 2010 15:07:48 +0100
Message-Id: <1270044468-28486-1-git-send-email-luisbg@ubuntu.com>
In-Reply-To: <ath/9170/>
References: <ath/9170/>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis de Bethencourt <luisbg@dharma.ireland.sun.com>

This is a patch to files in ath/ar9170 that fixes a set of warnings
found by checkpatch.pl tool. A line over 80 characters, a few empty
spaces before tab and a few empty characters before a new line.

Signed-off-by: Luis de Bethencourt <luisbg@ubuntu.com>
---
 drivers/net/wireless/ath/ar9170/cmd.h    |    2 +-
 drivers/net/wireless/ath/ar9170/eeprom.h |    4 ++--
 drivers/net/wireless/ath/ar9170/main.c   |   11 ++++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/cmd.h b/drivers/net/wireless/ath/ar9170/cmd.h
index 826c45e..ec8134b 100644
--- a/drivers/net/wireless/ath/ar9170/cmd.h
+++ b/drivers/net/wireless/ath/ar9170/cmd.h
@@ -79,7 +79,7 @@ __regwrite_out :							\
 	if (__nreg) {							\
 		if (IS_ACCEPTING_CMD(__ar))				\
 			__err = ar->exec_cmd(__ar, AR9170_CMD_WREG,	\
-					     8 * __nreg, 		\
+					     8 * __nreg,		\
 					     (u8 *) &__ar->cmdbuf[1],	\
 					     0, NULL);			\
 		__nreg = 0;						\
diff --git a/drivers/net/wireless/ath/ar9170/eeprom.h b/drivers/net/wireless/ath/ar9170/eeprom.h
index d2c8cc8..6c46638 100644
--- a/drivers/net/wireless/ath/ar9170/eeprom.h
+++ b/drivers/net/wireless/ath/ar9170/eeprom.h
@@ -127,8 +127,8 @@ struct ar9170_eeprom {
 	__le16	checksum;
 	__le16	version;
 	u8	operating_flags;
-#define AR9170_OPFLAG_5GHZ 		1
-#define AR9170_OPFLAG_2GHZ 		2
+#define AR9170_OPFLAG_5GHZ		1
+#define AR9170_OPFLAG_2GHZ		2
 	u8	misc;
 	__le16	reg_domain[2];
 	u8	mac_address[6];
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 257c734..3de4592 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -235,7 +235,7 @@ static void __ar9170_dump_txqueue(struct ar9170 *ar,
 	       wiphy_name(ar->hw->wiphy), skb_queue_len(queue));
 
 	skb_queue_walk(queue, skb) {
-		printk(KERN_DEBUG "index:%d => \n", i++);
+		printk(KERN_DEBUG "index:%d =>\n", i++);
 		ar9170_print_txheader(ar, skb);
 	}
 	if (i != skb_queue_len(queue))
@@ -280,7 +280,7 @@ static void ar9170_dump_tx_status_ampdu(struct ar9170 *ar)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ar->tx_status_ampdu.lock, flags);
-	printk(KERN_DEBUG "%s: A-MPDU tx_status queue => \n",
+	printk(KERN_DEBUG "%s: A-MPDU tx_status queue =>\n",
 	       wiphy_name(ar->hw->wiphy));
 	__ar9170_dump_txqueue(ar, &ar->tx_status_ampdu);
 	spin_unlock_irqrestore(&ar->tx_status_ampdu.lock, flags);
@@ -307,7 +307,7 @@ static void ar9170_recycle_expired(struct ar9170 *ar,
 		if (time_is_before_jiffies(arinfo->timeout)) {
 #ifdef AR9170_QUEUE_DEBUG
 			printk(KERN_DEBUG "%s: [%ld > %ld] frame expired => "
-			       "recycle \n", wiphy_name(ar->hw->wiphy),
+			       "recycle\n", wiphy_name(ar->hw->wiphy),
 			       jiffies, arinfo->timeout);
 			ar9170_print_txheader(ar, skb);
 #endif /* AR9170_QUEUE_DEBUG */
@@ -688,7 +688,8 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 
 	/* firmware debug */
 	case 0xca:
-		printk(KERN_DEBUG "ar9170 FW: %.*s\n", len - 4, (char *)buf + 4);
+		printk(KERN_DEBUG "ar9170 FW: %.*s\n", len - 4,
+				(char *)buf + 4);
 		break;
 	case 0xcb:
 		len -= 4;
@@ -1727,7 +1728,7 @@ static void ar9170_tx(struct ar9170 *ar)
 			printk(KERN_DEBUG "%s: queue %d full\n",
 			       wiphy_name(ar->hw->wiphy), i);
 
-			printk(KERN_DEBUG "%s: stuck frames: ===> \n",
+			printk(KERN_DEBUG "%s: stuck frames: ===>\n",
 			       wiphy_name(ar->hw->wiphy));
 			ar9170_dump_txqueue(ar, &ar->tx_pending[i]);
 			ar9170_dump_txqueue(ar, &ar->tx_status[i]);
-- 
1.6.3.3

