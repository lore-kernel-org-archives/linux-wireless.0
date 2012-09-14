Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42910 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab2INPop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 11:44:45 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <mcgrof@do-not-panic.com>
CC: <linux-wireless@vger.kernel.org>
Subject: =?UTF-8?q?=5BPATCH=201/4=5D=20compat-drivers=3A=20update=20pending-stable=20patches=2E?=
Date: Fri, 14 Sep 2012 21:10:59 +0530
Message-ID: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120914_174451_885665_C9523B07)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 pending-stable/.ignore                             |    6 +
 ...g-restore-previous-behaviour-of-chan-max_.patch |   60 ----------
 .../0011-mac80211-cancel-mesh-path-timer.patch     |   30 -----
 ...ooth-Fix-legacy-pairing-with-some-devices.patch |  120 ++++++++++++++++++++
 ...ocess-pending-events-when-unregistering-n.patch |   70 ------------
 ...14-Bluetooth-Fix-using-NULL-inquiry-entry.patch |   33 ++++++
 ...-NULL-pointer-dereference-in-config_lna_g.patch |   37 ------
 ...ooth-Fix-using-a-NULL-inquiry-cache-entry.patch |   51 ++++++++
 ...et-name_state-to-unknown-when-entry-name-.patch |   32 +++++
 .../0020-ath9k-stop-btcoex-on-device-suspend.patch |   31 +++++
 ...remove-__devinit-from-the-struct-usb_devi.patch |   41 +++++++
 ...-remove-__devinit-from-the-struct-usb_dev.patch |   43 +++++++
 ...0001-ath9k-Add-PID-VID-support-for-AR1111.patch |   61 ----------
 ...able-greenfield-transmissions-as-a-workar.patch |   52 ---------
 14 files changed, 357 insertions(+), 310 deletions(-)
 delete mode 100644 pending-stable/0010-wireless-reg-restore-previous-behaviour-of-chan-max_.patch
 delete mode 100644 pending-stable/0011-mac80211-cancel-mesh-path-timer.patch
 create mode 100644 pending-stable/0013-Bluetooth-Fix-legacy-pairing-with-some-devices.patch
 delete mode 100644 pending-stable/0013-cfg80211-process-pending-events-when-unregistering-n.patch
 create mode 100644 pending-stable/0014-Bluetooth-Fix-using-NULL-inquiry-entry.patch
 delete mode 100644 pending-stable/0014-rt61pci-fix-NULL-pointer-dereference-in-config_lna_g.patch
 create mode 100644 pending-stable/0015-Bluetooth-Fix-using-a-NULL-inquiry-cache-entry.patch
 create mode 100644 pending-stable/0016-Bluetooth-Set-name_state-to-unknown-when-entry-name-.patch
 create mode 100644 pending-stable/0020-ath9k-stop-btcoex-on-device-suspend.patch
 create mode 100644 pending-stable/0021-USB-p54usb-remove-__devinit-from-the-struct-usb_devi.patch
 create mode 100644 pending-stable/0022-USB-rtl8187-remove-__devinit-from-the-struct-usb_dev.patch
 delete mode 100644 pending-stable/backports/0001-ath9k-Add-PID-VID-support-for-AR1111.patch
 delete mode 100644 pending-stable/backports/0002-iwlwifi-disable-greenfield-transmissions-as-a-workar.patch

diff --git a/pending-stable/.ignore b/pending-stable/.ignore
index beb0139..6621615 100644
--- a/pending-stable/.ignore
+++ b/pending-stable/.ignore
@@ -9,3 +9,9 @@ rtlwifi-rtl8192cu-Change-buffer-allocation-for-synch.patch
 rtlwifi-rtl8192de-Fix-phy-based-version-calculation.patch
 b43-fix-crash-with-OpenFWWF.patch
 atl1c-fix-issue-of-io-access-mode-for-AR8152-v2.1.patch
