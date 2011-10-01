Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57612 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1JAKND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 06:13:03 -0400
Message-ID: <4E86E7A9.9070909@qca.qualcomm.com> (sfid-20111001_121319_643216_7393B911)
Date: Sat, 1 Oct 2011 13:12:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Pull request: ath6kl 20111001
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a pretty big pull request from ath6kl.git. I was supposed to send
this already earlier, but I wanted to have a fix for an important TCP
corruption bug first. Even there are quite a few changes, I still ask
you to consider this for the 3.2 release. It has received extensive
testing and we have fixed a bunch of bugs from the current version in
wireless-next.

New features are:

o AP and P2P support
o support of soon to be released new firmware
o debugfs files to retrieve various stats and fw logs
o beginnings of AR6004 support, not finished yet
o notify user space that ath6kl manages intra-ESS roaming

And also a lot of code cleanup and bugfixes.

John, when you pull please note that there's a cfg80211 API change which
affects ath6kl_mgmt_tx(). As I wasn't sure should I merge wireless-next
and fix the API change in ath6kl.git so I decided not to do that. But if
you want me to do it, please let me know and I can send you a new pull
request.

Here's a diff what needs to be changed, thanks to Rajkumar Manoharan:

--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1730,7 +1730,7 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy,
struct net_device *dev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, u64 *cookie)
+			  const u8 *buf, size_t len, bool no_cck, u64 *cookie)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	u32 id;

Also note that I had to merge wireless-next at one point to get
WIPHY_FLAG_SUPPORTS_FW_ROAM. Please check that I didn't do anything
stupid with that one.

Kalle

The following changes since commit 49a59543eb5a5d268b3d11747f9c3c557ae271a0:

  mac80211: dont assign seqno to or aggregate QoS Null frames
(2011-09-30 15:57:25 -0400)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Edward Lu (4):
      ath6kl: Support channel set request for startscan command
      ath6kl: Fix a typo in ath6k context
      ath6kl: Fix default key installation in AP mode
      ath6kl: Do not clear CONNECT bit setting in AP mode for STA disconnect

Jouni Malinen (37):
      ath6kl: Use cfg80211_inform_bss instead of cfg80211_inform_bss_frame
      ath6kl: Add functionality for starting AP mode
      ath6kl: Fix AP mode (Re)AssocReq IE processing
      ath6kl: Delay initial group key setup in AP mode
      ath6kl: Use change_station() to authorize/unauthorize STAs
      ath6kl: Add new WMI commands and events for P2P
      ath6kl: Implement remain_on_channel and cancel_remain_on_channel
      ath6kl: Implement mgmt_tx
      ath6kl: Request P2P capabilities during target init
      ath6kl: Add cfg80211 calls for remain-on-channel events
      ath6kl: Use set_appie command to add Probe Request IEs
      ath6kl: Report received Probe Request frames to cfg80211
      ath6kl: Notify cfg80211 of TX status of mgmt_tx frames
      ath6kl: Report received Action frames to cfg80211
      ath6kl: Advertise supported mgmt_stypes
      ath6kl: Add support for new P2P iftypes in mode changes
      ath6kl: Include P2P IE(s) in GO Probe Response depending on request
      ath6kl: Return error from wmi.c instead of -EIO in
ath6kl_cfg80211_scan
      ath6kl: Define __CHECK_ENDIAN__ for sparse
      ath6kl: Do not enable Probe Request reporting by default
      athk6l: Fix channel list processing in scan requests
      ath6kl: Fix WMI message structure for AP_SET_PVB
      ath6kl: Fix AP mode connect event parsing and TIM updates
      ath6kl: Allow AP mode to be configured
      ath6kl: Allow enabling of P2P support
      ath6kl: Fix static WEP configuration in AP mode
      ath6kl: Fix BSS update on roaming
      ath6kl: Remove deprecated WMI_OPT_RX_FRAME_EVENTID processing
      ath6kl: Remove RSSI update for internal node table
      ath6kl: Remove unnecessary node table update on disconnect event
      ath6kl: Replace internal node table with cfg80211 BSS table
      ath6kl: Remove the unused node table implementation
      ath6kl: Remove unnecessary bssinfo event header conversion
      ath6kl: Update BSS information after connection
      ath6kl: Export beacon interval and DTIM period through STA info
      ath6kl: Report PMKSA candidate events through cfg80211
      ath6kl: fix TCP corruption

