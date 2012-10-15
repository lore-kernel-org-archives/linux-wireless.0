Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24944 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2JONYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 09:24:00 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 1/3] compat-drivers: Update pending stable patches.
Date: Mon, 15 Oct 2012 18:53:18 +0530
Message-ID: <1350307400-8215-2-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121015_152406_581118_99B8C650)
In-Reply-To: <1350307400-8215-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1350307400-8215-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ...h-mgmt-Fix-enabling-SSP-while-powered-off.patch |  43 -----
 ...th-mgmt-Fix-enabling-LE-while-powered-off.patch |  46 -----
 ...h-Fix-not-removing-power_off-delayed-work.patch |  76 --------
 ...x-possible-circular-lock-on-reg_regdb_sea.patch | 129 -------------
 ...-t-double-free-the-interrupt-in-failure-p.patch |  33 ----
 ...gmt-Implement-support-for-passkey-notific.patch | 214 ---------------------
 ...ooth-Update-management-interface-revision.patch |  36 ----
 ...dd-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch |  31 ---
 .../0009-ath9k-Disable-ASPM-only-for-AR9285.patch  |  38 ----
 9 files changed, 646 deletions(-)
 delete mode 100644 pending-stable/0001-Bluetooth-mgmt-Fix-enabling-SSP-while-powered-off.patch
 delete mode 100644 pending-stable/0002-Bluetooth-mgmt-Fix-enabling-LE-while-powered-off.patch
 delete mode 100644 pending-stable/0003-Bluetooth-Fix-not-removing-power_off-delayed-work.patch
 delete mode 100644 pending-stable/0004-cfg80211-fix-possible-circular-lock-on-reg_regdb_sea.patch
 delete mode 100644 pending-stable/0005-iwlwifi-don-t-double-free-the-interrupt-in-failure-p.patch
 delete mode 100644 pending-stable/0006-Bluetooth-mgmt-Implement-support-for-passkey-notific.patch
 delete mode 100644 pending-stable/0007-Bluetooth-Update-management-interface-revision.patch
 delete mode 100644 pending-stable/0008-Bluetooth-Add-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch
 delete mode 100644 pending-stable/0009-ath9k-Disable-ASPM-only-for-AR9285.patch

