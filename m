Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32588 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3FYHCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 03:02:54 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v11 0/2] P2P find phase offload
Date: Tue, 25 Jun 2013 10:02:39 +0300
Message-ID: <1372143761-21473-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130625_090257_870699_88628EC9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Addressed input from Arend and Johannes:

- shorter comment for @flags for cfg80211_rx_mgmt()
- enum nl80211_rxmgmt_flags to define raw values, don't use BIT()

Actually, only patch 1/2 changed, but I am sending both to avoid any confusion

Vladimir Kondratiev (2):
  cfg80211: add 'flags' to cfg80211_rx_mgmt()
  cfg80211: P2P find phase offload

 drivers/net/wireless/ath/ath6kl/wmi.c         |   7 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   4 +-
 drivers/net/wireless/mwifiex/util.c           |   4 +-
 include/net/cfg80211.h                        |  79 ++++++++++-
 include/uapi/linux/nl80211.h                  |  29 ++++
 net/mac80211/rx.c                             |   3 +-
 net/wireless/mlme.c                           |   4 +-
 net/wireless/nl80211.c                        | 187 +++++++++++++++++++++++++-
 net/wireless/nl80211.h                        |   2 +-
 net/wireless/rdev-ops.h                       |  19 +++
 net/wireless/trace.h                          |  42 ++++++
 12 files changed, 365 insertions(+), 17 deletions(-)

-- 
1.8.1.2

