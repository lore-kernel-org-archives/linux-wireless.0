Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753673AbeGELw2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 07:52:28 -0400
From: Karthikeyan Periyasamy <periyasa@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>
Subject: [RFC 0/2] ath10k: Add QCA vendor command/attr support to filter neighbor BSS frames
Date: Thu,  5 Jul 2018 17:21:50 +0530
Message-Id: <1530791512-6915-1-git-send-email-periyasa@codeaurora.org> (sfid-20180705_135352_243177_526BB3FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow AP to receive neighbor BSSs frames and user-space can get the
statistics of the stations associated with neighbor BSSs.

User-space can use QCA_NL80211_VENDOR_SUBCMD_BSS_FILTER command to configure
RX filter to receive frames from stations that are active on the operating
channel, but not associated with the local device (e.g., STAs associated with
neighbor APs). Filtering is done based on a list of BSSIDs and STA MAC addresses
added by the user. This command is also used to fetch statistics of unassociated
stations. The attributes used with this command are defined in enum
qca_wlan_vendor_attr_bss_filter.

User can add/delete the filter by specifying the BSSID/STA MAC address in
QCA_WLAN_VENDOR_ATTR_BSS_FILTER_MAC_ADDR, filter type as BSSID/STA in
QCA_WLAN_VENDOR_ATTR_BSS_FILTER_TYPE and add/delete action in
QCA_WLAN_VENDOR_ATTR_BSS_FILTER_ACTION using the QCA vendor command
QCA_NL80211_VENDOR_SUBCMD_BSS_FILTER.

User can get the statistics of an unassociated station by specifying the MAC
address in QCA_WLAN_VENDOR_ATTR_BSS_FILTER_MAC_ADDR, station type in
QCA_WLAN_VENDOR_ATTR_BSS_FILTER_TYPE, GET action in
QCA_WLAN_VENDOR_ATTR_BSS_FILTER_ACTION using the QCA vendor command
QCA_NL80211_VENDOR_SUBCMD_BSS_FILTER. User can also get the statistics of all
unassociated stations by specifying the Broadcast MAC address (ff:ff:ff:ff:ff:ff)
in QCA_WLAN_VENDOR_ATTR_BSS_FILTER_MAC_ADDR with above procedure. In response,
ath10k driver specify statistics information nested in
QCA_WLAN_VENDOR_ATTR_BSS_FILTER_STA_STATS.

NOTE: Tested with debug firmware

Karthikeyan Periyasamy (2):
  ath10k: add wmi interface for vdev_set_neighbor_rx_param
  ath10k: Add QCA vendor command/attr support to filter neighbor BSS
    frames

 drivers/net/wireless/ath/ath10k/Makefile  |   3 +-
 drivers/net/wireless/ath/ath10k/core.h    |   3 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   5 +
 drivers/net/wireless/ath/ath10k/mac.c     |  15 +-
 drivers/net/wireless/ath/ath10k/vendor.c  | 770 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/vendor.h  | 289 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  28 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |  33 ++
 drivers/net/wireless/ath/ath10k/wmi.h     |  76 +++
 9 files changed, 1219 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/vendor.c
 create mode 100644 drivers/net/wireless/ath/ath10k/vendor.h

-- 
1.9.1
