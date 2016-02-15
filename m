Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:64363
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbcBONf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 08:35:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V5 0/3] nl80211: allow configuration of BSS selection
Date: Mon, 15 Feb 2016 14:35:50 +0100
Message-Id: <1455543353-20311-1-git-send-email-arend@broadcom.com> (sfid-20160215_181517_041061_6D2442CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for configuration of BSS selection done by
the driver and/or firmware. It allows user-space to pass selection behaviour
with the NL80211_CMD_CONNECT using NL80211_ATTR_BSS_SELECT. When user-space
does provide this attribute and no explicit BSSID is provided it will pass
the BSS selection behaviour to the driver if the driver supports it.

When multiple BSS-es are found belonging to the same ESS, ie. Infra-BSS with
same SSID, this can be used to select a BSS. The behaviours defined are:

1. RSSI based selection.
2. Band selection, RSSI based selection.
3. RSSI adjustment in given band, RSSI based selection.

The third patch addresses an issue observed during testing so
not really related to the feature. This series is intended for
v4.6 and applies to master branch of the mac80211-next repository.

V2:
 - incorporate comments from Johannes Berg (may have missed some).
 - split nl80211 patch in two separate patches.

V3:
 - remove enum nl80211_bss_select_primitive.
 - reword documentation of nl80211_bss_select_attr enum values.

V4:
 - remove documentation reference to removed primitive.

V5:
 - validate only one behaviour is passed from user-space.
 - use packed struct for RSS_ADJUST attribute.
 - validate user-space provided band value against wiphy->bands.

Arend van Spriel (2):
  nl80211: add feature for BSS selection support
  brcmfmac: add support for nl80211 BSS_SELECT feature
  cfg80211: stop critical protocol session upon disconnect event

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  66 +++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  38 +++++---
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   1 +
 include/net/cfg80211.h                             |  34 +++++++
 include/uapi/linux/nl80211.h                       |  52 +++++++++++
 net/wireless/core.c                                |   4 +
 net/wireless/nl80211.c                             | 101 +++++++++++++++++++++
 net/wireless/sme.c                                 |   6 ++
 8 files changed, 284 insertions(+), 18 deletions(-)

-- 
1.9.1

