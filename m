Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2454 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdDDFmM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 01:42:12 -0400
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv3 0/2] cfg80211: mac80211: BTCOEX feature support
Date: Tue, 4 Apr 2017 11:12:36 +0530
Message-ID: <1491284558-1915-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170404_074216_706240_2AF10E9F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patchset add support for BTCOEX feature to enable/disable and
modifying btcoex priority value via nl80211

Tamizh chelvam (2):
  cfg80211: Add support to enable or disable btcoex and  set
    btcoex_priority
  mac80211: Add support to enable or disable btcoex and set btcoex
    priority value

v3 :
  * Introduced NL80211_EXT_FEATURE_BTCOEX_PRIORITY to expose
    btcoex priority support and removed bool variable.

v2 :
  * Introduced NL80211_CMD_SET_BTCOEX to enable/disable btcoex and
    to set/modify btcoex_priority.
  * Added bool variable in wiphy structure to advertise btcoex_priority
    feature and removed BITMAP calculation for btcoex_priority value.

 include/net/cfg80211.h       |   35 ++++++++++++++++++++++++++++++++
 include/net/mac80211.h       |    5 +++++
 include/uapi/linux/nl80211.h |   20 +++++++++++++++++++
 net/mac80211/cfg.c           |    9 +++++++++
 net/mac80211/driver-ops.h    |   15 ++++++++++++++
 net/mac80211/trace.h         |   20 +++++++++++++++++++
 net/wireless/nl80211.c       |   45 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   13 ++++++++++++
 net/wireless/trace.h         |   17 ++++++++++++++++
 9 files changed, 179 insertions(+)

-- 
1.7.9.5
