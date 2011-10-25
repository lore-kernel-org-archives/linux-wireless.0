Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1428 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1JYOFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:05:09 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 00/31] ath6kl Add multiple vif support
Date: Tue, 25 Oct 2011 19:33:55 +0530
Message-ID: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160513_772013_079D0E47)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set adds basic infrastructure for multiple
virtual interface. As configuring the firmware with more than one
vif causes random target assert, the number of supported vifs is
restricted to 1 for now. I would like to thank Vivek Natarajan
(nataraja@qca.qualcomm.com) for his inital work in this area and
Arthi Thiruvengadam (athiruve@qca.qualcomm.com) for finding some
critical bugs.

Vasanth

V2 -- Rebased to top of ath6kl.git not Kalle's 9-patch series
    - Fold patches from 32 to 34 into the original patches (kalle's comment)

Vasanthakumar Thiagarajan (31):
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

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  981 ++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |   16 +-
 drivers/net/wireless/ath/ath6kl/common.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h     |  161 +++--
 drivers/net/wireless/ath/ath6kl/debug.c    |   38 +-
 drivers/net/wireless/ath/ath6kl/init.c     |  434 ++++++-------
 drivers/net/wireless/ath/ath6kl/main.c     |  366 +++++------
 drivers/net/wireless/ath/ath6kl/sdio.c     |   12 +-
 drivers/net/wireless/ath/ath6kl/target.h   |    3 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |  198 ++++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |  426 +++++++-----
 drivers/net/wireless/ath/ath6kl/wmi.h      |  122 +++--
 12 files changed, 1622 insertions(+), 1137 deletions(-)

