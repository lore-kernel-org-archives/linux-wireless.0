Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44083 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1H2MYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:24:11 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 00/20] ath6kl: AP mode and P2P
Date: Mon, 29 Aug 2011 15:23:41 +0300
Message-ID: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142419_545263_B568B4A5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches adds preliminary support for AP mode and P2P
operations into ath6kl. Since these require a new firmware build
and more testing, the patches to actually enable either AP or P2P
modes are not included in the series. These will be submitted
after some more testing.

Edward Lu (4):
  ath6kl: Support channel set request for startscan command
  ath6kl: Fix a typo in ath6k context
  ath6kl: Fix default key installation in AP mode
  ath6kl: Do not clear CONNECT bit setting in AP mode for STA
    disconnect

Jouni Malinen (16):
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

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  482 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |   31 +--
 drivers/net/wireless/ath/ath6kl/init.c     |   18 +-
 drivers/net/wireless/ath/ath6kl/main.c     |   96 ++++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |  435 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |  227 +++++++++++++-
 6 files changed, 1222 insertions(+), 67 deletions(-)

-- 
1.7.4.1

