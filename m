Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37092 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1KCJlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:41:12 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 0/3] ath6kl: Add support for WAPI configuration
Date: Thu, 3 Nov 2011 11:39:36 +0200
Message-ID: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20111103_104115_233942_E6519601)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches extends ath6kl to allow station and AP mode WAPI
support to be enabled. Please note that these depend on earlier patches
that are not yet in wireless-testing.git:

ieee80211: Define cipher suite selector for WPI-SMS4
nl80211: Increase maximum NL80211_ATTR_KEY_SEQ length to 16

In addition, the three patches I sent yesterday for ath6kl should be
applied first:

ath6kl: Remove unused WMI crypto defines
ath6kl: Fix key configuration to copy at most seq_len from seq
ath6kl: Do not hide ath6kl_wmi_addkey_cmd() error values


Dai Shuibing (3):
  ath6kl: Add support for configuring SMS4 keys
  ath6kl: Allow SMS4 to be configured in AP mode
  ath6kl: Indicate WAPI IE from (Re)Association Request frame

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   24 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath6kl/common.h   |    1 +
 drivers/net/wireless/ath/ath6kl/main.c     |   12 ++++++++++++
 3 files changed, 35 insertions(+), 2 deletions(-)

-- 
1.7.4.1

