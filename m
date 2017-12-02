Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:58234 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbdLBLbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 06:31:21 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH v2 0/4] WMI changes for wcn3990
Date: Sat,  2 Dec 2017 17:00:44 +0530
Message-Id: <1512214248-17127-1-git-send-email-pillair@qti.qualcomm.com> (sfid-20171202_123136_756829_28284C33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset includes the WMI changes for wcn3390 to
Refactor service ready event parsing,
Add management frame tx by refernce over wmi,
Add hw parameters for wcn3990.

Changes since v1:
- Make code endian safe by using __cpu_to_le32 for hw parameters.

Rakesh Pillai (4):
  ath10k: WMI: modify svc bitmap parsing for wcn3990
  ath10k: WMI: Add management tx by reference support over wmi
  ath10k: WMI: get wmi init parameter values from hw params
  ath10k: WMI: add hw params entry for wcn3990

 drivers/net/wireless/ath/ath10k/core.c    |  55 ++++++++++++
 drivers/net/wireless/ath/ath10k/core.h    |   3 +
 drivers/net/wireless/ath/ath10k/hw.c      |   2 +
 drivers/net/wireless/ath/ath10k/hw.h      |  14 +++
 drivers/net/wireless/ath/ath10k/mac.c     |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   9 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 143 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 113 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   2 +
 9 files changed, 328 insertions(+), 17 deletions(-)

-- 
1.9.1
