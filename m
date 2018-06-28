Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:29472 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935097AbeF1JZ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:25:27 -0400
From: Rakesh Pillai <pillair@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 0/2] ath10k: Handle mgmt tx completion event
Date: Thu, 28 Jun 2018 14:48:55 +0530
Message-Id: <1530177537-18487-1-git-send-email-pillair@codeaurora.org> (sfid-20180628_112538_061819_0D9B8647)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The transmitted management frame completion can be
sent by the firmware as one completion per event or it can
bundle the completion of a bunch of management frames and
send it in one single event.

Disable the bundle tx completion for management frames
and handle the tx completion event for management frames to
free these frames.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Rakesh Pillai (1):
  ath10k: Handle mgmt tx completion event

Surabhi Vishnoi (1):
  ath10k: Disable bundle mgmt tx completion event support

 drivers/net/wireless/ath/ath10k/core.c    |  1 +
 drivers/net/wireless/ath/ath10k/core.h    |  5 ++
 drivers/net/wireless/ath/ath10k/hw.h      |  1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 12 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 70 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 17 +++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 84 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  7 +++
 8 files changed, 195 insertions(+), 2 deletions(-)

-- 
2.7.4
