Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33744 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1LQDRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 22:17:19 -0500
Date: Fri, 16 Dec 2011 21:17:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sgruszka@redhat.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix locking problem introduces with commit
 6539306b
Message-ID: <4eec09bc./W3avj1RKVpGrBhN%Larry.Finger@lwfinger.net> (sfid-20111217_041739_124556_09766DA3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I tested commit 6539306, I did not notice that loading an out-of-tree
module turns off lockdep testing in kernel 3.2. For that reason, I missed
the kernel WARNING shown below:

The solution fixes the warning by partially reverting commit 6539306.

[   84.168146] ------------[ cut here ]------------
[   84.168155] WARNING: at kernel/mutex.c:198 mutex_lock_nested+0x309/0x310()
[   84.168158] Hardware name: HP Pavilion dv2700 Notebook PC
[   84.168161] Modules linked in: nfs lockd auth_rpcgss nfs_acl sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 mperf e
xt3 jbd ide_cd_mod cdrom snd_hda_codec_conexant arc4 rtl8192ce ide_pci_generic rtl8192c_common rtlwifi snd_hda_intel mac80211 snd_hda_codec snd_pcm snd_timer
 amd74xx ide_core cfg80211 k8temp snd joydev soundcore hwmon battery forcedeth i2c_nforce2 sg rfkill ac serio_raw snd_page_alloc button video i2c_core ipv6 a
utofs4 ext4 mbcache jbd2 crc16 sd_mod ahci ohci_hcd libahci libata scsi_mod ehci_hcd usbcore usb_common fan processor thermal
[   84.168231] Pid: 1218, comm: kworker/u:2 Not tainted 3.2.0-rc5-wl+ #155
[   84.168234] Call Trace:
[   84.168240]  [<ffffffff81048aaa>] warn_slowpath_common+0x7a/0xb0
[   84.168245]  [<ffffffff81048af5>] warn_slowpath_null+0x15/0x20
[   84.168249]  [<ffffffff813811f9>] mutex_lock_nested+0x309/0x310
[   84.168269]  [<ffffffffa00793f9>] ? rtl_ips_nic_on+0x49/0xb0 [rtlwifi]
[   84.168277]  [<ffffffffa00793f9>] rtl_ips_nic_on+0x49/0xb0 [rtlwifi]
[   84.168284]  [<ffffffffa007ab85>] rtl_pci_tx+0x1b5/0x560 [rtlwifi]
[   84.168291]  [<ffffffffa007635a>] rtl_op_tx+0x9a/0xa0 [rtlwifi]
[   84.168359]  [<ffffffffa043cf51>] __ieee80211_tx+0x181/0x2b0 [mac80211]
[   84.168375]  [<ffffffffa043ef06>] ieee80211_tx+0xf6/0x120 [mac80211]
[   84.168391]  [<ffffffffa043ee49>] ? ieee80211_tx+0x39/0x120 [mac80211]
[   84.168408]  [<ffffffffa043f80b>] ieee80211_xmit+0xdb/0x100 [mac80211]
[   84.168425]  [<ffffffffa043f730>] ? ieee80211_skb_resize.isra.26+0xb0/0xb0 [mac80211]
[   84.168441]  [<ffffffffa0440b2a>] ieee80211_tx_skb_tid+0x5a/0x70 [mac80211]
[   84.168458]  [<ffffffffa0443da2>] ieee80211_send_auth+0x152/0x1b0 [mac80211]
[   84.168474]  [<ffffffffa042e169>] ieee80211_work_work+0x1049/0x1860 [mac80211]
[   84.168489]  [<ffffffffa042d120>] ? free_work+0x20/0x20 [mac80211]
[   84.168504]  [<ffffffffa042d120>] ? free_work+0x20/0x20 [mac80211]
[   84.168510]  [<ffffffff81065ffc>] process_one_work+0x17c/0x530
[   84.168514]  [<ffffffff81065f92>] ? process_one_work+0x112/0x530
[   84.168519]  [<ffffffff81066994>] worker_thread+0x164/0x350
[   84.168524]  [<ffffffff8108420d>] ? trace_hardirqs_on+0xd/0x10
[   84.168528]  [<ffffffff81066830>] ? manage_workers.isra.28+0x220/0x220
[   84.168533]  [<ffffffff8106bc17>] kthread+0x87/0x90
[   84.168539]  [<ffffffff813854b4>] kernel_thread_helper+0x4/0x10
[   84.168543]  [<ffffffff81382bdd>] ? retint_restore_args+0xe/0xe
[   84.168547]  [<ffffffff8106bb90>] ? __init_kthread_worker+0x70/0x70
[   84.168552]  [<ffffffff813854b0>] ? gs_change+0xb/0xb
[   84.168554] ---[ end trace f25a4fdc768c028f ]---

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stanislaw Gruska <sgruszka@redhat.com>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
---

John,

The patch that is being partially reverted has not yet been pushed to
mainline, thus 3.3 is appropriate.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
@@ -449,6 +449,7 @@ int rtl_init_core(struct ieee80211_hw *h
 	/* <4> locks */
 	mutex_init(&rtlpriv->locks.conf_mutex);
 	mutex_init(&rtlpriv->locks.ps_mutex);
+	spin_lock_init(&rtlpriv->locks.ips_lock);
 	spin_lock_init(&rtlpriv->locks.irq_th_lock);
 	spin_lock_init(&rtlpriv->locks.h2c_lock);
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
@@ -237,11 +237,12 @@ void rtl_ips_nic_on(struct ieee80211_hw
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	enum rf_pwrstate rtstate;
+	unsigned long flags;
 
 	if (mac->opmode != NL80211_IFTYPE_STATION)
 		return;
 
-	mutex_lock(&rtlpriv->locks.ps_mutex);
+	spin_lock_irqsave(&rtlpriv->locks.ips_lock, flags);
 
 	if (ppsc->inactiveps) {
 		rtstate = ppsc->rfpwr_state;
@@ -257,7 +258,7 @@ void rtl_ips_nic_on(struct ieee80211_hw
 		}
 	}
 
-	mutex_unlock(&rtlpriv->locks.ps_mutex);
+	spin_unlock_irqrestore(&rtlpriv->locks.ips_lock, flags);
 }
 
 /*for FW LPS*/
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -1547,6 +1547,7 @@ struct rtl_locks {
 	struct mutex ps_mutex;
 
 	/*spin lock */
+	spinlock_t ips_lock;
 	spinlock_t irq_th_lock;
 	spinlock_t h2c_lock;
 	spinlock_t rf_ps_lock;
