Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:59433 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1FTLmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 07:42:31 -0400
Subject: [PATCH 1/6] zd1211rw: fix invalid signal values from device
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 20 Jun 2011 14:42:28 +0300
Message-ID: <20110620114228.964.35459.stgit@localhost6.localdomain6> (sfid-20110620_134237_479021_4D66A32F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver uses IEEE80211_HW_SIGNAL_UNSPEC and so signal values reported to
mac80211 should be in range 0..100. Sometimes device return out of range
values. These out of range values can then trigger warning in
cfg80211_inform_bss_frame.

This patch adds checks to enforce range returned from driver to
mac80211 be in 0..100 range.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_def.h |    6 ++++++
 drivers/net/wireless/zd1211rw/zd_mac.c |   20 ++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_def.h b/drivers/net/wireless/zd1211rw/zd_def.h
index 5463ca9..9a1b013 100644
--- a/drivers/net/wireless/zd1211rw/zd_def.h
+++ b/drivers/net/wireless/zd1211rw/zd_def.h
@@ -37,9 +37,15 @@ typedef u16 __nocast zd_addr_t;
 	if (net_ratelimit()) \
 		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
 } while (0)
+#  define dev_dbg_f_cond(dev, cond, fmt, args...) ({ \
+	bool __cond = !!(cond); \
+	if (unlikely(__cond)) \
+		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
+})
 #else
 #  define dev_dbg_f(dev, fmt, args...) do { (void)(dev); } while (0)
 #  define dev_dbg_f_limit(dev, fmt, args...) do { (void)(dev); } while (0)
+#  define dev_dbg_f_cond(dev, cond, fmt, args...) do { (void)(dev); } while (0)
 #endif /* DEBUG */
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 5037c8b..5de28bf 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -160,6 +160,22 @@ static int zd_reg2alpha2(u8 regdomain, char *alpha2)
 	return 1;
 }
 
+static int zd_check_signal(struct ieee80211_hw *hw, int signal)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+
+	dev_dbg_f_cond(zd_mac_dev(mac), signal < 0 || signal > 100,
+			"%s: signal value from device not in range 0..100, "
+			"but %d.\n", __func__, signal);
+
+	if (signal < 0)
+		signal = 0;
+	else if (signal > 100)
+		signal = 100;
+
+	return signal;
+}
+
 int zd_mac_preinit_hw(struct ieee80211_hw *hw)
 {
 	int r;
@@ -461,7 +477,7 @@ static void zd_mac_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (i<IEEE80211_TX_MAX_RATES)
 		info->status.rates[i].idx = -1; /* terminate */
 
-	info->status.ack_signal = ackssi;
+	info->status.ack_signal = zd_check_signal(hw, ackssi);
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
@@ -982,7 +998,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 
 	stats.freq = zd_channels[_zd_chip_get_channel(&mac->chip) - 1].center_freq;
 	stats.band = IEEE80211_BAND_2GHZ;
-	stats.signal = status->signal_strength;
+	stats.signal = zd_check_signal(hw, status->signal_strength);
 
 	rate = zd_rx_rate(buffer, status);
 