diff --git a/pending-stable/0001-Bluetooth-mgmt-Fix-enabling-SSP-while-powered-off.patch b/pending-stable/0001-Bluetooth-mgmt-Fix-enabling-SSP-while-powered-off.patch
deleted file mode 100644
index 636229e..0000000
--- a/pending-stable/0001-Bluetooth-mgmt-Fix-enabling-SSP-while-powered-off.patch
+++ /dev/null
@@ -1,43 +0,0 @@
-From 3d1cbdd6aefff711bcf389fdabc4af9bc22e8201 Mon Sep 17 00:00:00 2001
-From: Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
-Date: Wed, 29 Aug 2012 10:02:08 +0200
-Subject: [PATCH 1/9] Bluetooth: mgmt: Fix enabling SSP while powered off
-
-When new BT USB adapter is plugged in it's configured while still being powered
-off (HCI_AUTO_OFF flag is set), thus Set SSP will only set dev_flags but won't
-write changes to controller. As a result remote devices won't use Secure Simple
-Pairing with our device due to SSP Host Support flag disabled in extended
-features and may also reject SSP attempt from our side (with possible fallback
-to legacy pairing).
-
-This patch ensures HCI Write Simple Pairing Mode is sent when Set Powered is
-called to power on controller and clear HCI_AUTO_OFF flag.
-
-Signed-off-by: Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
-Cc: stable@vger.kernel.org
-Acked-by: Johan Hedberg <johan.hedberg@intel.com>
-Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
----
- net/bluetooth/mgmt.c | 6 ++++++
- 1 file changed, 6 insertions(+)
-
-diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
-index ad6613d..f943bbf 100644
---- a/net/bluetooth/mgmt.c
-+++ b/net/bluetooth/mgmt.c
-@@ -2875,6 +2875,12 @@ int mgmt_powered(struct hci_dev *hdev, u8 powered)
- 		if (scan)
- 			hci_send_cmd(hdev, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
- 
-+		if (test_bit(HCI_SSP_ENABLED, &hdev->dev_flags)) {
-+			u8 ssp = 1;
-+
-+			hci_send_cmd(hdev, HCI_OP_WRITE_SSP_MODE, 1, &ssp);
-+		}
-+
- 		update_class(hdev);
- 		update_name(hdev, hdev->dev_name);
- 		update_eir(hdev);
--- 
-1.7.12.1
-
diff --git a/pending-stable/0002-Bluetooth-mgmt-Fix-enabling-LE-while-powered-off.patch b/pending-stable/0002-Bluetooth-mgmt-Fix-enabling-LE-while-powered-off.patch
deleted file mode 100644
index 9c66eee..0000000
--- a/pending-stable/0002-Bluetooth-mgmt-Fix-enabling-LE-while-powered-off.patch
+++ /dev/null
@@ -1,46 +0,0 @@
-From 562fcc246ebe31ade6e1be08585673b9b2785498 Mon Sep 17 00:00:00 2001
-From: Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
-Date: Wed, 29 Aug 2012 10:02:09 +0200
-Subject: [PATCH 2/9] Bluetooth: mgmt: Fix enabling LE while powered off
-
-When new BT USB adapter is plugged in it's configured while still being powered
-off (HCI_AUTO_OFF flag is set), thus Set LE will only set dev_flags but won't
-write changes to controller. As a result it's not possible to start device
-discovery session on LE controller as it uses interleaved discovery which
-requires LE Supported Host flag in extended features.
-
-This patch ensures HCI Write LE Host Supported is sent when Set Powered is
-called to power on controller and clear HCI_AUTO_OFF flag.
-
-Signed-off-by: Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
-Cc: stable@vger.kernel.org
-Acked-by: Johan Hedberg <johan.hedberg@intel.com>
-Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
----
- net/bluetooth/mgmt.c | 10 ++++++++++
- 1 file changed, 10 insertions(+)
-
-diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
-index f943bbf..eba022d 100644
---- a/net/bluetooth/mgmt.c
-+++ b/net/bluetooth/mgmt.c
-@@ -2881,6 +2881,16 @@ int mgmt_powered(struct hci_dev *hdev, u8 powered)
- 			hci_send_cmd(hdev, HCI_OP_WRITE_SSP_MODE, 1, &ssp);
- 		}
- 
-+		if (test_bit(HCI_LE_ENABLED, &hdev->dev_flags)) {
-+			struct hci_cp_write_le_host_supported cp;
-+
-+			cp.le = 1;
-+			cp.simul = !!(hdev->features[6] & LMP_SIMUL_LE_BR);
-+
-+			hci_send_cmd(hdev, HCI_OP_WRITE_LE_HOST_SUPPORTED,
-+				     sizeof(cp), &cp);
-+		}
-+
- 		update_class(hdev);
- 		update_name(hdev, hdev->dev_name);
- 		update_eir(hdev);
--- 
-1.7.12.1
-
diff --git a/pending-stable/0003-Bluetooth-Fix-not-removing-power_off-delayed-work.patch b/pending-stable/0003-Bluetooth-Fix-not-removing-power_off-delayed-work.patch
deleted file mode 100644
index 3171104..0000000
--- a/pending-stable/0003-Bluetooth-Fix-not-removing-power_off-delayed-work.patch
+++ /dev/null
@@ -1,76 +0,0 @@
-From 78c04c0bf52360dc2f7185e99c8e9aa05d73ae5a Mon Sep 17 00:00:00 2001
-From: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
-Date: Fri, 14 Sep 2012 16:34:46 -0300
-Subject: [PATCH 3/9] Bluetooth: Fix not removing power_off delayed work
-
-For example, when a usb reset is received (I could reproduce it
-running something very similar to this[1] in a loop) it could be
-that the device is unregistered while the power_off delayed work
-is still scheduled to run.
-
-Backtrace:
-
-WARNING: at lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
-Hardware name: To Be Filled By O.E.M.
-ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x26
-Modules linked in: nouveau mxm_wmi btusb wmi bluetooth ttm coretemp drm_kms_helper
-Pid: 2114, comm: usb-reset Not tainted 3.5.0bt-next #2
-Call Trace:
- [<ffffffff8124cc00>] ? free_obj_work+0x57/0x91
- [<ffffffff81058f88>] warn_slowpath_common+0x7e/0x97
- [<ffffffff81059035>] warn_slowpath_fmt+0x41/0x43
- [<ffffffff8124ccb6>] debug_print_object+0x7c/0x8d
- [<ffffffff8106e3ec>] ? __queue_work+0x259/0x259
- [<ffffffff8124d63e>] ? debug_check_no_obj_freed+0x6f/0x1b5
- [<ffffffff8124d667>] debug_check_no_obj_freed+0x98/0x1b5
- [<ffffffffa00aa031>] ? bt_host_release+0x10/0x1e [bluetooth]
- [<ffffffff810fc035>] kfree+0x90/0xe6
- [<ffffffffa00aa031>] bt_host_release+0x10/0x1e [bluetooth]
- [<ffffffff812ec2f9>] device_release+0x4a/0x7e
- [<ffffffff8123ef57>] kobject_release+0x11d/0x154
- [<ffffffff8123ed98>] kobject_put+0x4a/0x4f
- [<ffffffff812ec0d9>] put_device+0x12/0x14
- [<ffffffffa009472b>] hci_free_dev+0x22/0x26 [bluetooth]
- [<ffffffffa0280dd0>] btusb_disconnect+0x96/0x9f [btusb]
- [<ffffffff813581b4>] usb_unbind_interface+0x57/0x106
- [<ffffffff812ef988>] __device_release_driver+0x83/0xd6
- [<ffffffff812ef9fb>] device_release_driver+0x20/0x2d
- [<ffffffff813582a7>] usb_driver_release_interface+0x44/0x7b
- [<ffffffff81358795>] usb_forced_unbind_intf+0x45/0x4e
- [<ffffffff8134f959>] usb_reset_device+0xa6/0x12e
- [<ffffffff8135df86>] usbdev_do_ioctl+0x319/0xe20
- [<ffffffff81203244>] ? avc_has_perm_flags+0xc9/0x12e
- [<ffffffff812031a0>] ? avc_has_perm_flags+0x25/0x12e
- [<ffffffff81050101>] ? do_page_fault+0x31e/0x3a1
- [<ffffffff8135eaa6>] usbdev_ioctl+0x9/0xd
- [<ffffffff811126b1>] vfs_ioctl+0x21/0x34
- [<ffffffff81112f7b>] do_vfs_ioctl+0x408/0x44b
- [<ffffffff81208d45>] ? file_has_perm+0x76/0x81
- [<ffffffff8111300f>] sys_ioctl+0x51/0x76
- [<ffffffff8158db22>] system_call_fastpath+0x16/0x1b
-
-[1] http://cpansearch.perl.org/src/DPAVLIN/Biblio-RFID-0.03/examples/usbreset.c
-
-Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
-Cc: stable@vger.kernel.org
-Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
----
- net/bluetooth/hci_core.c | 2 ++
- 1 file changed, 2 insertions(+)
-
-diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
-index d4de5db..0b997c8 100644
---- a/net/bluetooth/hci_core.c
-+++ b/net/bluetooth/hci_core.c
-@@ -734,6 +734,8 @@ static int hci_dev_do_close(struct hci_dev *hdev)
- 
- 	cancel_work_sync(&hdev->le_scan);
- 
-+	cancel_delayed_work(&hdev->power_off);
-+
- 	hci_req_cancel(hdev, ENODEV);
- 	hci_req_lock(hdev);
- 
--- 
-1.7.12.1
-
diff --git a/pending-stable/0004-cfg80211-fix-possible-circular-lock-on-reg_regdb_sea.patch b/pending-stable/0004-cfg80211-fix-possible-circular-lock-on-reg_regdb_sea.patch
deleted file mode 100644
index 59c05fc..0000000
--- a/pending-stable/0004-cfg80211-fix-possible-circular-lock-on-reg_regdb_sea.patch
+++ /dev/null
@@ -1,129 +0,0 @@
-From a85d0d7f3460b1a123b78e7f7e39bf72c37dfb78 Mon Sep 17 00:00:00 2001
-From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
-Date: Fri, 14 Sep 2012 15:36:57 -0700
-Subject: [PATCH 4/9] cfg80211: fix possible circular lock on
- reg_regdb_search()
-
-When call_crda() is called we kick off a witch hunt search
-for the same regulatory domain on our internal regulatory
-database and that work gets kicked off on a workqueue, this
-is done while the cfg80211_mutex is held. If that workqueue
-kicks off it will first lock reg_regdb_search_mutex and
-later cfg80211_mutex but to ensure two CPUs will not contend
-against cfg80211_mutex the right thing to do is to have the
-reg_regdb_search() wait until the cfg80211_mutex is let go.
-
-The lockdep report is pasted below.
-
-cfg80211: Calling CRDA to update world regulatory domain
-
-======================================================
-[ INFO: possible circular locking dependency detected ]
-3.3.8 #3 Tainted: G           O
--------------------------------------------------------
-kworker/0:1/235 is trying to acquire lock:
- (cfg80211_mutex){+.+...}, at: [<816468a4>] set_regdom+0x78c/0x808 [cfg80211]
-
-but task is already holding lock:
- (reg_regdb_search_mutex){+.+...}, at: [<81646828>] set_regdom+0x710/0x808 [cfg80211]
-
-which lock already depends on the new lock.
-
-the existing dependency chain (in reverse order) is:
-
--> #2 (reg_regdb_search_mutex){+.+...}:
-       [<800a8384>] lock_acquire+0x60/0x88
-       [<802950a8>] mutex_lock_nested+0x54/0x31c
-       [<81645778>] is_world_regdom+0x9f8/0xc74 [cfg80211]
-
--> #1 (reg_mutex#2){+.+...}:
-       [<800a8384>] lock_acquire+0x60/0x88
-       [<802950a8>] mutex_lock_nested+0x54/0x31c
-       [<8164539c>] is_world_regdom+0x61c/0xc74 [cfg80211]
-
--> #0 (cfg80211_mutex){+.+...}:
-       [<800a77b8>] __lock_acquire+0x10d4/0x17bc
-       [<800a8384>] lock_acquire+0x60/0x88
-       [<802950a8>] mutex_lock_nested+0x54/0x31c
-       [<816468a4>] set_regdom+0x78c/0x808 [cfg80211]
-
-other info that might help us debug this:
-
-Chain exists of:
-  cfg80211_mutex --> reg_mutex#2 --> reg_regdb_search_mutex
-
- Possible unsafe locking scenario:
-
-       CPU0                    CPU1
-       ----                    ----
-  lock(reg_regdb_search_mutex);
-                               lock(reg_mutex#2);
-                               lock(reg_regdb_search_mutex);
-  lock(cfg80211_mutex);
-
- *** DEADLOCK ***
-
-3 locks held by kworker/0:1/235:
- #0:  (events){.+.+..}, at: [<80089a00>] process_one_work+0x230/0x460
- #1:  (reg_regdb_work){+.+...}, at: [<80089a00>] process_one_work+0x230/0x460
- #2:  (reg_regdb_search_mutex){+.+...}, at: [<81646828>] set_regdom+0x710/0x808 [cfg80211]
-
-stack backtrace:
-Call Trace:
-[<80290fd4>] dump_stack+0x8/0x34
-[<80291bc4>] print_circular_bug+0x2ac/0x2d8
-[<800a77b8>] __lock_acquire+0x10d4/0x17bc
-[<800a8384>] lock_acquire+0x60/0x88
-[<802950a8>] mutex_lock_nested+0x54/0x31c
-[<816468a4>] set_regdom+0x78c/0x808 [cfg80211]
-
-Reported-by: Felix Fietkau <nbd@openwrt.org>
-Tested-by: Felix Fietkau <nbd@openwrt.org>
-Cc: stable@vger.kernel.org
-Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
-Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- net/wireless/reg.c | 12 +++++++++---
- 1 file changed, 9 insertions(+), 3 deletions(-)
-
-diff --git a/net/wireless/reg.c b/net/wireless/reg.c
-index 2ded3c7..72d170c 100644
---- a/net/wireless/reg.c
-+++ b/net/wireless/reg.c
-@@ -350,6 +350,9 @@ static void reg_regdb_search(struct work_struct *work)
- 	struct reg_regdb_search_request *request;
- 	const struct ieee80211_regdomain *curdom, *regdom;
- 	int i, r;
-+	bool set_reg = false;
-+
-+	mutex_lock(&cfg80211_mutex);
- 
- 	mutex_lock(&reg_regdb_search_mutex);
- 	while (!list_empty(&reg_regdb_search_list)) {
-@@ -365,9 +368,7 @@ static void reg_regdb_search(struct work_struct *work)
- 				r = reg_copy_regd(&regdom, curdom);
- 				if (r)
- 					break;
--				mutex_lock(&cfg80211_mutex);
--				set_regdom(regdom);
--				mutex_unlock(&cfg80211_mutex);
-+				set_reg = true;
- 				break;
- 			}
- 		}
-@@ -375,6 +376,11 @@ static void reg_regdb_search(struct work_struct *work)
- 		kfree(request);
- 	}
- 	mutex_unlock(&reg_regdb_search_mutex);
-+
-+	if (set_reg)
-+		set_regdom(regdom);
-+
-+	mutex_unlock(&cfg80211_mutex);
- }
- 
- static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
--- 
-1.7.12.1
-
diff --git a/pending-stable/0005-iwlwifi-don-t-double-free-the-interrupt-in-failure-p.patch b/pending-stable/0005-iwlwifi-don-t-double-free-the-interrupt-in-failure-p.patch
deleted file mode 100644
index 16bad35..0000000
--- a/pending-stable/0005-iwlwifi-don-t-double-free-the-interrupt-in-failure-p.patch
+++ /dev/null
@@ -1,33 +0,0 @@
-From a7be50b7e30f9d77cb059a7ffdb781bb0fb92eba Mon Sep 17 00:00:00 2001
-From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
-Date: Tue, 18 Sep 2012 19:48:59 +0200
-Subject: [PATCH 5/9] iwlwifi: don't double free the interrupt in failure path
-
-When the driver can't get the HW ready, we would release
-the interrupt twice which made the kernel complain loudly.
-
-Cc: stable@vger.kernel.org
-Reported-by: Brian Cockrell <brian.cockrell@intel.com>
-Tested-by: Brian Cockrell <brian.cockrell@intel.com>
-Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
-Signed-off-by: Johannes Berg <johannes.berg@intel.com>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- drivers/net/wireless/iwlwifi/pcie/trans.c | 1 +
- 1 file changed, 1 insertion(+)
-
-diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
-index 1e86ea2..dbeebef 100644
---- a/drivers/net/wireless/iwlwifi/pcie/trans.c
-+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
-@@ -1442,6 +1442,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
- 	return err;
- 
- err_free_irq:
-+	trans_pcie->irq_requested = false;
- 	free_irq(trans_pcie->irq, trans);
- error:
- 	iwl_free_isr_ict(trans);
--- 
-1.7.12.1
-
diff --git a/pending-stable/0006-Bluetooth-mgmt-Implement-support-for-passkey-notific.patch b/pending-stable/0006-Bluetooth-mgmt-Implement-support-for-passkey-notific.patch
deleted file mode 100644
index 3d6b330..0000000
--- a/pending-stable/0006-Bluetooth-mgmt-Implement-support-for-passkey-notific.patch
+++ /dev/null
@@ -1,214 +0,0 @@
-From 92a25256f142d55e25f9959441cea6ddeabae57e Mon Sep 17 00:00:00 2001
-From: Johan Hedberg <johan.hedberg@intel.com>
-Date: Thu, 6 Sep 2012 18:39:26 +0300
-Subject: [PATCH 6/9] Bluetooth: mgmt: Implement support for passkey
- notification
-
-This patch adds support for Secure Simple Pairing with devices that have
-KeyboardOnly as their IO capability. Such devices will cause a passkey
-notification on our side and optionally also keypress notifications.
-Without this patch some keyboards cannot be paired using the mgmt
-interface.
-
-Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
-Cc: stable@vger.kernel.org
-Acked-by: Marcel Holtmann <marcel@holtmann.org>
-Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
----
- include/net/bluetooth/hci.h      | 18 +++++++++++
- include/net/bluetooth/hci_core.h |  5 +++
- include/net/bluetooth/mgmt.h     |  7 +++++
- net/bluetooth/hci_event.c        | 67 ++++++++++++++++++++++++++++++++++++++++
- net/bluetooth/mgmt.c             | 17 ++++++++++
- 5 files changed, 114 insertions(+)
-
-diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
-index 0f28f70..76b2b6b 100644
---- a/include/net/bluetooth/hci.h
-+++ b/include/net/bluetooth/hci.h
-@@ -1249,6 +1249,24 @@ struct hci_ev_simple_pair_complete {
- 	bdaddr_t bdaddr;
- } __packed;
- 
-+#define HCI_EV_USER_PASSKEY_NOTIFY	0x3b
-+struct hci_ev_user_passkey_notify {
-+	bdaddr_t	bdaddr;
-+	__le32		passkey;
-+} __packed;
-+
-+#define HCI_KEYPRESS_STARTED		0
-+#define HCI_KEYPRESS_ENTERED		1
-+#define HCI_KEYPRESS_ERASED		2
-+#define HCI_KEYPRESS_CLEARED		3
-+#define HCI_KEYPRESS_COMPLETED		4
-+
-+#define HCI_EV_KEYPRESS_NOTIFY		0x3c
-+struct hci_ev_keypress_notify {
-+	bdaddr_t	bdaddr;
-+	__u8		type;
-+} __packed;
-+
- #define HCI_EV_REMOTE_HOST_FEATURES	0x3d
- struct hci_ev_remote_host_features {
- 	bdaddr_t bdaddr;
-diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
-index 6a3337e..e7d4546 100644
---- a/include/net/bluetooth/hci_core.h
-+++ b/include/net/bluetooth/hci_core.h
-@@ -303,6 +303,8 @@ struct hci_conn {
- 	__u8		pin_length;
- 	__u8		enc_key_size;
- 	__u8		io_capability;
-+	__u32		passkey_notify;
-+	__u8		passkey_entered;
- 	__u16		disc_timeout;
- 	unsigned long	flags;
- 
-@@ -1022,6 +1024,9 @@ int mgmt_user_passkey_reply_complete(struct hci_dev *hdev, bdaddr_t *bdaddr,
- 				     u8 link_type, u8 addr_type, u8 status);
- int mgmt_user_passkey_neg_reply_complete(struct hci_dev *hdev, bdaddr_t *bdaddr,
- 					 u8 link_type, u8 addr_type, u8 status);
-+int mgmt_user_passkey_notify(struct hci_dev *hdev, bdaddr_t *bdaddr,
-+			     u8 link_type, u8 addr_type, u32 passkey,
-+			     u8 entered);
- int mgmt_auth_failed(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
- 		     u8 addr_type, u8 status);
- int mgmt_auth_enable_complete(struct hci_dev *hdev, u8 status);
-diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
-index 1b48eff..22980a7 100644
---- a/include/net/bluetooth/mgmt.h
-+++ b/include/net/bluetooth/mgmt.h
-@@ -478,3 +478,10 @@ struct mgmt_ev_device_unblocked {
- struct mgmt_ev_device_unpaired {
- 	struct mgmt_addr_info addr;
- } __packed;
-+
-+#define MGMT_EV_PASSKEY_NOTIFY		0x0017
-+struct mgmt_ev_passkey_notify {
-+	struct mgmt_addr_info addr;
-+	__le32	passkey;
-+	__u8	entered;
-+} __packed;
-diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
-index 48d7302..ccca88f 100644
---- a/net/bluetooth/hci_event.c
-+++ b/net/bluetooth/hci_event.c
-@@ -3263,6 +3263,65 @@ static void hci_user_passkey_request_evt(struct hci_dev *hdev,
- 		mgmt_user_passkey_request(hdev, &ev->bdaddr, ACL_LINK, 0);
- }
- 
-+static void hci_user_passkey_notify_evt(struct hci_dev *hdev,
-+					struct sk_buff *skb)
-+{
-+	struct hci_ev_user_passkey_notify *ev = (void *) skb->data;
-+	struct hci_conn *conn;
-+
-+	BT_DBG("%s", hdev->name);
-+
-+	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
-+	if (!conn)
-+		return;
-+
-+	conn->passkey_notify = __le32_to_cpu(ev->passkey);
-+	conn->passkey_entered = 0;
-+
-+	if (test_bit(HCI_MGMT, &hdev->dev_flags))
-+		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
-+					 conn->dst_type, conn->passkey_notify,
-+					 conn->passkey_entered);
-+}
-+
-+static void hci_keypress_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
-+{
-+	struct hci_ev_keypress_notify *ev = (void *) skb->data;
-+	struct hci_conn *conn;
-+
-+	BT_DBG("%s", hdev->name);
-+
-+	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
-+	if (!conn)
-+		return;
-+
-+	switch (ev->type) {
-+	case HCI_KEYPRESS_STARTED:
-+		conn->passkey_entered = 0;
-+		return;
-+
-+	case HCI_KEYPRESS_ENTERED:
-+		conn->passkey_entered++;
-+		break;
-+
-+	case HCI_KEYPRESS_ERASED:
-+		conn->passkey_entered--;
-+		break;
-+
-+	case HCI_KEYPRESS_CLEARED:
-+		conn->passkey_entered = 0;
-+		break;
-+
-+	case HCI_KEYPRESS_COMPLETED:
-+		return;
-+	}
-+
-+	if (test_bit(HCI_MGMT, &hdev->dev_flags))
-+		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
-+					 conn->dst_type, conn->passkey_notify,
-+					 conn->passkey_entered);
-+}
-+
- static void hci_simple_pair_complete_evt(struct hci_dev *hdev,
- 					 struct sk_buff *skb)
- {
-@@ -3627,6 +3686,14 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
- 		hci_user_passkey_request_evt(hdev, skb);
- 		break;
- 
-+	case HCI_EV_USER_PASSKEY_NOTIFY:
-+		hci_user_passkey_notify_evt(hdev, skb);
-+		break;
-+
-+	case HCI_EV_KEYPRESS_NOTIFY:
-+		hci_keypress_notify_evt(hdev, skb);
-+		break;
-+
- 	case HCI_EV_SIMPLE_PAIR_COMPLETE:
- 		hci_simple_pair_complete_evt(hdev, skb);
- 		break;
-diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
-index 05d4b83..8e1ab59 100644
---- a/net/bluetooth/mgmt.c
-+++ b/net/bluetooth/mgmt.c
-@@ -99,6 +99,7 @@ static const u16 mgmt_events[] = {
- 	MGMT_EV_DEVICE_BLOCKED,
- 	MGMT_EV_DEVICE_UNBLOCKED,
- 	MGMT_EV_DEVICE_UNPAIRED,
-+	MGMT_EV_PASSKEY_NOTIFY,
- };
- 
- /*
-@@ -3276,6 +3277,22 @@ int mgmt_user_passkey_neg_reply_complete(struct hci_dev *hdev, bdaddr_t *bdaddr,
- 					  MGMT_OP_USER_PASSKEY_NEG_REPLY);
- }
- 
-+int mgmt_user_passkey_notify(struct hci_dev *hdev, bdaddr_t *bdaddr,
-+			     u8 link_type, u8 addr_type, u32 passkey,
-+			     u8 entered)
-+{
-+	struct mgmt_ev_passkey_notify ev;
-+
-+	BT_DBG("%s", hdev->name);
-+
-+	bacpy(&ev.addr.bdaddr, bdaddr);
-+	ev.addr.type = link_to_bdaddr(link_type, addr_type);
-+	ev.passkey = __cpu_to_le32(passkey);
-+	ev.entered = entered;
-+
-+	return mgmt_event(MGMT_EV_PASSKEY_NOTIFY, hdev, &ev, sizeof(ev), NULL);
-+}
-+
- int mgmt_auth_failed(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
- 		     u8 addr_type, u8 status)
- {
--- 
-1.7.12.1
-
diff --git a/pending-stable/0007-Bluetooth-Update-management-interface-revision.patch b/pending-stable/0007-Bluetooth-Update-management-interface-revision.patch
deleted file mode 100644
index c8b9f90..0000000
--- a/pending-stable/0007-Bluetooth-Update-management-interface-revision.patch
+++ /dev/null
@@ -1,36 +0,0 @@
-From 23b3b1330abc643e1fbb7cfffcb6947e2583cff2 Mon Sep 17 00:00:00 2001
-From: Johan Hedberg <johan.hedberg@intel.com>
-Date: Thu, 6 Sep 2012 18:39:27 +0300
-Subject: [PATCH 7/9] Bluetooth: Update management interface revision
-
-For each kernel release where commands or events are added to the
-management interface, the revision field should be increment by one.
-
-The increment should only happen once per kernel release and not
-for every command/event that gets added. The revision value is for
-informational purposes only, but this simple policy would make any
-future debugging a lot simple.
-
-Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
-Cc: stable@vger.kernel.org
-Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
----
- net/bluetooth/mgmt.c | 2 +-
- 1 file changed, 1 insertion(+), 1 deletion(-)
-
-diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
-index 8e1ab59..8934343 100644
---- a/net/bluetooth/mgmt.c
-+++ b/net/bluetooth/mgmt.c
-@@ -35,7 +35,7 @@
- bool enable_hs;
- 
- #define MGMT_VERSION	1
--#define MGMT_REVISION	1
-+#define MGMT_REVISION	2
- 
- static const u16 mgmt_commands[] = {
- 	MGMT_OP_READ_INDEX_LIST,
--- 
-1.7.12.1
-
diff --git a/pending-stable/0008-Bluetooth-Add-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch b/pending-stable/0008-Bluetooth-Add-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch
deleted file mode 100644
index 3612b46..0000000
--- a/pending-stable/0008-Bluetooth-Add-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch
+++ /dev/null
@@ -1,31 +0,0 @@
-From ee66401bb94b1f2ce51089c341dcdd25d26ae631 Mon Sep 17 00:00:00 2001
-From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
-Date: Wed, 15 Aug 2012 01:38:11 -0300
-Subject: [PATCH 8/9] Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for
- Broadcom/Foxconn
-
-Foxconn devices has a vendor specific class of device, we will match them
-differently now.
-
-Cc: stable@vger.kernel.org
-Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
----
- drivers/bluetooth/btusb.c | 2 +-
- 1 file changed, 1 insertion(+), 1 deletion(-)
-
-diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
-index f637c25..f077f4d 100644
---- a/drivers/bluetooth/btusb.c
-+++ b/drivers/bluetooth/btusb.c
-@@ -101,7 +101,7 @@ static struct usb_device_id btusb_table[] = {
- 	{ USB_DEVICE(0x413c, 0x8197) },
- 
- 	/* Foxconn - Hon Hai */
--	{ USB_DEVICE(0x0489, 0xe033) },
-+	{ USB_VENDOR_AND_INTERFACE_INFO(0x0489, 0xff, 0x01, 0x01) },
- 
- 	{ }	/* Terminating entry */
- };
--- 
-1.7.12.1
-
diff --git a/pending-stable/0009-ath9k-Disable-ASPM-only-for-AR9285.patch b/pending-stable/0009-ath9k-Disable-ASPM-only-for-AR9285.patch
deleted file mode 100644
index 86a34ec..0000000
--- a/pending-stable/0009-ath9k-Disable-ASPM-only-for-AR9285.patch
+++ /dev/null
@@ -1,38 +0,0 @@
-From 046b6802c8d3c8a57448485513bf7291633e0fa3 Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qualcomm.com>
-Date: Sat, 22 Sep 2012 00:14:28 +0530
-Subject: [PATCH 9/9] ath9k: Disable ASPM only for AR9285
-
-Currently, ASPM is disabled for all WLAN+BT combo chipsets
-when BTCOEX is enabled. This is incorrect since the workaround
-is required only for WB195, which is a AR9285+AR3011 combo
-solution. Fix this by checking for the HW version when enabling
-the workaround.
-
-Cc: stable@vger.kernel.org
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Tested-by: Paul Stewart <pstew@chromium.org>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- drivers/net/wireless/ath/ath9k/pci.c | 5 +++--
- 1 file changed, 3 insertions(+), 2 deletions(-)
-
-diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
-index a8f6126..c0c5996 100644
---- a/drivers/net/wireless/ath/ath9k/pci.c
-+++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -128,8 +128,9 @@ static void ath_pci_aspm_init(struct ath_common *common)
- 	if (!parent)
- 		return;
- 
--	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
--		/* Bluetooth coexistance requires disabling ASPM. */
-+	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
-+	    (AR_SREV_9285(ah))) {
-+		/* Bluetooth coexistance requires disabling ASPM for AR9285. */
- 		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
- 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
- 		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);
--- 
-1.7.12.1
-
-- 
1.7.11.4

