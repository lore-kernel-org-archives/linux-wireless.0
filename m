Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1HHOTG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 10:19:06 -0400
Date: Mon, 8 Aug 2011 16:19:01 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC] mac80211: fix resuming when device is gone
Message-ID: <20110808141900.GA25857@redhat.com> (sfid-20110808_161911_484758_3E37E995)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is possible that usb hardware can be unplugged during or before resume.
If so do not call ieee80211_reconfig(), which among other things arm
sta_cleanup timer. Timer callback then operate on freed memory.

WARNING: at lib/debugobjects.c:262 debug_print_object+0x85/0xa0()
Hardware name: 6369CTO
ODEBUG: free active (active state 0) object type: timer_list hint:
sta_info_cleanup+0x0/0x1f0 [mac80211]
Modules linked in: rt73usb crc_itu_t rt2x00usb rt2x00lib mac80211
cfg80211 aes_i586 aes_generic fuse bridge stp llc autofs4 sunrpc
cpufreq_ondemand acpi_cpufreq mperf ext2 uinput sg arc4 i2c_i801
iTCO_wdt iTCO_vendor_support e1000e thinkpad_acpi hwmon ext4 mbcache
jbd2 sd_mod crc_t10dif sr_mod cdrom yenta_socket ahci libahci pata_acpi
ata_generic ata_piix i915 drm_kms_helper drm i2c_algo_bit video [last
unloaded: cfg80211]
Pid: 8251, comm: pm-hibernate Tainted: G        W   3.0.0-wl+ #7
Call Trace:
 [<c04510fd>] warn_slowpath_common+0x6d/0xa0
 [<c05ef1b5>] ? debug_print_object+0x85/0xa0
 [<c05ef1b5>] ? debug_print_object+0x85/0xa0
 [<c04511ae>] warn_slowpath_fmt+0x2e/0x30
 [<c05ef1b5>] debug_print_object+0x85/0xa0
 [<f8d1dac0>] ? sta_info_alloc+0x230/0x230 [mac80211]
 [<c05ef7b2>] debug_check_no_obj_freed+0xe2/0x180
 [<c051a80d>] kfree+0x9d/0x180
 [<f8cb368e>] cfg80211_dev_free+0x9e/0xb0 [cfg80211]
 [<f8cb4cbd>] wiphy_dev_release+0xd/0x10 [cfg80211]
 [<c06a3f09>] device_release+0x19/0x80
 [<c048858c>] ? trace_hardirqs_on_caller+0x12c/0x170
 [<c05e027a>] kobject_release+0x7a/0x1c0
 [<c06ad77c>] ? dpm_resume+0xcc/0x190
 [<c05e0200>] ? kobject_del+0x30/0x30
 [<c05e167d>] kref_put+0x2d/0x60
 [<c05e012d>] kobject_put+0x1d/0x50
 [<c081dc52>] ? mutex_lock_nested+0x42/0x50
 [<c06ad77c>] ? dpm_resume+0xcc/0x190
 [<c06a3b9f>] put_device+0xf/0x20
 [<c06ad7aa>] dpm_resume+0xfa/0x190
 [<c04975fd>] hibernation_snapshot+0xcd/0x270
 [<c049673f>] ? freeze_processes+0x3f/0x90
 [<c049786b>] hibernate+0xcb/0x1e0

I have this warning with possible fallow up crash without physically
unplugging device, but usb core rebind rt73usb with message:

"rt73usb 1-2:1.0: no reset_resume for driver rt73usb?"

What probably also need to be fixed in rt2x00. But I think fix in
mac80211 is needed for possibility of physical remove. Not sure if this
is best possible fix, through. Maybe just preventing arming sta_cleanup
would be better, other things in ieee80211_reconfig() seems to work.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/main.c        |    2 ++
 net/mac80211/util.c        |    3 +++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 400c09b..ce8201f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -804,6 +804,12 @@ struct ieee80211_local {
 	/* wowlan is enabled -- don't reconfig on resume */
 	bool wowlan;
 
+	/*
+	 * true between ieee80211_register_hw() and ieee80211_unregister_hw()
+	 * calls, protected by rtnl_lock(), used as hw gone check when resuming
+	 */
+	bool registered;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 866f269..7ef2698 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -929,6 +929,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 				   "Failed to add default virtual iface\n");
 	}
 
+	local->registered = true;
 	rtnl_unlock();
 
 	ieee80211_led_init(local);
@@ -1000,6 +1001,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	 */
 	ieee80211_remove_interfaces(local);
 
+	local->registered = false;
 	rtnl_unlock();
 
 	/*
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ddeb1b9..05da753 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1135,6 +1135,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	struct sta_info *sta;
 	int res, i;
 
+	if (!local->registered)
+		return -ENODEV;
+
 #ifdef CONFIG_PM
 	if (local->suspended)
 		local->resuming = true;
-- 
1.7.1

