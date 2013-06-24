Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:37600 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3FXIta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 04:49:30 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v10 0/2] P2P find phase offload
Date: Mon, 24 Jun 2013 11:49:15 +0300
Message-ID: <1372063757-24286-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130624_104934_161503_F00295C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following discussion input, I added 'flags' attribute for
cfg80211_rx_mgmt(), as separate commit since it is... separate

Now, policy for P2P device is clear - it replies probe-requests
if it can, then if driver receives probe (if FW replies to the probe,
it may be not reported to the driver), it reports via cfg80211_rx_mgmt()
indicating whether frame was replied. wpa_s now can determine whether it
need to reply on its own.

Vladimir Kondratiev (2):
  cfg80211: add flags to cfg80211_rx_mgmt
  cfg80211: P2P find phase offload

 drivers/net/wireless/ath/ath6kl/wmi.c         |   7 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   4 +-
 drivers/net/wireless/mwifiex/util.c           |   4 +-
 include/net/cfg80211.h                        |  80 ++++++++++-
 include/uapi/linux/nl80211.h                  |  32 +++++
 net/mac80211/rx.c                             |   3 +-
 net/wireless/mlme.c                           |   4 +-
 net/wireless/nl80211.c                        | 187 +++++++++++++++++++++++++-
 net/wireless/nl80211.h                        |   2 +-
 net/wireless/rdev-ops.h                       |  19 +++
 net/wireless/trace.h                          |  42 ++++++
 12 files changed, 369 insertions(+), 17 deletions(-)

-- 
1.8.1.2