Kalle Valo (27):
      ath6kl: fix indentation in htc_issued_send()
      ath6kl: implement suspend support
      ath6kl: add testmode support
      ath6kl: fix compilation when NL80211_TESTMODE is disabled
      ath6kl: add firmware log support
      ath6kl: implement support to set firmware log parameters
      ath6kl: cleanup diagnose window read and write functions
      ath6kl: read fwlog from firmware ring buffer
      ath6kl: unify tx function names in htc.c
      ath6kl: unify rx function naming in htc.c
      ath6kl: separate firmware fetch from upload
      ath6kl: fix busy loop in ath6kl_bmi_get_rx_lkahd()
      ath6kl: add support for firmware API 2 format
      ath6kl: refactor firmware load address code
      ath6kl: refactor firmware ext data addr and reserved ram handling size
      ath6kl: read firmware start address from hardware
      ath6kl: read reserved ram size from firmware file
      ath6kl: add firmware capabilities support
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: pass only unicast frames for aggregation
      ath6kl: allow firmware to override firmware patch address
      ath6kl: silence "invalid rate" warning
      ath6kl: add prefix parameter to ath6kl_dbg_dump()
      ath6kl: add sdio debug messages
      ath6kl: add debug logs for booting
      ath6kl: improve wmi debug messages
      ath6kl: fix size_t related warnings

Kevin Fang (1):
      ath6kl: Add beginning of AR6004 initialisation support

Raja Mani (2):
      ath6kl: Avoid finding bss presence in cfg80211 scan list
      ath6kl: Check sme state before delivering disconnect event to cfg80211

Rajkumar Manoharan (1):
      ath6kl: Fix compilation error while compiling w/o debug

Sam Leffler (1):
      ath6kl: query device tree for firmware board-id

Stephen Rothwell (1):
      wireless/ath6kl: use of module_param requires the inclusion of
moduleparam.h

Vasanthakumar Thiagarajan (21):
      ath6kl: Release ar->lock right afer updating net_stats in ath6kl_rx()
      ath6kl: Minor cleanup in min_hdr_len computation
      ath6kl: Cleanup ath6kl_wmi_data_hdr_remove()
      ath6kl: Fix bug in computing AMSU subframe padding
      ath6kl: Fix buffer alignment for scatter-gather I/O
      ath6kl: Fix system freeze under heavy data load
      ath6kl: Remove unused meta_v2 from ath6kl_data_tx()
      ath6kl: Add wmi meta data information only it is available
      ath6kl: Avoid rolling back of entire scatter setup in case of failure
      ath6kl: Add initial debugfs changes
      ath6kl: Add debugfs entry to dump target stats
      ath6kl: Add debugfs file entry to dump credit distribution stats
      ath6kl: Add debugfs interface to dump diagnostic registers from
firmware
      ath6kl: Fix endianness in requesting chip register read
      ath6kl: Make ath6kl_diag_write32() non-static
      ath6kl: Fix endianness in register write
      ath6kl: Add debugfs support to write a chip register
      ath6kl: Remove auth type fall back in auto authentication mode
      ath6kl: Set the sme_state to disconnected in disconnect() callback
      ath6kl: Fix disconnect event reporting
      ath6kl: Remove unnecessary retrieval of first list entry in
ath6kl_htc_tx_setup_scat_list()

Vivek Natarajan (4):
      ath6kl: Add debugfs entry to modify roaming parameters.
      ath6kl: Process regulatory requests from firmware.
      ath6kl: deinitialise wiphy on error
      ath6kl: Indicate the roaming capability of the firmware

 drivers/net/wireless/ath/ath6kl/Makefile   |    4 +-
 drivers/net/wireless/ath/ath6kl/bmi.c      |   23 +-
 drivers/net/wireless/ath/ath6kl/bmi.h      |    4 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  894 ++++++++++++++++-------
 drivers/net/wireless/ath/ath6kl/common.h   |   83 --
 drivers/net/wireless/ath/ath6kl/core.h     |  145 +++-
 drivers/net/wireless/ath/ath6kl/debug.c    |  783 +++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h    |   49 +-
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    5 +
 drivers/net/wireless/ath/ath6kl/hif.h      |    1 +
 drivers/net/wireless/ath/ath6kl/htc.c      |  271 ++++---
 drivers/net/wireless/ath/ath6kl/init.c     |  794 +++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/main.c     |  448 ++++++++----
 drivers/net/wireless/ath/ath6kl/node.c     |  234 ------
 drivers/net/wireless/ath/ath6kl/sdio.c     |   79 ++-
 drivers/net/wireless/ath/ath6kl/target.h   |   41 +-
 drivers/net/wireless/ath/ath6kl/testmode.c |  167 ++++
 drivers/net/wireless/ath/ath6kl/testmode.h |   36 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |   61 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      | 1126
+++++++++++++++++++---------
 drivers/net/wireless/ath/ath6kl/wmi.h      |  350 ++++++++--
 21 files changed, 4049 insertions(+), 1549 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath6kl/node.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/testmode.h

