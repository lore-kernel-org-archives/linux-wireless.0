Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:28691 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbbLXMTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 07:19:13 -0500
From: Arend van Spriel <arend@broadcom.com>
To: <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC 0/2] nl80211: allow configuration of BSS selection
Date: Thu, 24 Dec 2015 13:19:08 +0100
Message-ID: <1450959550-19655-1-git-send-email-arend@broadcom.com> (sfid-20151224_131917_456876_D4AFD917)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for configuration of BSS selection done by
the driver and/or firmware. It allows user-space to pass selection criteria
with the NL80211_CMD_CONNECT using NL80211_ATTR_BSS_SELECT. When user-space
does provide this attribute and no explicit BSSID is provided it will pass
the BSS selection criteria to the driver if the driver supports it.

When multiple BSS-es are found belonging to the same ESS, ie. Infra-BSS with
same SSID, the criteria can be used to select a BSS. The criteria defined are:

1. select BSS in specific band regardless RSSI level.
2. adjust RSSI level for BSS-es in specified band.

Open issue:
-----------
* NL80211_CMD_CONNECT support ATTR_MAC and ATTR_MAC_HINT. When ATTR_MAC is
  used BSS selection criteria are ignored. What about ATTR_MAC_HINT?

Arend van Spriel (2):
  nl80211: add extended feature for BSS selection support
  brcmfmac: add support for nl80211 BSS_SELECT feature

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 47 ++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/common.c   | 38 ++++++++++-------
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  1 +
 include/net/cfg80211.h                             | 17 ++++++++
 include/uapi/linux/nl80211.h                       | 35 ++++++++++++++++
 net/wireless/nl80211.c                             | 46 +++++++++++++++++++++
 6 files changed, 169 insertions(+), 15 deletions(-)

-- 
1.9.1

