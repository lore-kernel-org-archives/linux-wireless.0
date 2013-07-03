Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2248 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3GCOhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 10:37:07 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v13 0/2] P2P find phase offload
Date: Wed, 3 Jul 2013 17:37:03 +0300
Message-ID: <2155509.WWNsyttceA@lx-vladimir> (sfid-20130703_163711_935862_26A7152C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
 net/wireless/nl80211.c                        | 211 
+++++++++++++++++++++++++-
 net/wireless/nl80211.h                        |   2 +-
 net/wireless/rdev-ops.h                       |  19 +++
 net/wireless/trace.h                          |  44 ++++++
 12 files changed, 393 insertions(+), 17 deletions(-)

-- 
1.8.1.2

