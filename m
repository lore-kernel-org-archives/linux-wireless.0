Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25791 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3FYNms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 09:42:48 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>, Peer@vger.kernel.org,
	Ilan <ilan.peer@intel.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v12 0/2] P2P find phase offload
Date: Tue, 25 Jun 2013 16:42:34 +0300
Message-ID: <1372167756-17928-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130625_154251_747661_F71176A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Addressing input by Ilan

- remove NL80211_ATTR_LISTEN_FREQ, use NL80211_ATTR_WIPHY_FREQ instead
- trace to include listen channel

This time, only patch 2/2 changed.

Vladimir Kondratiev (2):
  cfg80211: add 'flags' to cfg80211_rx_mgmt()
  cfg80211: P2P find phase offload

 drivers/net/wireless/ath/ath6kl/wmi.c         |   7 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   4 +-
 drivers/net/wireless/mwifiex/util.c           |   4 +-
 include/net/cfg80211.h                        |  79 ++++++++++-
 include/uapi/linux/nl80211.h                  |  27 ++++
 net/mac80211/rx.c                             |   3 +-
 net/wireless/mlme.c                           |   4 +-
 net/wireless/nl80211.c                        | 186 +++++++++++++++++++++++++-
 net/wireless/nl80211.h                        |   2 +-
 net/wireless/rdev-ops.h                       |  19 +++
 net/wireless/trace.h                          |  44 ++++++
 12 files changed, 364 insertions(+), 17 deletions(-)

-- 
1.8.1.2

