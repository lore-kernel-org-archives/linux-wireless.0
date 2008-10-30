Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56382 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbYJ3PC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:02:56 -0400
Message-Id: <20081030150154.912492420@localhost> (sfid-20081030_160258_985125_86B3BFD7)
References: <20081030145920.233178987@localhost>
Date: Thu, 30 Oct 2008 16:59:21 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2 1/5] mac80211_hwsim: Debug info for BSS config changes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide detailed information on BSS configuration changes to make it
easier to debug mac80211 functionality.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2008-10-28 19:50:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 16:09:28.000000000 +0200
@@ -415,6 +415,43 @@
 					    u32 changed)
 {
 	hwsim_check_magic(vif);
+
+	printk(KERN_DEBUG "%s:%s(changed=0x%x)\n",
+	       wiphy_name(hw->wiphy), __func__, changed);
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		printk(KERN_DEBUG "  %s: ASSOC: assoc=%d aid=%d\n",
+		       wiphy_name(hw->wiphy), info->assoc, info->aid);
+	}
+
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		printk(KERN_DEBUG "  %s: ERP_CTS_PROT: %d\n",
+		       wiphy_name(hw->wiphy), info->use_cts_prot);
+	}
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		printk(KERN_DEBUG "  %s: ERP_PREAMBLE: %d\n",
+		       wiphy_name(hw->wiphy), info->use_short_preamble);
+	}
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		printk(KERN_DEBUG "  %s: ERP_SLOT: %d\n",
+		       wiphy_name(hw->wiphy), info->use_short_slot);
+	}
+
+	if (changed & BSS_CHANGED_HT) {
+		printk(KERN_DEBUG "  %s: HT: sec_ch_offs=%d width_40_ok=%d "
+		       "op_mode=%d\n",
+		       wiphy_name(hw->wiphy),
+		       info->ht.secondary_channel_offset,
+		       info->ht.width_40_ok, info->ht.operation_mode);
+	}
+
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		printk(KERN_DEBUG "  %s: BASIC_RATES: 0x%llx\n",
+		       wiphy_name(hw->wiphy),
+		       (unsigned long long) info->basic_rates);
+	}
 }
 
 static void mac80211_hwsim_sta_notify(struct ieee80211_hw *hw,

--

-- 
Jouni Malinen                                            PGP id EFC895FA
