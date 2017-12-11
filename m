Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40683 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbdLKOXG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 09:23:06 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH v3 0/4] WMI changes for wcn3990
Date: Mon, 11 Dec 2017 19:52:51 +0530
Message-Id: <1513002175-2498-1-git-send-email-pillair@qti.qualcomm.com> (sfid-20171211_152310_524869_7DD7AFD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset includes the WMI changes for wcn3390 to
Refactor service ready event parsing,
Add management frame tx by refernce over wmi,
Add hw parameters for wcn3990.

Changes since v2
- Fix ath-check warnings
  1) Using plain integer as NULL pointer
  2) incorrect type in assignment 
  3) braces {} are not necessary for single statement blocks

Rakesh Pillai (4):
  ath10k: WMI: modify svc bitmap parsing for wcn3990
  ath10k: WMI: Add management tx by reference support over wmi
  ath10k: WMI: get wmi init parameter values from hw params
  ath10k: WMI: add hw params entry for wcn3990

 drivers/net/wireless/ath/ath10k/core.c    |  55 +++++++++++
 drivers/net/wireless/ath/ath10k/core.h    |   3 +
 drivers/net/wireless/ath/ath10k/hw.c      |   2 +
 drivers/net/wireless/ath/ath10k/hw.h      |  14 +++
 drivers/net/wireless/ath/ath10k/mac.c     |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   9 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 146 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 113 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   2 +
 9 files changed, 329 insertions(+), 19 deletions(-)

-- 
2.11.0
