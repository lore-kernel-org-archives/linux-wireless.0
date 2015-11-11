Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49108 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbbKKWP0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 17:15:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v3 4/8] mac80211: test the static key code
Date: Wed, 11 Nov 2015 23:15:16 +0100
Message-Id: <1447280120-16010-5-git-send-email-johannes@sipsolutions.net> (sfid-20151111_231536_394072_6FD64827)
In-Reply-To: <1447280120-16010-1-git-send-email-johannes@sipsolutions.net>
References: <1447280120-16010-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make hwsim select a few on/off symbols and check that the
result is as expected:
 * before 'registering' a device the branches are according
   to the Kconfig default only
 * 'registering' a device fixes that up to actually check
   the hardware flags
 * 'unregistering' again goes back to the default

Test this with a fake flags field that contains the *inverse*
of the Kconfig selections.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/Kconfig | 11 +++++++++++
 net/mac80211/hwflags.c       | 36 ++++++++++++++++++++++++++++++++++++
 net/mac80211/hwflags.h       |  2 ++
 net/mac80211/main.c          |  2 ++
 4 files changed, 51 insertions(+)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f9f94229bf1b..f2a8fdca5ede 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -246,6 +246,17 @@ source "drivers/net/wireless/realtek/rtl818x/Kconfig"
 config MAC80211_HWSIM
 	tristate "Simulated radio testing tool for mac80211"
 	depends on MAC80211
+	select MAC80211_HW_SUPPORT_FAST_XMIT_ON
+	select MAC80211_HW_CHANCTX_STA_CSA_ON
+	select MAC80211_HW_SUPPORTS_HT_CCK_RATES_ON
+	select MAC80211_HW_QUEUE_CONTROL_ON
+	select MAC80211_HW_WANT_MONITOR_VIF_ON
+	select MAC80211_HW_AMPDU_AGGREGATION_ON
+	select MAC80211_HW_MFP_CAPABLE_ON
+	select MAC80211_HW_SIGNAL_DBM_ON
+	select MAC80211_HW_TDLS_WIDER_BW_ON
+	select MAC80211_HW_HAS_RATE_CONTROL_OFF
+	select MAC80211_HW_RX_INCLUDES_FCS_OFF
 	---help---
 	  This driver is a developer testing tool that can be used to test
 	  IEEE 802.11 networking stack (mac80211) functionality. This is not
diff --git a/net/mac80211/hwflags.c b/net/mac80211/hwflags.c
index 3beeee512f91..eca0e3ee6818 100644
--- a/net/mac80211/hwflags.c
+++ b/net/mac80211/hwflags.c
@@ -127,3 +127,39 @@ void ieee80211_hwflags_sync_del(unsigned long *flags)
 			static_branch_dec(&hwflags_keys[flg]);
 	}
 }
+
+void ieee80211_test_hwflags(void)
+{
+	struct {
+		struct {
+			unsigned long flags[2];
+		} hw;
+	} _local = {};
+
+	__set_bit(IEEE80211_HW_HAS_RATE_CONTROL, _local.hw.flags);
+	__clear_bit(IEEE80211_HW_SUPPORT_FAST_XMIT, _local.hw.flags);
+
+	/* before the sync_add(), we expect only as per Kconfig */
+	if (ieee80211_local_check(&_local, HAS_RATE_CONTROL))
+		printk(KERN_DEBUG "BAD: HW rate control\n");
+	if (!ieee80211_local_check(&_local, SUPPORT_FAST_XMIT))
+		printk(KERN_DEBUG "BAD: !SUPPORT_FAST_XMIT\n");
+
+	ieee80211_hwflags_sync_add(_local.hw.flags);
+	printk(KERN_DEBUG "added\n");
+
+	/* now it should be like as per flags */
+	if (!ieee80211_local_check(&_local, HAS_RATE_CONTROL))
+		printk(KERN_DEBUG "BAD: !HW rate control\n");
+	if (ieee80211_local_check(&_local, SUPPORT_FAST_XMIT))
+		printk(KERN_DEBUG "BAD: SUPPORT_FAST_XMIT\n");
+
+	ieee80211_hwflags_sync_del(_local.hw.flags);
+	printk(KERN_DEBUG "removed\n");
+
+	/* after remove it should be as before */
+	if (ieee80211_local_check(&_local, HAS_RATE_CONTROL))
+		printk(KERN_DEBUG "BAD: HW rate control\n");
+	if (!ieee80211_local_check(&_local, SUPPORT_FAST_XMIT))
+		printk(KERN_DEBUG "BAD: !SUPPORT_FAST_XMIT\n");
+}
diff --git a/net/mac80211/hwflags.h b/net/mac80211/hwflags.h
index e220c5e04406..06f0a9f64fe6 100644
--- a/net/mac80211/hwflags.h
+++ b/net/mac80211/hwflags.h
@@ -86,4 +86,6 @@ static inline void ieee80211_hwflags_sync_add(unsigned long *flags) {}
 static inline void ieee80211_hwflags_sync_del(unsigned long *flags) {}
 #endif /* CONFIG_JUMP_LABEL */
 
+void ieee80211_test_hwflags(void);
+
 #endif /* __mac80211_hwflags_h */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 03ad36ba4945..d64aae164d7a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1228,6 +1228,8 @@ static int __init ieee80211_init(void)
 	if (ret)
 		goto err_netdev;
 
+	ieee80211_test_hwflags();
+
 	return 0;
  err_netdev:
 	rc80211_minstrel_ht_exit();
-- 
2.6.2

