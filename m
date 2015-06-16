Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18294 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbbFPFqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:46:32 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 00/10] introduce wmi support for qca99X0
Date: Tue, 16 Jun 2015 11:15:13 +0530
Message-ID: <1434433523-8357-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_074636_651710_32B29185)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca99X0 uses 10.4 firmware. This patch series adds 10.4 firmware
specific WMI cmds/events/parsing logic. All these patches tested
on top of qca99X0 initial bring up patches.

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
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  47 ++
 drivers/net/wireless/ath/ath10k/wmi.c     | 793 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     | 792 ++++++++++++++++++++++++++++-
 7 files changed, 1700 insertions(+), 6 deletions(-)

-- 
1.8.1.2

