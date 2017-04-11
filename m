Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30114 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752247AbdDKKNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 06:13:49 -0400
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv4 0/2] cfg80211: mac80211: BTCOEX feature support
Date: Tue, 11 Apr 2017 15:45:28 +0530
Message-ID: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170411_121441_665736_F0B2DA94)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patchset add support for BTCOEX feature to enable/disable and
modifying btcoex priority value via nl80211

Tamizh chelvam (2):
  cfg80211: Add support to enable or disable btcoex and set
    btcoex_priority
  mac80211: Add support to enable or disable btcoex and set btcoex
    priority value

v4 :
  * Moved btcoex_priority_support_flag enum to nl80211.h and renamed it.
  * fixed typo.

v3 :
  * Introduced NL80211_EXT_FEATURE_BTCOEX_PRIORITY to expose
    btcoex priority support and removed bool variable.

v2 :
  * Introduced NL80211_CMD_SET_BTCOEX to enable/disable btcoex and
    to set/modify btcoex_priority.
  * Added bool variable in wiphy structure to advertise btcoex_priority
    feature and removed BITMAP calculation for btcoex_priority value.

 include/net/cfg80211.h       |    6 +++++
 include/net/mac80211.h       |    5 +++++
 include/uapi/linux/nl80211.h |   50 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/cfg.c           |    9 ++++++++
 net/mac80211/driver-ops.h    |   15 +++++++++++++
 net/mac80211/trace.h         |   20 +++++++++++++++++
 net/wireless/nl80211.c       |   45 +++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   13 +++++++++++
 net/wireless/trace.h         |   17 ++++++++++++++
 9 files changed, 180 insertions(+)

-- 
1.7.9.5
