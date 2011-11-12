Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63667 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1KLHaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 02:30:24 -0500
Message-ID: <4EBE208A.1090907@qca.qualcomm.com> (sfid-20111112_083035_656887_D8C57CA8)
Date: Sat, 12 Nov 2011 09:30:18 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Pull request: ath6kl 20111112
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's the first pull request for Linux 3.3. There are quite a lot of
patches here. Notable features are better suspend support with wow (from
me and Raja), multivif support (from Vasanth) and additions to debugfs
to ease testing of the driver. And naturally some fixes and cleanups as
well.

I was pondering if I should rebase my ath6kl-next branch or not. Finally
I ended up rebasing it as there were some conflicts with wireless-next,
so you should get a clean pull now. Let me know if there are any problems.

Kalle

The following changes since commit 1eb54c8a0fa0061247f3bd327b320c3e20c97340:

  mwifiex: prevent corruption instead of just warning (2011-11-09
16:14:13 -0500)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Aarthi Thiruvengadam (2):
      ath6kl: add support for WPS
      ath6kl: fix missing copy of action frame contents

Chilam Ng (1):
      ath6kl: make sure WLAN power save is enabled during suspend

Jouni Malinen (10):
      ath6kl: Add endpoint_stats debugfs file
      ath6kl: Add debugfs file for target roam table
      ath6kl: Add debugfs files for roaming control
      ath6kl: Add debugfs control for keepalive and disconnection timeout
      ath6kl: Allow CCKM AKM and KRK to be configured
      ath6kl: Fix endpoint_stats debugfs buffer length calculation
      ath6kl: Report unique remain-on-channel cookie values
      ath6kl: Remove unused WMI crypto defines
      ath6kl: Fix key configuration to copy at most seq_len from seq
      ath6kl: Do not hide ath6kl_wmi_addkey_cmd() error values

Kalle Valo (46):
      ath6kl: remove unused parameters from struct wmi
      ath6kl: fix struct host_app_area endian handling
      ath6kl: return error block size is not power of 2
      ath6kl: move htc_hif to hif.c
      ath6kl: remove unused values from htc_hif.h
      ath6kl: move remaining content from htc_hif.h to hif.h
      ath6kl: fix null skb dereference in ath6kl_rx()
      ath6kl: fix firmware start address for ar6003 hw2.0
      ath6kl: merge htc debug levels
      ath6kl: cleanup htc debug messages
      ath6kl: don't dump full htc packets
      ath6kl: add debug level for hif
      ath6kl: remove unused A_CACHE_LINE_PAD
      ath6kl: use ath6kl prefix in credit functions
      ath6kl: rename struct htc_endpoint_credit_dist.htc_rsvd to htc_ep
      ath6kl: rename struct htc_credit_state_info to ath6kl_htc_credit_info
      ath6kl: move all credit distribution code to htc.c
      ath6kl: use ath6kl_credit prefix consistently
      ath6kl: remove unused debug levels
      ath6kl: add debug messages for credit handling
      ath6kl: add more boot debug messages
      ath6kl: don't use cfg80211_scan_request after cfg80211_scan_done()
      ath6kl: rename ath6kl_wmi_qos_state_init() to _wmi_reset()
      ath6kl: move power control from sdio to core
      ath6kl: add a fixme to ath6kl_htc_wait_target()
      ath6kl: merge ath6kl_init() to ath6kl_core_init()
      ath6kl: separate hardware boot code from module initialisation code
      ath6kl: remove useless cleanup call from ath6kl_bmi_done()
      ath6kl: add a timeout to ath6kl_hif_intr_bh_handler()
      ath6kl: create ath6kl_htc_reset()
      ath6kl: don't print an error for canceled packets
      ath6kl: change name of sdio driver to ath6kl
      ath6kl: create ath6kl_hif_stop()
      ath6kl: power down hardware when interface is down
      ath6kl: fix WLAN_ENABLE usage in ath6kl_close()
      ath6kl: print firmware crashes always
      ath6kl: print seqno in htc debug logs
      ath6kl: add aborted parameter to ath6kl_cfg80211_scan_complete_event()
      ath6kl: create ath6kl_cfg80211_stop()
      ath6kl: reset CONNECT_PEND and CONNECTED flags in
ath6kl_cfg80211_stop()
      ath6kl: implement ath6kl_cfg80211_suspend()
      ath6kl: add state variable depicting hw/fw state
      ath6kl: refactor sdio configuration to a separate function
      ath6kl: cut power during suspend
      ath6kl: don't power down hardware when interface is down
      ath6kl: add suspend_cutpower module parameter

Kevin Fang (1):
      ath6kl: Add WSC IE on the associate message

Raja Mani (11):
      ath6kl: Add wmi functions to add/delete WOW patterns
      ath6kl: Add wmi functions to configure WOW mode and host sleep mode
      ath6kl: Add WOW suspend/resume implementation
      ath6kl: Include new parameter in suspend path for wowlan
      ath6kl: Add new state for WOW mode
      ath6kl: Move ath6kl_cfg80211_stop() call specific to deep sleep
