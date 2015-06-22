Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55094 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbFVOk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:40:56 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 00/10] introduce wmi support for qca99X0
Date: Mon, 22 Jun 2015 20:10:08 +0530
Message-ID: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164100_414019_641C8CBC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca99X0 uses 10.4 firmware. This patch series adds 10.4 firmware
specific WMI cmds/events/parsing logic. All these patches tested
on top of qca99X0 initial bring up patches.

v2 changes:
   - Synced wmi service/cmd/event/pdev/vdev ids to most
     stable 10.4 firmware.

Raja Mani (10):
  ath10k: include new wmi op version for 10.4 fw
  ath10k: add 10.4 fw wmi service bitmap definition
  ath10k: include 10.4 fw specific wmi cmd and event ids
  ath10k: set 10.4 fw exclusive wmi cmd as unsupported for other fw
    versions
  ath10k: add 10.4 fw wmi vdev cmd ids
  ath10k: add 10.4 fw wmi pdev cmd ids
  ath10k: fill 10.4 fw wmi init cmd default values
  ath10k: handle 10.4 fw wmi mgmt rx event
  ath10k: adjust default peer limits if qcache enabled in 10.4 fw
  ath10k: handle 10.4 fw wmi ready event

 drivers/net/wireless/ath/ath10k/core.c    |   9 +
 drivers/net/wireless/ath/ath10k/core.h    |   2 +
 drivers/net/wireless/ath/ath10k/hw.h      |  61 +++
 drivers/net/wireless/ath/ath10k/mac.c     |   2 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  90 +++
 drivers/net/wireless/ath/ath10k/wmi.c     | 879 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     | 859 ++++++++++++++++++++++++++++-
 7 files changed, 1896 insertions(+), 6 deletions(-)

-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
