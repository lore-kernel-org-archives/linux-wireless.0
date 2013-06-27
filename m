Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48307 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3F0LRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 07:17:55 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>, Peer@vger.kernel.org,
	Ilan <ilan.peer@intel.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v13 0/2] P2P find phase offload
Date: Thu, 27 Jun 2013 14:17:41 +0300
Message-ID: <1372331863-14083-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130627_131758_884489_DEE035B8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Addressing next round of input

- add more comments about NL80211_ATTR_RXMGMT_FLAGS
- always supply non-empty channel list for start_p2p_find();
  in case wpa_s don't provide one, build our own
- track p2p find state, similar to nl80211_start_p2p_device()
  and protect from multiple start/stop requests. For this,
  out-of context of stop_p2p_find call of cfg80211_p2p_find_notify_end
  now requires rtnl_lock()

Vladimir Kondratiev (2):
  cfg80211: add 'flags' to cfg80211_rx_mgmt()
  cfg80211: P2P find phase offload

 drivers/net/wireless/ath/ath6kl/wmi.c         |   7 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   4 +-
 drivers/net/wireless/mwifiex/util.c           |   4 +-
 include/net/cfg80211.h                        |  79 +++++++++-
 include/uapi/linux/nl80211.h                  |  31 ++++
 net/mac80211/rx.c                             |   3 +-
 net/wireless/mlme.c                           |   4 +-
 net/wireless/nl80211.c                        | 211 +++++++++++++++++++++++++-
 net/wireless/nl80211.h                        |   2 +-
 net/wireless/rdev-ops.h                       |  19 +++
 net/wireless/trace.h                          |  44 ++++++
 12 files changed, 393 insertions(+), 17 deletions(-)

-- 
1.8.1.2

