Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48486 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0INTqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 15:46:09 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [ath9k] ath9k:  Print rxfilter in debugfs.
Date: Tue, 14 Sep 2010 12:46:04 -0700
Message-Id: <1284493564-26191-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Print raw and decoded rxfilter in debufs 'wiphy' file.

Also, move variable-length printouts to bottom of file to
make bounds checking easier.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 54aae93... 863450d... M	drivers/net/wireless/ath/ath9k/debug.c
 drivers/net/wireless/ath/ath9k/debug.c |   53 ++++++++++++++++++++++++++------
 1 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 54aae93..863450d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -492,12 +492,55 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 	unsigned int len = 0;
 	int i;
 	u8 addr[ETH_ALEN];
+	u32 tmp;
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"primary: %s (%s chan=%d ht=%d)\n",
 			wiphy_name(sc->pri_wiphy->hw->wiphy),
 			ath_wiphy_state_str(sc->pri_wiphy->state),
 			sc->pri_wiphy->chan_idx, sc->pri_wiphy->chan_is_ht);
+
+	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
+	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"addr: %pM\n", addr);
+	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_BSSMSKL), addr);
+	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"addrmask: %pM\n", addr);
+	tmp = ath9k_hw_getrxfilter(sc->sc_ah);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"rfilt: 0x%x", tmp);
+	if (tmp & ATH9K_RX_FILTER_UCAST)
+		len += snprintf(buf + len, sizeof(buf) - len, " UCAST");
+	if (tmp & ATH9K_RX_FILTER_MCAST)
+		len += snprintf(buf + len, sizeof(buf) - len, " MCAST");
+	if (tmp & ATH9K_RX_FILTER_BCAST)
+		len += snprintf(buf + len, sizeof(buf) - len, " BCAST");
+	if (tmp & ATH9K_RX_FILTER_CONTROL)
+		len += snprintf(buf + len, sizeof(buf) - len, " CONTROL");
+	if (tmp & ATH9K_RX_FILTER_BEACON)
+		len += snprintf(buf + len, sizeof(buf) - len, " BEACON");
+	if (tmp & ATH9K_RX_FILTER_PROM)
+		len += snprintf(buf + len, sizeof(buf) - len, " PROM");
+	if (tmp & ATH9K_RX_FILTER_PROBEREQ)
+		len += snprintf(buf + len, sizeof(buf) - len, " PROBEREQ");
+	if (tmp & ATH9K_RX_FILTER_PHYERR)
+		len += snprintf(buf + len, sizeof(buf) - len, " PHYERR");
+	if (tmp & ATH9K_RX_FILTER_MYBEACON)
+		len += snprintf(buf + len, sizeof(buf) - len, " MYBEACON");
+	if (tmp & ATH9K_RX_FILTER_COMP_BAR)
+		len += snprintf(buf + len, sizeof(buf) - len, " COMP_BAR");
+	if (tmp & ATH9K_RX_FILTER_PSPOLL)
+		len += snprintf(buf + len, sizeof(buf) - len, " PSPOLL");
+	if (tmp & ATH9K_RX_FILTER_PHYRADAR)
+		len += snprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
+	if (tmp & ATH9K_RX_FILTER_MCAST_BCAST_ALL)
+		len += snprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL\n");
+	else
+		len += snprintf(buf + len, sizeof(buf) - len, "\n");
+		
+	/* Put variable-length stuff down here, and check for overflows. */
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
 		if (aphy == NULL)
@@ -508,16 +551,6 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 				ath_wiphy_state_str(aphy->state),
 				aphy->chan_idx, aphy->chan_is_ht);
 	}
-
-	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
-	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"addr: %pM\n", addr);
-	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_BSSMSKL), addr);
-	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"addrmask: %pM\n", addr);
-
 	if (len > sizeof(buf))
 		len = sizeof(buf);
 
-- 
1.7.2.2

