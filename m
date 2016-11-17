Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55119 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbcKQLoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:44:07 -0500
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <tamizhchelvam@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh@kernel.org>, Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2 0/4] ath10k: Add support for BTCOEX feature.
Date: Thu, 17 Nov 2016 17:14:20 +0530
Message-ID: <1479383064-25718-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161117_124748_042659_0E7FE9AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch set add support to enable/disable BTCOEX via nl80211,
also support to update BTCOEX priority value for 10.4 based firmware.
Document the dt entry in qcom,ath10k.txt and reads btcoex support
flag and btcoex gpio pin detail from dt.

Tamizh chelvam (4):
  ath10k: Add support to enable or disable btcoex via nl80211
  ath10k: Add support to update btcoex priority value via nl80211
  dt: bindings: add new dt entry for BTCOEX feature in qcom,ath10k.txt
  ath10k: Add support to read btcoex related data from DT

V2:

 * Added device tree list in CC
 * fixed mutex unlock issue in 
   "ath10k: Add support to update btcoex priority value via nl80211"

 .../bindings/net/wireless/qcom,ath10k.txt          |    4 +
 drivers/net/wireless/ath/ath10k/core.c             |   44 +++++-
 drivers/net/wireless/ath/ath10k/core.h             |    9 ++
 drivers/net/wireless/ath/ath10k/debug.c            |   40 +-----
 drivers/net/wireless/ath/ath10k/mac.c              |  140 +++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.h              |    1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |   19 +++
 drivers/net/wireless/ath/ath10k/wmi.c              |   20 +++
 drivers/net/wireless/ath/ath10k/wmi.h              |   20 +++
 9 files changed, 261 insertions(+), 36 deletions(-)

-- 
1.7.9.5
