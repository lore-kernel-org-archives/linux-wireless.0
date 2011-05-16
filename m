Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52452 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab1EPMx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 08:53:27 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 05:52:57 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: Fix power save wrappers in debug ops
Date: Mon, 16 May 2011 18:23:23 +0530
Message-ID: <1305550403-11305-1-git-send-email-rmanoharan@atheros.com> (sfid-20110516_145330_814996_AF00F459)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index bad1a87..7afe332 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -443,7 +443,9 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"addrmask: %pM\n", addr);
+	ath9k_ps_wakeup(sc);
 	tmp = ath9k_hw_getrxfilter(sc->sc_ah);
+	ath9k_ps_restore(sc);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"rfilt: 0x%x", tmp);
 	if (tmp & ATH9K_RX_FILTER_UCAST)
@@ -725,6 +727,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 		break;
 	}
 
+	ath9k_ps_wakeup(sc);
 	len += snprintf(buf + len, size - len,
 			"curbssid: %pM\n"
 			"OP-Mode: %s(%i)\n"
@@ -734,6 +737,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 			REG_READ(ah, AR_BEACON_PERIOD));
 
 	reg = REG_READ(ah, AR_TIMER_MODE);
+	ath9k_ps_restore(sc);
 	len += snprintf(buf + len, size - len, "Timer-Mode-Register: 0x%x (",
 			reg);
 	if (reg & AR_TBTT_TIMER_EN)
@@ -1050,7 +1054,9 @@ static ssize_t read_file_regval(struct file *file, char __user *user_buf,
 	unsigned int len;
 	u32 regval;
 
+	ath9k_ps_wakeup(sc);
 	regval = REG_READ_D(ah, sc->debug.regidx);
+	ath9k_ps_restore(sc);
 	len = sprintf(buf, "0x%08x\n", regval);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
@@ -1072,7 +1078,9 @@ static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
 	if (strict_strtoul(buf, 0, &regval))
 		return -EINVAL;
 
+	ath9k_ps_wakeup(sc);
 	REG_WRITE_D(ah, sc->debug.regidx, regval);
+	ath9k_ps_restore(sc);
 	return count;
 }
 
-- 
1.7.5.1

