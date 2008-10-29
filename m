Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45142 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbYJ2Rx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 13:53:27 -0400
Message-Id: <20081029175220.543918201@localhost> (sfid-20081029_185329_415124_A453BAF0)
References: <20081029174934.817700763@localhost>
Date: Wed, 29 Oct 2008 19:49:35 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mac80211_hwsim: Debug info for BSS config changes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide detailed information on BSS configuration changes to make it
easier to debug mac80211 functionality.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c
@@ -415,6 +415,37 @@ static void mac80211_hwsim_bss_info_chan
 					    u32 changed)
 {
 	hwsim_check_magic(vif);
+	printk(KERN_DEBUG "%s:%s(changed=0x%x)\n",
+	       wiphy_name(hw->wiphy), __func__, changed);
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		printk(KERN_DEBUG "  ASSOC: assoc=%d aid=%d\n",
+		       info->assoc, info->aid);
+	}
+
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		printk(KERN_DEBUG "  ERP_CTS_PROT: %d\n", info->use_cts_prot);
+	}
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		printk(KERN_DEBUG "  ERP_PREAMBLE: %d\n",
+		       info->use_short_preamble);
+	}
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		printk(KERN_DEBUG "  ERP_SLOT: %d\n", info->use_short_slot);
+	}
+
+	if (changed & BSS_CHANGED_HT) {
+		printk(KERN_DEBUG "  HT: sec_ch_offs=%d width_40_ok=%d "
+		       "op_mode=%d\n", info->ht.secondary_channel_offset,
+		       info->ht.width_40_ok, info->ht.operation_mode);
+	}
+
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		printk(KERN_DEBUG "  BASIC_RATES: 0x%llx\n",
+		       info->basic_rates);
+	}
 }
 
 static void mac80211_hwsim_sta_notify(struct ieee80211_hw *hw,

--

-- 
Jouni Malinen                                            PGP id EFC895FA
