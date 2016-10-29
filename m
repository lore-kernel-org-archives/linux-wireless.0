Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12629 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcJ2Fvm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 01:51:42 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/7] wil6210 patches
Date: Sat, 29 Oct 2016 08:51:20 +0300
Message-Id: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20161029_075150_444159_7B3A56B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following set of patches include:
- Various wil6210 fixes
- Support for abort scan operation
- Ability to enable / disable power save from upper layers
- Addition of vendor commands for low level control over RF sectors.

Dedy Lansky (1):
  wil6210: fix net queue stop/wake

Lior David (4):
  wil6210: fix deadlock when using fw_no_recovery option
  wil6210: align to latest auto generated wmi.h
  wil6210: support NL80211_ATTR_WIPHY_RETRY_SHORT
  wil6210: low level RF sector API

Maya Erez (2):
  wil6210: add support for power save enable / disable
  wil6210: add support for abort scan

 drivers/net/wireless/ath/wil6210/cfg80211.c | 653 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/main.c     |  98 +++--
 drivers/net/wireless/ath/wil6210/netdev.c   |   2 +-
 drivers/net/wireless/ath/wil6210/p2p.c      |  10 +-
 drivers/net/wireless/ath/wil6210/txrx.c     | 110 ++++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  13 +
 drivers/net/wireless/ath/wil6210/wmi.c      | 117 ++++-
 drivers/net/wireless/ath/wil6210/wmi.h      | 208 ++++++++-
 8 files changed, 1151 insertions(+), 60 deletions(-)

-- 
1.9.1
