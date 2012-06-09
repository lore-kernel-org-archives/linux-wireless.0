Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934578Ab2FIAvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 20:51:55 -0400
Cc: <linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>, <kvalo@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
Subject: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
Date: Fri, 8 Jun 2012 17:51:07 -0700
Message-ID: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120609_025355_763900_93A6479D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

Turns out that standard Linux distributions leave CONFIG_EXPERT
enabled. This makes this option useless for wireless testing / research
purposes as we don't want certain features enabled on all kernel
builds. This adds a new CONFIG_CFG80211_EXPERT and makes a few
features depend on them.

Luis R. Rodriguez (3):
  cfg80211: add CONFIG_CFG80211_EXPERT
  ath5k: replace modparam_all_channels with CONFIG_ATH5K_TEST_CHANNELS
  ath9k: make CONFIG_ATH9K_DFS_CERTIFIED depend on
    CONFIG_CFG80211_EXPERT

 drivers/net/wireless/ath/ath5k/Kconfig |    8 ++++++++
 drivers/net/wireless/ath/ath5k/base.c  |   17 ++++++++++-------
 drivers/net/wireless/ath/ath9k/Kconfig |    2 +-
 net/wireless/Kconfig                   |    9 +++++++++
 4 files changed, 28 insertions(+), 8 deletions(-)

-- 
1.7.10.rc1.22.gf5241

