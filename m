Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42023 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdBYNvv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Feb 2017 08:51:51 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2 0/4] cfg80211: mac80211: BTCOEX feature support
Date: Sat, 25 Feb 2017 19:07:49 +0530
Message-ID: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170225_145155_579953_E322C289)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patchset add support for BTCOEX feature to enable/disable and
modifying btcoex priority value via nl80211

Tamizh chelvam (4):
  ath10k: Add support to enable or disable btcoex via nl80211
  ath10k: Add support to update btcoex priority value via nl80211
  dt: bindings: add new dt entry for BTCOEX feature in qcom,ath10k.txt
  ath10k: Add support to read btcoex related data from DT

v2 :
  * Introduced NL80211_CMD_SET_BTCOEX to enable/disable btcoex and
    to set/modify btcoex_priority.
  * Added bool variable in wiphy structure to advertise btcoex_priority
    feature and removed BITMAP calculation for btcoex_priority value.
 
 .../bindings/net/wireless/qcom,ath10k.txt          |    4 +
 drivers/net/wireless/ath/ath10k/core.c             |   44 ++++++++-
 drivers/net/wireless/ath/ath10k/core.h             |    9 ++
 drivers/net/wireless/ath/ath10k/debug.c            |   40 ++-------
 drivers/net/wireless/ath/ath10k/mac.c              |   94 +++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.h              |    1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |   19 ++++
 drivers/net/wireless/ath/ath10k/wmi.c              |   20 +++++
 drivers/net/wireless/ath/ath10k/wmi.h              |   20 +++++
 9 files changed, 215 insertions(+), 36 deletions(-)

-- 
1.7.9.5
