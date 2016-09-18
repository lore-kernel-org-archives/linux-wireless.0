Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36297 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932338AbcIRWRj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 18:17:39 -0400
Received: by mail-qt0-f196.google.com with SMTP id 11so4288053qtc.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2016 15:17:11 -0700 (PDT)
Date: Sun, 18 Sep 2016 18:14:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Using ath5k/ath9k radio for constant-tx noise source.
Message-ID: <20160918221438.GA5169@localhost> (sfid-20160919_002056_904199_1993F304)
References: <55D4D406.5000603@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55D4D406.5000603@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2015 at 12:07:50PM -0700, Ben Greear wrote:
> I have a commercial AP that is using a CM9 ath5k radio (evidently, I could be wrong)
> and it has the ability to do a constant transmit of raw noise (RF probe shows
> noise, but a monitor-port sniffer does not see any frames from the CM9).
> 
> I don't know the low-level details of how it is doing this, but I suspect
> it is using something like madwifi for a driver.
> 
> Does anyone know how this can be done with modern software and
> ath5k or ath9k NICs?

So, see the below patch for something that might work.  I only dusted off
and compile-tested this, and I'm not sure if it is controllable to the
extent that would be needed for things like DFS testing.

Just to reiterate the disclaimer, I'm told running radio in this mode for
an extended period of time can damage it, so -- good luck.

Note, ath9k has another kind of tx-99 mode which just sends out packets
constantly; ath5k is of course capable of doing that kind of thing too.
Setup for that is mostly the same except the descriptor list is just
self-linked and some of the phy tricks aren't needed.

>From fd374ea31833f705d6a08bb8f8e171cfcda8c302 Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Tue, 17 May 2016 00:24:42 -0400
Subject: [PATCH] ath5k: add continuous-wave transmit mode

Continuous-wave mode is a kind of testmode in which RF is emitted on
a single carrier frequency; sometimes this kind of thing is needed
for FCC certification.  Some Atheros devices support entering this
mode for testing.

This patch demonstrates (some of?) the settings needed to get the
device into the mode.  I don't claim to understand it and the PHY
is 100% undocumented as far as I know, so a lot of this is guesswork
based on what is done in some versions of madwifi.  It seems to work
on one radio I tried it on (monitored with ath9k's spectral scan and
my own "speccy" tool) -- but it might well destroy yours, so, don't
run it unless you don't care about that possibility.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/Makefile |   1 +
 drivers/net/wireless/ath/ath5k/ath5k.h  |   1 +
 drivers/net/wireless/ath/ath5k/base.h   |   3 +
 drivers/net/wireless/ath/ath5k/debug.c  |  47 ++++++++
 drivers/net/wireless/ath/ath5k/tx99.c   | 200 ++++++++++++++++++++++++++++++++
 5 files changed, 252 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath5k/tx99.c

diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index 1b3a34f..afc699f 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -16,6 +16,7 @@ ath5k-y				+= rfkill.o
 ath5k-y				+= ani.o
 ath5k-y				+= sysfs.o
 ath5k-y				+= mac80211-ops.o
