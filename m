Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:47119 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbcAMJty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 04:49:54 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC V2 0/3] nl80211: allow configuration of BSS selection
Date: Wed, 13 Jan 2016 10:49:40 +0100
Message-ID: <1452678583-20086-1-git-send-email-arend@broadcom.com> (sfid-20160113_105008_302544_B1D94FEC)
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

1. RSSI based selection.
2. Band selection, RSSI based selection.
3. RSSI adjustment in given band, RSSI based selection.

V2:
 - incorporate comments from Johannes Berg (may have missed some).
 - split nl80211 patch in two separate patches.

Arend van Spriel (3):
  nl80211: add extended feature for BSS selection support
  nl80211: add bss selection attribute to CONNECT command
  brcmfmac: add support for nl80211 BSS_SELECT feature

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 63 ++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/common.c   | 38 ++++++----
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  1 +
 include/net/cfg80211.h                             | 34 +++++++++
 include/uapi/linux/nl80211.h                       | 52 +++++++++++++
 net/wireless/core.c                                |  5 ++
 net/wireless/nl80211.c                             | 86 ++++++++++++++++++++++
 7 files changed, 264 insertions(+), 15 deletions(-)

-- 
1.9.1

