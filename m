Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:26119 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3HOLv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 07:51:59 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v14 0/2] P2P find phase offload
Date: Thu, 15 Aug 2013 14:51:27 +0300
Message-ID: <1376567489-1863-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130815_135202_099066_FE7A399C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Addressed input collected:

- remove NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD feature flag because
  NL80211_RXMGMT_FLAG_REPLIED flag in cfg80211_rx_mgmt() provide needed
  info on per-frame basis
- validate min/max discoverable interval parameters
- use kcalloc to allocate array

Vladimir Kondratiev (2):
  cfg80211: add 'flags' to cfg80211_rx_mgmt()
  cfg80211: P2P find phase offload

 drivers/net/wireless/ath/ath6kl/wmi.c         |   7 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   4 +-
 drivers/net/wireless/mwifiex/util.c           |   4 +-
 include/net/cfg80211.h                        |  79 +++++++++-
 include/uapi/linux/nl80211.h                  |  27 ++++
 net/mac80211/rx.c                             |   3 +-
 net/wireless/mlme.c                           |   4 +-
 net/wireless/nl80211.c                        | 216 +++++++++++++++++++++++++-
 net/wireless/nl80211.h                        |   2 +-
 net/wireless/rdev-ops.h                       |  19 +++
 net/wireless/trace.h                          |  44 ++++++
 12 files changed, 394 insertions(+), 17 deletions(-)

-- 
1.8.1.2