and cut pwr
      ath6kl: Invoke WOW suspend/resume calls during PM operation
      ath6kl: Perform WOW resume in RX path in case of SDIO IRQ wake up
      ath6kl: Remove WARN_ON msg in Suspend path
      ath6kl: Expose ath6kl's WOW capabilities to cfg80211
      ath6kl: Remove few unused WMI stuff

Rishi Panjwani (4):
      ath6kl: Implement support for QOS-enable and QOS-disable from
userspace
      ath6kl: Implement support for background scan control from userspace
      ath6kl: Implement support for listen interval from userspace
      ath6kl: Implement support for power parameter control from userspace

Sam Leffler (1):
      ath6kl: unbreak suspend

Sangwook Lee (1):
      ath6kl: Fix compilation error from of.h

Vasanthakumar Thiagarajan (42):
      ath6kl: Enable force foreground scan in connected state
      ath6kl: Fix sparse warning "symbol 'conn' shadows an earlier one"
      ath6kl: Replace spin_lock_irqsave with spin_lock_bh
      ath6kl: Claim sdio function only at appropriate places
      ath6kl: Fix htc_packet leak in ath6kl_htc_rx_process_packets()
      ath6kl: Fix htc_packet leak in ath6kl_htc_rx_fetch()
      ath6kl: Avoid processing failed rx packets
      ath6kl: Minor cleanup in msg_look_ahead parameter in
ath6kl_htc_rxmsg_pending_handler()
      ath6kl: Pass ath6kl structure to ath6kl_init() instead of net_device
      ath6kl: Keep wiphy reference in ath6kl structure
      ath6kl: Refactor wiphy dev and net dev init functions
      ath6kl: Cleanup fw interface type setting
      ath6kl: Define an initial vif structure and use it
      ath6kl: Define interface specific states
      ath6kl: Move ssid and crypto information to vif structure
      ath6kl: Move nw_type to vif structure
      ath6kl: Move bssid information to vif structure
      ath6kl: Move channel information to vif structure
      ath6kl: Move key information to vif structure
      ath6kl: Move aggregation information to vif structure
      ath6kl: Move disconnect timer to vif structure
      ath6kl: Move scan_req info and sme_state to vif
      ath6kl: Move few more vif specific information to struct ath6kl_vif
      ath6kl: Make net and target stats vif specific
      ath6kl: Maintain firmware interface index in struct ath6kl_vif
      ath6kl: Take vif information from wmi event
      ath6kl: Remove net_device from ath6kl
      ath6kl: Cleanup parameters in ath6kl_init_control_info() and
ath6kl_init_profile_info()
      ath6kl: Refactor ath6kl_destroy()
      ath6kl: Use interface index from wmi data headr
      ath6kl: Store hw mac address in struct ath6kl
      ath6kl: Introduce spinlock to protect vif specific information
      ath6kl: Maintain virtual interface in a list
      ath6kl: Use the other variant of netdev (un)register APIs
      ath6kl: Configure inteface information at init time
      ath6kl: Implement add_virtual_intf() and del_virtual_intf()
      ath6kl: Add a modparam to enable multi normal interface support
      ath6kl: Initialize target wlan values for every vif
      ath6kl: Use appropriate wdev from vif
      ath6kl: Fix lockdep warning
      ath6kl: Fix tx packet drop in AP mode with bridge
      ath6kl: Fix error in writing create_qos debugfs

 drivers/net/wireless/ath/ath6kl/Makefile           |    2 +-
 drivers/net/wireless/ath/ath6kl/bmi.c              |    7 +-
 drivers/net/wireless/ath/ath6kl/bmi.h              |    2 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 1428
+++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/cfg80211.h         |   30 +-
 drivers/net/wireless/ath/ath6kl/common.h           |   16 +-
 drivers/net/wireless/ath/ath6kl/core.h             |  202 ++--
 drivers/net/wireless/ath/ath6kl/debug.c            |  849 +++++++++++-
 drivers/net/wireless/ath/ath6kl/debug.h            |   34 +-
 drivers/net/wireless/ath/ath6kl/hif-ops.h          |   49 +-
 .../net/wireless/ath/ath6kl/{htc_hif.c => hif.c}   |  150 ++-
 drivers/net/wireless/ath/ath6kl/hif.h              |   61 +-
 drivers/net/wireless/ath/ath6kl/htc.c              |  725 +++++++---
 drivers/net/wireless/ath/ath6kl/htc.h              |   18 +-
 drivers/net/wireless/ath/ath6kl/htc_hif.h          |   92 --
 drivers/net/wireless/ath/ath6kl/init.c             |  675 +++++-----
 drivers/net/wireless/ath/ath6kl/main.c             |  668 +++-------
 drivers/net/wireless/ath/ath6kl/sdio.c             |  335 ++++--
 drivers/net/wireless/ath/ath6kl/target.h           |    3 +
 drivers/net/wireless/ath/ath6kl/txrx.c             |  221 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c              |  688 +++++++---
 drivers/net/wireless/ath/ath6kl/wmi.h              |  243 +++--
 22 files changed, 4338 insertions(+), 2160 deletions(-)
 rename drivers/net/wireless/ath/ath6kl/{htc_hif.c => hif.c} (80%)
 delete mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.h