+wireless-reg-restore-previous-behaviour-of-chan-max_.patch
+mac80211-cancel-mesh-path-timer.patch
+cfg80211-process-pending-events-when-unregistering-n.patch
+rt61pci-fix-NULL-pointer-dereference-in-config_lna_g.patch
+iwlwifi-fix-flow-handler-debug-code.patch
+iwlwifi-protect-SRAM-debugfs.patch
diff --git a/pending-stable/0010-wireless-reg-restore-previous-behaviour-of-chan-max_.patch b/pending-stable/0010-wireless-reg-restore-previous-behaviour-of-chan-max_.patch
deleted file mode 100644
index f2b845d..0000000
--- a/pending-stable/0010-wireless-reg-restore-previous-behaviour-of-chan-max_.patch
+++ /dev/null
@@ -1,60 +0,0 @@
-From 5e31fc0815a4e2c72b1b495fe7a0d8f9bfb9e4b4 Mon Sep 17 00:00:00 2001
-From: Stanislaw Gruszka <sgruszka@redhat.com>
-Date: Tue, 24 Jul 2012 08:35:39 +0200
-Subject: [PATCH 10/15] wireless: reg: restore previous behaviour of
- chan->max_power calculations
-
-commit eccc068e8e84c8fe997115629925e0422a98e4de
-Author: Hong Wu <Hong.Wu@dspg.com>
-Date:   Wed Jan 11 20:33:39 2012 +0200
-
-    wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit pow
-
-changed the way we calculate chan->max_power as min(chan->max_power,
-chan->max_reg_power). That broke rt2x00 (and perhaps some other
-drivers) that do not set chan->max_power. It is not so easy to fix this
-problem correctly in rt2x00.
-
-According to commit eccc068e8 changelog, change claim only to save
-maximum regulatory power - changing setting of chan->max_power was side
-effect. This patch restore previous calculations of chan->max_power and
-do not touch chan->max_reg_power.
-
-Cc: stable@vger.kernel.org # 3.4+
-Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
-Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
-Signed-off-by: Johannes Berg <johannes.berg@intel.com>
----
- net/wireless/reg.c |   16 +++++++++++++++-
- 1 file changed, 15 insertions(+), 1 deletion(-)
-
-diff --git a/net/wireless/reg.c b/net/wireless/reg.c
-index baf5704..460af03 100644
---- a/net/wireless/reg.c
-+++ b/net/wireless/reg.c
-@@ -891,7 +891,21 @@ static void handle_channel(struct wiphy *wiphy,
- 	chan->max_antenna_gain = min(chan->orig_mag,
- 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
- 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
--	chan->max_power = min(chan->max_power, chan->max_reg_power);
-+	if (chan->orig_mpwr) {
-+		/*
-+		 * Devices that have their own custom regulatory domain
-+		 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
-+		 * passed country IE power settings.
-+		 */
-+		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-+		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
-+		    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
-+			chan->max_power = chan->max_reg_power;
-+		else
-+			chan->max_power = min(chan->orig_mpwr,
-+					      chan->max_reg_power);
-+	} else
-+		chan->max_power = chan->max_reg_power;
- }
- 
- static void handle_band(struct wiphy *wiphy,
--- 
-1.7.10.4
-
diff --git a/pending-stable/0011-mac80211-cancel-mesh-path-timer.patch b/pending-stable/0011-mac80211-cancel-mesh-path-timer.patch
deleted file mode 100644
index 2d1a894..0000000
--- a/pending-stable/0011-mac80211-cancel-mesh-path-timer.patch
+++ /dev/null
@@ -1,30 +0,0 @@
-From dd4c9260e7f23f2e951cbfb2726e468c6d30306c Mon Sep 17 00:00:00 2001
-From: Johannes Berg <johannes.berg@intel.com>
-Date: Wed, 1 Aug 2012 21:03:21 +0200
-Subject: [PATCH 11/15] mac80211: cancel mesh path timer
-
-The mesh path timer needs to be canceled when
-leaving the mesh as otherwise it could fire
-after the interface has been removed already.
-
-Cc: stable@vger.kernel.org
-Signed-off-by: Johannes Berg <johannes.berg@intel.com>
----
- net/mac80211/mesh.c |    1 +
- 1 file changed, 1 insertion(+)
-
-diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
-index d60b3d3..8557235 100644
---- a/net/mac80211/mesh.c
-+++ b/net/mac80211/mesh.c
-@@ -622,6 +622,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
- 
- 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
- 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
-+	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
- 	/*
- 	 * If the timer fired while we waited for it, it will have
- 	 * requeued the work. Now the work will be running again
--- 
-1.7.10.4
-
diff --git a/pending-stable/0013-Bluetooth-Fix-legacy-pairing-with-some-devices.patch b/pending-stable/0013-Bluetooth-Fix-legacy-pairing-with-some-devices.patch
new file mode 100644
index 0000000..195de50
--- /dev/null
+++ b/pending-stable/0013-Bluetooth-Fix-legacy-pairing-with-some-devices.patch
@@ -0,0 +1,120 @@
+From a9ea3ed9b71cc3271dd59e76f65748adcaa76422 Mon Sep 17 00:00:00 2001
+From: Szymon Janc <szymon.janc@tieto.com>
+Date: Thu, 19 Jul 2012 14:46:08 +0200
+Subject: [PATCH 13/24] Bluetooth: Fix legacy pairing with some devices
+
+Some devices e.g. some Android based phones don't do SDP search before
+pairing and cancel legacy pairing when ACL is disconnected.
+
+PIN Code Request event which changes ACL timeout to HCI_PAIRING_TIMEOUT
+is only received after remote user entered PIN.
+
+In that case no L2CAP is connected so default HCI_DISCONN_TIMEOUT
+(2 seconds) is being used to timeout ACL connection. This results in
+problems with legacy pairing as remote user has only few seconds to
+enter PIN before ACL is disconnected.
+
+Increase disconnect timeout for incomming connection to
+HCI_PAIRING_TIMEOUT if SSP is disabled and no linkey exists.
+
+To avoid keeping ACL alive for too long after SDP search set ACL
+timeout back to HCI_DISCONN_TIMEOUT when L2CAP is connected.
+
+2012-07-19 13:24:43.413521 < HCI Command: Create Connection (0x01|0x0005) plen 13
+    bdaddr 00:02:72:D6:6A:3F ptype 0xcc18 rswitch 0x01 clkoffset 0x0000
+    Packet type: DM1 DM3 DM5 DH1 DH3 DH5
+2012-07-19 13:24:43.425224 > HCI Event: Command Status (0x0f) plen 4
+    Create Connection (0x01|0x0005) status 0x00 ncmd 1
+2012-07-19 13:24:43.885222 > HCI Event: Role Change (0x12) plen 8
+    status 0x00 bdaddr 00:02:72:D6:6A:3F role 0x01
+    Role: Slave
+2012-07-19 13:24:44.054221 > HCI Event: Connect Complete (0x03) plen 11
+    status 0x00 handle 42 bdaddr 00:02:72:D6:6A:3F type ACL encrypt 0x00
+2012-07-19 13:24:44.054313 < HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
+    handle 42
+2012-07-19 13:24:44.055176 > HCI Event: Page Scan Repetition Mode Change (0x20) plen 7
+    bdaddr 00:02:72:D6:6A:3F mode 0
+2012-07-19 13:24:44.056217 > HCI Event: Max Slots Change (0x1b) plen 3
+    handle 42 slots 5
+2012-07-19 13:24:44.059218 > HCI Event: Command Status (0x0f) plen 4
+    Read Remote Supported Features (0x01|0x001b) status 0x00 ncmd 0
+2012-07-19 13:24:44.062192 > HCI Event: Command Status (0x0f) plen 4
+    Unknown (0x00|0x0000) status 0x00 ncmd 1
+2012-07-19 13:24:44.067219 > HCI Event: Read Remote Supported Features (0x0b) plen 11
+    status 0x00 handle 42
+    Features: 0xbf 0xfe 0xcf 0xfe 0xdb 0xff 0x7b 0x87
+2012-07-19 13:24:44.067248 < HCI Command: Read Remote Extended Features (0x01|0x001c) plen 3
+    handle 42 page 1
+2012-07-19 13:24:44.071217 > HCI Event: Command Status (0x0f) plen 4
+    Read Remote Extended Features (0x01|0x001c) status 0x00 ncmd 1
+2012-07-19 13:24:44.076218 > HCI Event: Read Remote Extended Features (0x23) plen 13
+    status 0x00 handle 42 page 1 max 1
+    Features: 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00
+2012-07-19 13:24:44.076249 < HCI Command: Remote Name Request (0x01|0x0019) plen 10
+    bdaddr 00:02:72:D6:6A:3F mode 2 clkoffset 0x0000
+2012-07-19 13:24:44.081218 > HCI Event: Command Status (0x0f) plen 4
+    Remote Name Request (0x01|0x0019) status 0x00 ncmd 1
+2012-07-19 13:24:44.105214 > HCI Event: Remote Name Req Complete (0x07) plen 255
+    status 0x00 bdaddr 00:02:72:D6:6A:3F name 'uw000951-0'
+2012-07-19 13:24:44.105284 < HCI Command: Authentication Requested (0x01|0x0011) plen 2
+    handle 42
+2012-07-19 13:24:44.111207 > HCI Event: Command Status (0x0f) plen 4
+    Authentication Requested (0x01|0x0011) status 0x00 ncmd 1
+2012-07-19 13:24:44.112220 > HCI Event: Link Key Request (0x17) plen 6
+    bdaddr 00:02:72:D6:6A:3F
+2012-07-19 13:24:44.112249 < HCI Command: Link Key Request Negative Reply (0x01|0x000c) plen 6
+    bdaddr 00:02:72:D6:6A:3F
+2012-07-19 13:24:44.115215 > HCI Event: Command Complete (0x0e) plen 10
+    Link Key Request Negative Reply (0x01|0x000c) ncmd 1
+    status 0x00 bdaddr 00:02:72:D6:6A:3F
+2012-07-19 13:24:44.116215 > HCI Event: PIN Code Request (0x16) plen 6
+    bdaddr 00:02:72:D6:6A:3F
+2012-07-19 13:24:48.099184 > HCI Event: Auth Complete (0x06) plen 3
+    status 0x13 handle 42
+    Error: Remote User Terminated Connection
+2012-07-19 13:24:48.179182 > HCI Event: Disconn Complete (0x05) plen 4
+    status 0x00 handle 42 reason 0x13
+    Reason: Remote User Terminated Connection
+
+Cc: stable@vger.kernel.org
+Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
+Acked-by: Johan Hedberg <johan.hedberg@intel.com>
+Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
+---
+ net/bluetooth/hci_event.c  | 7 ++++++-
+ net/bluetooth/l2cap_core.c | 1 +
+ 2 files changed, 7 insertions(+), 1 deletion(-)
+
+diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
+index 41ff978..248632c 100644
+--- a/net/bluetooth/hci_event.c
++++ b/net/bluetooth/hci_event.c
+@@ -1762,7 +1762,12 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
+ 		if (conn->type == ACL_LINK) {
+ 			conn->state = BT_CONFIG;
+ 			hci_conn_hold(conn);
+-			conn->disc_timeout = HCI_DISCONN_TIMEOUT;
++
++			if (!conn->out && !hci_conn_ssp_enabled(conn) &&
++			    !hci_find_link_key(hdev, &ev->bdaddr))
++				conn->disc_timeout = HCI_PAIRING_TIMEOUT;
++			else
++				conn->disc_timeout = HCI_DISCONN_TIMEOUT;
+ 		} else
+ 			conn->state = BT_CONNECTED;
+ 
+diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
+index a8964db..daa149b 100644
+--- a/net/bluetooth/l2cap_core.c
++++ b/net/bluetooth/l2cap_core.c
+@@ -1181,6 +1181,7 @@ static void l2cap_le_conn_ready(struct l2cap_conn *conn)
+ 	sk = chan->sk;
+ 
+ 	hci_conn_hold(conn->hcon);
++	conn->hcon->disc_timeout = HCI_DISCONN_TIMEOUT;
+ 
+ 	bacpy(&bt_sk(sk)->src, conn->src);
+ 	bacpy(&bt_sk(sk)->dst, conn->dst);
+-- 
+1.7.11.4
+
diff --git a/pending-stable/0013-cfg80211-process-pending-events-when-unregistering-n.patch b/pending-stable/0013-cfg80211-process-pending-events-when-unregistering-n.patch
deleted file mode 100644
index a7d66ec..0000000
--- a/pending-stable/0013-cfg80211-process-pending-events-when-unregistering-n.patch
+++ /dev/null
@@ -1,70 +0,0 @@
-From 1f6fc43e621167492ed4b7f3b4269c584c3d6ccc Mon Sep 17 00:00:00 2001
-From: Daniel Drake <dsd@laptop.org>
-Date: Thu, 2 Aug 2012 18:41:48 +0100
-Subject: [PATCH 13/15] cfg80211: process pending events when unregistering
- net device
-
-libertas currently calls cfg80211_disconnected() when it is being
-brought down. This causes an event to be allocated, but since the
-wdev is already removed from the rdev by the time that the event
-processing work executes, the event is never processed or freed.
-http://article.gmane.org/gmane.linux.kernel.wireless.general/95666
-
-Fix this leak, and other possible situations, by processing the event
-queue when a device is being unregistered. Thanks to Johannes Berg for
-the suggestion.
-
-Signed-off-by: Daniel Drake <dsd@laptop.org>
-Cc: stable@vger.kernel.org
-Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- net/wireless/core.c |    5 +++++
- net/wireless/core.h |    1 +
- net/wireless/util.c |    2 +-
- 3 files changed, 7 insertions(+), 1 deletion(-)
-
-diff --git a/net/wireless/core.c b/net/wireless/core.c
-index 31b40cc..dcd64d5 100644
---- a/net/wireless/core.c
-+++ b/net/wireless/core.c
-@@ -952,6 +952,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
- 		 */
- 		synchronize_rcu();
- 		INIT_LIST_HEAD(&wdev->list);
-+		/*
-+		 * Ensure that all events have been processed and
-+		 * freed.
-+		 */
-+		cfg80211_process_wdev_events(wdev);
- 		break;
- 	case NETDEV_PRE_UP:
- 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
-diff --git a/net/wireless/core.h b/net/wireless/core.h
-index 5206c68..bc7430b 100644
---- a/net/wireless/core.h
-+++ b/net/wireless/core.h
-@@ -426,6 +426,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
- 			  struct net_device *dev, enum nl80211_iftype ntype,
- 			  u32 *flags, struct vif_params *params);
- void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
-+void cfg80211_process_wdev_events(struct wireless_dev *wdev);
- 
- int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
- 				 struct wireless_dev *wdev,
-diff --git a/net/wireless/util.c b/net/wireless/util.c
-index 26f8cd3..994e2f0 100644
---- a/net/wireless/util.c
-+++ b/net/wireless/util.c
-@@ -735,7 +735,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
- 	wdev->connect_keys = NULL;
- }
- 
--static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
-+void cfg80211_process_wdev_events(struct wireless_dev *wdev)
- {
- 	struct cfg80211_event *ev;
- 	unsigned long flags;
--- 
-1.7.10.4
-
diff --git a/pending-stable/0014-Bluetooth-Fix-using-NULL-inquiry-entry.patch b/pending-stable/0014-Bluetooth-Fix-using-NULL-inquiry-entry.patch
new file mode 100644
index 0000000..35f9eee
--- /dev/null
+++ b/pending-stable/0014-Bluetooth-Fix-using-NULL-inquiry-entry.patch
@@ -0,0 +1,33 @@
+From c810089c27e48b816181b454fcc493d19fdbc2ba Mon Sep 17 00:00:00 2001
+From: Ram Malovany <ramm@ti.com>
+Date: Thu, 19 Jul 2012 10:26:09 +0300
+Subject: [PATCH 14/24] Bluetooth: Fix using NULL inquiry entry
+
+If entry wasn't found in the hci_inquiry_cache_lookup_resolve do not
+resolve the name.This will fix a kernel crash when trying to use NULL
+pointer.
+
+Cc: stable@vger.kernel.org
+Signed-off-by: Ram Malovany <ramm@ti.com>
+Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
+---
+ net/bluetooth/hci_event.c | 3 +++
+ 1 file changed, 3 insertions(+)
+
+diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
+index 248632c..b64cfa2 100644
+--- a/net/bluetooth/hci_event.c
++++ b/net/bluetooth/hci_event.c
+@@ -1365,6 +1365,9 @@ static bool hci_resolve_next_name(struct hci_dev *hdev)
+ 		return false;
+ 
+ 	e = hci_inquiry_cache_lookup_resolve(hdev, BDADDR_ANY, NAME_NEEDED);
++	if (!e)
++		return false;
++
+ 	if (hci_resolve_name(hdev, e) == 0) {
+ 		e->name_state = NAME_PENDING;
+ 		return true;
+-- 
+1.7.11.4
+
diff --git a/pending-stable/0014-rt61pci-fix-NULL-pointer-dereference-in-config_lna_g.patch b/pending-stable/0014-rt61pci-fix-NULL-pointer-dereference-in-config_lna_g.patch
deleted file mode 100644
index a79f26f..0000000
--- a/pending-stable/0014-rt61pci-fix-NULL-pointer-dereference-in-config_lna_g.patch
+++ /dev/null
@@ -1,37 +0,0 @@
-From deee0214def5d8a32b8112f11d9c2b1696e9c0cb Mon Sep 17 00:00:00 2001
-From: Stanislaw Gruszka <sgruszka@redhat.com>
-Date: Fri, 3 Aug 2012 12:49:14 +0200
-Subject: [PATCH 14/15] rt61pci: fix NULL pointer dereference in
- config_lna_gain
-
-We can not pass NULL libconf->conf->channel to rt61pci_config() as it
-is dereferenced unconditionally in rt61pci_config_lna_gain() subroutine.
-
-Resolves:
-https://bugzilla.kernel.org/show_bug.cgi?id=44361
-
-Cc: stable@vger.kernel.org
-Reported-and-tested-by: <dolohow@gmail.com>
-Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- drivers/net/wireless/rt2x00/rt61pci.c |    3 +--
- 1 file changed, 1 insertion(+), 2 deletions(-)
-
-diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
-index f322596..3f7bc5c 100644
---- a/drivers/net/wireless/rt2x00/rt61pci.c
-+++ b/drivers/net/wireless/rt2x00/rt61pci.c
-@@ -2243,8 +2243,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
- 
- static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
- {
--	struct ieee80211_conf conf = { .flags = 0 };
--	struct rt2x00lib_conf libconf = { .conf = &conf };
-+	struct rt2x00lib_conf libconf = { .conf = &rt2x00dev->hw->conf };
- 
- 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
- }
--- 
-1.7.10.4
-
diff --git a/pending-stable/0015-Bluetooth-Fix-using-a-NULL-inquiry-cache-entry.patch b/pending-stable/0015-Bluetooth-Fix-using-a-NULL-inquiry-cache-entry.patch
new file mode 100644
index 0000000..13d6d8a
--- /dev/null
+++ b/pending-stable/0015-Bluetooth-Fix-using-a-NULL-inquiry-cache-entry.patch
@@ -0,0 +1,51 @@
+From 7cc8380eb10347016d95bf6f9d842c2ae6d12932 Mon Sep 17 00:00:00 2001
+From: Ram Malovany <ramm@ti.com>
+Date: Thu, 19 Jul 2012 10:26:10 +0300
+Subject: [PATCH 15/24] Bluetooth: Fix using a NULL inquiry cache entry
+
+If the device was not found in a list of found devices names of which
+are pending.This may happen in a case when HCI Remote Name Request
+was sent as a part of incoming connection establishment procedure.
+Hence there is no need to continue resolving a next name as it will
+be done upon receiving another Remote Name Request Complete Event.
+This will fix a kernel crash when trying to use this entry to resolve
+the next name.
+
+Cc: stable@vger.kernel.org
+Signed-off-by: Ram Malovany <ramm@ti.com>
+Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
+---
+ net/bluetooth/hci_event.c | 16 +++++++++++-----
+ 1 file changed, 11 insertions(+), 5 deletions(-)
+
+diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
+index b64cfa2..fe9a3d6 100644
+--- a/net/bluetooth/hci_event.c
++++ b/net/bluetooth/hci_event.c
+@@ -1396,12 +1396,18 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
+ 		return;
+ 
+ 	e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
+-	if (e) {
++	/* If the device was not found in a list of found devices names of which
++	 * are pending. there is no need to continue resolving a next name as it
++	 * will be done upon receiving another Remote Name Request Complete
++	 * Event */
++	if (!e)
++		return;
++
++	list_del(&e->list);
++	if (name) {
+ 		e->name_state = NAME_KNOWN;
+-		list_del(&e->list);
+-		if (name)
+-			mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
+-					 e->data.rssi, name, name_len);
++		mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
++				 e->data.rssi, name, name_len);
+ 	}
+ 
+ 	if (hci_resolve_next_name(hdev))
+-- 
+1.7.11.4
+
diff --git a/pending-stable/0016-Bluetooth-Set-name_state-to-unknown-when-entry-name-.patch b/pending-stable/0016-Bluetooth-Set-name_state-to-unknown-when-entry-name-.patch
new file mode 100644
index 0000000..98d89dc
--- /dev/null
+++ b/pending-stable/0016-Bluetooth-Set-name_state-to-unknown-when-entry-name-.patch
@@ -0,0 +1,32 @@
+From c3e7c0d90b14a3e7ac091d24cef09efb516d587b Mon Sep 17 00:00:00 2001
+From: Ram Malovany <ramm@ti.com>
+Date: Thu, 19 Jul 2012 10:26:11 +0300
+Subject: [PATCH 16/24] Bluetooth: Set name_state to unknown when entry name
+ is empty
+
+When the name of the given entry is empty , the state needs to be
+updated accordingly.
+
+Cc: stable@vger.kernel.org
+Signed-off-by: Ram Malovany <ramm@ti.com>
+Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
+---
+ net/bluetooth/hci_event.c | 2 ++
+ 1 file changed, 2 insertions(+)
+
+diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
+index fe9a3d6..715d7e3 100644
+--- a/net/bluetooth/hci_event.c
++++ b/net/bluetooth/hci_event.c
+@@ -1408,6 +1408,8 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
+ 		e->name_state = NAME_KNOWN;
+ 		mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
+ 				 e->data.rssi, name, name_len);
++	} else {
++		e->name_state = NAME_NOT_KNOWN;
+ 	}
+ 
+ 	if (hci_resolve_next_name(hdev))
+-- 
+1.7.11.4
+
diff --git a/pending-stable/0020-ath9k-stop-btcoex-on-device-suspend.patch b/pending-stable/0020-ath9k-stop-btcoex-on-device-suspend.patch
new file mode 100644
index 0000000..34923aa
--- /dev/null
+++ b/pending-stable/0020-ath9k-stop-btcoex-on-device-suspend.patch
@@ -0,0 +1,31 @@
+From e19f15ac6437624b6214b2f0ec0d69fb7eb205fa Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Thu, 9 Aug 2012 12:37:26 +0530
+Subject: [PATCH 20/24] ath9k: stop btcoex on device suspend
+
+During suspend, the device will be moved to FULLSLEEP state.
+As btcoex is never been stopped, the btcoex timer is running
+and tries to access hw on fullsleep state. Fix that.
+
+Cc: stable@vger.kernel.org
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/pci.c | 1 +
+ 1 file changed, 1 insertion(+)
+
+diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
+index d455de9..a978984 100644
+--- a/drivers/net/wireless/ath/ath9k/pci.c
++++ b/drivers/net/wireless/ath/ath9k/pci.c
+@@ -321,6 +321,7 @@ static int ath_pci_suspend(struct device *device)
+ 	 * Otherwise the chip never moved to full sleep,
+ 	 * when no interface is up.
+ 	 */
++	ath9k_stop_btcoex(sc);
+ 	ath9k_hw_disable(sc->sc_ah);
+ 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+ 
+-- 
+1.7.11.4
+
diff --git a/pending-stable/0021-USB-p54usb-remove-__devinit-from-the-struct-usb_devi.patch b/pending-stable/0021-USB-p54usb-remove-__devinit-from-the-struct-usb_devi.patch
new file mode 100644
index 0000000..c39d33c
--- /dev/null
+++ b/pending-stable/0021-USB-p54usb-remove-__devinit-from-the-struct-usb_devi.patch
@@ -0,0 +1,41 @@
+From b9c4167cbbafddac3462134013bc15e63e4c53ef Mon Sep 17 00:00:00 2001
+From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+Date: Fri, 17 Aug 2012 17:48:28 -0700
+Subject: [PATCH 21/24] USB: p54usb: remove __devinit* from the struct
+ usb_device_id table
+MIME-Version: 1.0
+Content-Type: text/plain; charset=UTF-8
+Content-Transfer-Encoding: 8bit
+
+This structure needs to always stick around, even if CONFIG_HOTPLUG
+is disabled, otherwise we can oops when trying to probe a device that
+was added after the structure is thrown away.
+
+Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.
+
+Reported-by: Fengguang Wu <fengguang.wu@intel.com>
+Reported-by: Bjørn Mork <bjorn@mork.no>
+Cc: stable <stable@vger.kernel.org>
+CC: Christian Lamparter <chunkeey@googlemail.com>
+CC: "John W. Linville" <linville@tuxdriver.com>
+Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+---
+ drivers/net/wireless/p54/p54usb.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
+index 7f207b6..effb044 100644
+--- a/drivers/net/wireless/p54/p54usb.c
++++ b/drivers/net/wireless/p54/p54usb.c
+@@ -42,7 +42,7 @@ MODULE_FIRMWARE("isl3887usb");
+  * whenever you add a new device.
+  */
+ 
+-static struct usb_device_id p54u_table[] __devinitdata = {
++static struct usb_device_id p54u_table[] = {
+ 	/* Version 1 devices (pci chip + net2280) */
+ 	{USB_DEVICE(0x0411, 0x0050)},	/* Buffalo WLI2-USB2-G54 */
+ 	{USB_DEVICE(0x045e, 0x00c2)},	/* Microsoft MN-710 */
+-- 
+1.7.11.4
+
diff --git a/pending-stable/0022-USB-rtl8187-remove-__devinit-from-the-struct-usb_dev.patch b/pending-stable/0022-USB-rtl8187-remove-__devinit-from-the-struct-usb_dev.patch
new file mode 100644
index 0000000..84a25a4
--- /dev/null
+++ b/pending-stable/0022-USB-rtl8187-remove-__devinit-from-the-struct-usb_dev.patch
@@ -0,0 +1,43 @@
+From a3433179d0822ccfa8e80aa4d1d52843bd2dcc63 Mon Sep 17 00:00:00 2001
+From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+Date: Fri, 17 Aug 2012 17:48:29 -0700
+Subject: [PATCH 22/24] USB: rtl8187: remove __devinit* from the struct
+ usb_device_id table
+MIME-Version: 1.0
+Content-Type: text/plain; charset=UTF-8
+Content-Transfer-Encoding: 8bit
+
+This structure needs to always stick around, even if CONFIG_HOTPLUG
+is disabled, otherwise we can oops when trying to probe a device that
+was added after the structure is thrown away.
+
+Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.
+
+Reported-by: Fengguang Wu <fengguang.wu@intel.com>
+Reported-by: Bjørn Mork <bjorn@mork.no>
+Cc: stable <stable@vger.kernel.org>
+CC: Herton Ronaldo Krzesinski <herton@canonical.com>
+CC: Hin-Tak Leung <htl10@users.sourceforge.net>
+CC: Larry Finger <Larry.Finger@lwfinger.net>
+CC: "John W. Linville" <linville@tuxdriver.com>
+Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+---
+ drivers/net/wireless/rtl818x/rtl8187/dev.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
+index 71a30b0..5330240 100644
+--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
++++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
+@@ -44,7 +44,7 @@ MODULE_AUTHOR("Larry Finger <Larry.Finger@lwfinger.net>");
+ MODULE_DESCRIPTION("RTL8187/RTL8187B USB wireless driver");
+ MODULE_LICENSE("GPL");
+ 
+-static struct usb_device_id rtl8187_table[] __devinitdata = {
++static struct usb_device_id rtl8187_table[] = {
+ 	/* Asus */
+ 	{USB_DEVICE(0x0b05, 0x171d), .driver_info = DEVICE_RTL8187},
+ 	/* Belkin */
+-- 
+1.7.11.4
+
diff --git a/pending-stable/backports/0001-ath9k-Add-PID-VID-support-for-AR1111.patch b/pending-stable/backports/0001-ath9k-Add-PID-VID-support-for-AR1111.patch
deleted file mode 100644
index ef2a9b6..0000000
--- a/pending-stable/backports/0001-ath9k-Add-PID-VID-support-for-AR1111.patch
+++ /dev/null
@@ -1,61 +0,0 @@
-From d4e5979c0da95791aa717c18e162540c7a596360 Mon Sep 17 00:00:00 2001
-From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
-Date: Thu, 2 Aug 2012 11:58:50 +0530
-Subject: [PATCH 12/15] ath9k: Add PID/VID support for AR1111
-
-AR1111 is same as AR9485. The h/w
-difference between them is quite insignificant,
-Felix suggests only very few baseband features
-may not be available in AR1111. The h/w code for
-AR9485 is already present, so AR1111 should
-work fine with the addition of its PID/VID.
-
-Cc: stable@vger.kernel.org [2.6.39+]
-Cc: Felix Bitterli <felixb@qca.qualcomm.com>
-Reported-by: Tim Bentley <Tim.Bentley@Gmail.com>
-Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
-Tested-by: Tim Bentley <Tim.Bentley@Gmail.com>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- drivers/net/wireless/ath/ath9k/hw.c  |    1 +
- drivers/net/wireless/ath/ath9k/hw.h  |    1 +
- drivers/net/wireless/ath/ath9k/pci.c |    1 +
- 3 files changed, 3 insertions(+)
-
-diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
-index cfa91ab..60b6a9d 100644
---- a/drivers/net/wireless/ath/ath9k/hw.c
-+++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -730,6 +730,7 @@ int ath9k_hw_init(struct ath_hw *ah)
- 	case AR9300_DEVID_QCA955X:
- 	case AR9300_DEVID_AR9580:
- 	case AR9300_DEVID_AR9462:
-+	case AR9485_DEVID_AR1111:
- 		break;
- 	default:
- 		if (common->bus_ops->ath_bus_type == ATH_USB)
---- a/drivers/net/wireless/ath/ath9k/hw.h
-+++ b/drivers/net/wireless/ath/ath9k/hw.h
-@@ -48,6 +48,7 @@
- #define AR9300_DEVID_AR9580	0x0033
- #define AR9300_DEVID_AR9462	0x0034
- #define AR9300_DEVID_AR9330	0x0035
-+#define AR9485_DEVID_AR1111	0x0037
- 
- #define AR5416_AR9100_DEVID	0x000b
- 
-diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
-index 87b89d5..d455de9 100644
---- a/drivers/net/wireless/ath/ath9k/pci.c
-+++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -37,6 +37,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
- 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
- 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
- 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
-+	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
- 	{ 0 }
- };
- 
--- 
-1.7.10.4
-
diff --git a/pending-stable/backports/0002-iwlwifi-disable-greenfield-transmissions-as-a-workar.patch b/pending-stable/backports/0002-iwlwifi-disable-greenfield-transmissions-as-a-workar.patch
deleted file mode 100644
index 532fbaf..0000000
--- a/pending-stable/backports/0002-iwlwifi-disable-greenfield-transmissions-as-a-workar.patch
+++ /dev/null
@@ -1,52 +0,0 @@
-From 50e2a30cf6fcaeb2d27360ba614dd169a10041c5 Mon Sep 17 00:00:00 2001
-From: Johannes Berg <johannes.berg@intel.com>
-Date: Sun, 5 Aug 2012 18:31:46 +0200
-Subject: [PATCH 15/15] iwlwifi: disable greenfield transmissions as a
- workaround
-
-There's a bug that causes the rate scaling to get stuck
-when it has to use single-stream rates with a peer that
-can do GF and SGI; the two are incompatible so we can't
-use them together, but that causes the algorithm to not
-work at all, it always rejects updates.
-
-Disable greenfield for now to prevent that problem.
-
-Backported to v3.5 by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
-
-Cc: stable@vger.kernel.org
-Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
-Tested-by: Cesar Eduardo Barros <cesarb@cesarb.net>
-Signed-off-by: Johannes Berg <johannes.berg@intel.com>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- drivers/net/wireless/iwlwifi/dvm/rs.c |   13 ++++++++-----
- 1 file changed, 8 insertions(+), 5 deletions(-)
-
-diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
-index 6fddd27..a82f46c 100644
---- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
-+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
-@@ -707,11 +707,14 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
-  */
- static bool rs_use_green(struct ieee80211_sta *sta)
- {
--	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
--	struct iwl_rxon_context *ctx = sta_priv->ctx;
--
--	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
--		!(ctx->ht.non_gf_sta_present);
-+	/*
-+	 * There's a bug somewhere in this code that causes the
-+	 * scaling to get stuck because GF+SGI can't be combined
-+	 * in SISO rates. Until we find that bug, disable GF, it
-+	 * has only limited benefit and we still interoperate with
-+	 * GF APs since we can always receive GF transmissions.
-+	 */
-+	return false;
- }
- 
- /**
--- 
-1.7.10.4
-
-- 
1.7.4.1