+ath5k-y				+= tx99.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
 ath5k-$(CONFIG_ATH5K_AHB)	+= ahb.o
 ath5k-$(CONFIG_ATH5K_PCI)	+= pci.o
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 67fedb6..8c86a96 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1446,6 +1446,7 @@ struct ath5k_hw {
 
 	/* Calibration mask */
 	u8			ah_cal_mask;
+	bool			tx99_active;
 
 	/*
 	 * Function pointers
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 97469d0..3e50c747 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -112,6 +112,9 @@ const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
 int ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops);
 void ath5k_deinit_ah(struct ath5k_hw *ah);
 
+void ath5k_tx99_cw_start(struct ath5k_hw *ah);
+void ath5k_tx99_cw_stop(struct ath5k_hw *ah);
+
 /* Check whether BSSID mask is supported */
 #define ath5k_hw_hasbssidmask(_ah) (ah->ah_version == AR5K_AR5212)
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 4f8d9ed..260f061 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -991,6 +991,50 @@ static const struct file_operations fops_eeprom = {
 };
 
 
+static ssize_t read_file_tx99(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	char buf[3];
+	struct ath5k_hw *ah = file->private_data;
+
+	if (!ah->tx99_active)
+		buf[0] = '0';
+	else
+		buf[0] = '1';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	char buf[32];
+	size_t buf_size;
+	struct ath5k_hw *ah = file->private_data;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	buf[buf_size] = '\0';
+
+	if (buf[0] == '0')
+		ath5k_tx99_cw_stop(ah);
+	else if (buf[0] == '1')
+		ath5k_tx99_cw_start(ah);
+
+	return count;
+}
+
+static const struct file_operations fops_tx99 = {
+	.read = read_file_tx99,
+	.write = write_file_tx99,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void
 ath5k_debug_init_device(struct ath5k_hw *ah)
 {
@@ -1029,6 +1073,9 @@ ath5k_debug_init_device(struct ath5k_hw *ah)
 
 	debugfs_create_bool("32khz_clock", S_IWUSR | S_IRUSR, phydir,
 			    &ah->ah_use_32khz_clock);
+
+	debugfs_create_file("tx99", S_IRUSR | S_IWUSR, phydir,
+			    ah, &fops_tx99);
 }
 
 /* functions used in other places */
diff --git a/drivers/net/wireless/ath/ath5k/tx99.c b/drivers/net/wireless/ath/ath5k/tx99.c
new file mode 100644
index 0000000..3a88893
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/tx99.c
@@ -0,0 +1,200 @@
+#include <net/mac80211.h>
+#include "ath5k.h"
+#include "base.h"
+#include "reg.h"
+
+/*
+ * Copyright (c) 2016 Bob Copeland <me@bobcopeland.com>
+ *
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
+ *    redistribution must be conditioned upon including a substantially
+ *    similar Disclaimer requirement for further binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF NONINFRINGEMENT, MERCHANTIBILITY
+ * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY,
+ * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
+ * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES.
+ */
+
+static void ath5k_tx99_queue_frames(struct ath5k_hw *ah, int count)
+{
+	int i, j;
+	int frame_len = 1500;
+	__le16 fc;
+	u8 rate_idx;
+	u8 qnum = 3;
+	int max_loops = 1000, loop;
+	struct ieee80211_hdr *frame;
+	struct ieee80211_tx_info *info;
+
+	struct sk_buff *skb;
+	struct ieee80211_tx_control control = {
+		.sta = NULL
+	};
+
+	for (i = 0; i < count; i++) {
+		fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS);
+		skb = dev_alloc_skb(ah->hw->extra_tx_headroom + frame_len);
+		if (!skb)
+			continue;
+		skb_reserve(skb, ah->hw->extra_tx_headroom);
+
+		frame = (struct ieee80211_hdr *) skb_put(skb, frame_len);
+		memset(frame, 0, frame_len);
+		frame->frame_control = fc;
+		memcpy(frame->addr1, ah->common.macaddr, ETH_ALEN);
+		memcpy(frame->addr2, ah->common.macaddr, ETH_ALEN);
+		memcpy(frame->addr3, ah->common.macaddr, ETH_ALEN);
+		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+
+		info = IEEE80211_SKB_CB(skb);
+		memset(info, 0, sizeof(*info));
+		info->flags |= IEEE80211_TX_CTL_INJECTED;
+
+		/* use highest rate on whichever band we're on */
+		info->band = ah->curchan->band;
+		rate_idx = ah->sbands[info->band].n_bitrates - 1;
+
+		for (j=0; j < IEEE80211_TX_MAX_RATES; j++)
+			info->control.rates[j].idx = -1;
+
+		info->control.rates[0].idx = rate_idx;
+		info->control.rates[0].count = 15;
+
+		rcu_read_lock();
+		ath5k_tx_queue(ah->hw, skb, &ah->txqs[qnum], &control);
+		rcu_read_unlock();
+	}
+
+	/* wait for queued frames to be sent */
+	printk(KERN_INFO "ath5k: tx99: sending initial frames...\n");
+	loop = 0;
+	while (ath5k_hw_num_tx_pending(ah, qnum) > 0) {
+		msleep(10);
+		if (loop++ > max_loops)
+			break;
+	}
+	printk(KERN_INFO "ath5k: tx99: done sending initial frames\n");
+}
+
+void ath5k_tx99_cw_start(struct ath5k_hw *ah)
+{
+	u32 val, xpa_orig;
+	bool xpaa_active_high, xpab_active_high;
+
+	if (ah->tx99_active)
+		return;
+
+	printk(KERN_INFO "ath5k: entering tx99 mode on freq %d, txpower %d dBm\n",
+	       ah->curchan->center_freq, ah->ah_txpower.txp_requested),
+	ah->tx99_active = true;
+
+	/*
+	 * disable TX hang queue check -- if we don't do this then
+	 * the tx watchdog will issue a reset eventually and we'll
+	 * leave tx99 mode
+	 */
+	clear_bit(ATH_STAT_STARTED, ah->status);
+
+	/* toggle XPA -- A for 5G or B for 2G */
+	ath5k_hw_reg_write(ah, 7, AR5K_PHY_PA_CTL);
+
+	val = ath5k_hw_reg_read(ah, AR5K_PHY_PA_CTL);
+	xpaa_active_high = !!(val & AR5K_PHY_PA_CTL_XPA_A_HI);
+	xpab_active_high = !!(val & AR5K_PHY_PA_CTL_XPA_B_HI);
+	xpa_orig = val;
+
+	if (ah->curchan->band == NL80211_BAND_5GHZ) {
+		val &= ~AR5K_PHY_PA_CTL_XPA_A_HI;
+		if (!xpaa_active_high)
+			val |= AR5K_PHY_PA_CTL_XPA_A_HI;
+	} else {
+		val &= ~AR5K_PHY_PA_CTL_XPA_B_HI;
+		if (!xpab_active_high)
+			val |= AR5K_PHY_PA_CTL_XPA_B_HI;
+	}
+	ath5k_hw_reg_write(ah, val, AR5K_PHY_PA_CTL);
+
+	/*
+	 * baseband operates in receive mode in continuous wave mode so
+	 * use non-transmitting antenna
+	 */
+	ah->ah_tx_ant = 2;
+
+	/* send a few frames to ramp up output power */
+	ath5k_tx99_queue_frames(ah, 20);
+
+	mdelay(20);
+
+	/* disable interrupts */
+	ath5k_hw_set_imr(ah, 0);
+
+	/* force AGC clear */
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_TST2, AR5K_PHY_TST2_FORCE_AGC_CLR);
+	AR5K_REG_ENABLE_BITS(ah, 0x9864, 0x7f000);
+	AR5K_REG_ENABLE_BITS(ah, 0x9924, 0x7f00fe);
+
+	/* disable carrier sense */
+	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_RX_CLEAR_HIGH | AR5K_DIAG_SW_IGNORE_CARR_SENSE);
+
+	/* disable receive */
+	ath5k_hw_reg_write(ah, AR5K_CR_RXD, AR5K_CR);
+
+	/* set constant values */
+	ath5k_hw_reg_write(ah, (0x1ff << 9) | 0x1ff, 0x983c);
+
+	/* enable testmode on the ADC */
+	AR5K_REG_MASKED_BITS(ah, AR5K_PHY_TST1, (1 << 7) | (1 << 1),  0xffffff7d);
+
+	/* turn on the ADC */
+	ath5k_hw_reg_write(ah, 0x80038ffc, AR5K_PHY_ADC_CTL);
+	mdelay(10);
+
+	/* turn on RF */
+	val = 0x10a098c2;
+	if (ah->curchan->band == NL80211_BAND_2GHZ) {
+		val |= 0x400000;
+	}
+	ath5k_hw_reg_write(ah, val, 0x98dc);
+	mdelay(10);
+	val |= 0x4000;
+
+	ath5k_hw_reg_write(ah, val, 0x98dc);
+}
+
+void ath5k_tx99_cw_stop(struct ath5k_hw *ah)
+{
+	if (!ah->tx99_active)
+		return;
+
+	printk(KERN_INFO "ath5k: leaving tx99 mode\n");
+	set_bit(ATH_STAT_STARTED, ah->status);
+	ah->tx99_active = false;
+
+	/* just reset the device */
+	ath5k_hw_reset(ah, ah->opmode, ah->curchan, false, false);
+}
-- 
2.9.0


-- 
Bob Copeland %% http://bobcopeland.com/
