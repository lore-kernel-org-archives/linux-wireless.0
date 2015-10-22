Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14351 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbbJVPMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 11:12:06 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 0/4] ath10k: remove shadow copy engine descriptors
Date: Thu, 22 Oct 2015 20:36:38 +0530
Message-ID: <1445526402-28522-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151022_171210_627918_11AD16AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below series remove shadow copy of CE descriptors for source ring.
Removing the shadow copy should reduce d-cache pressure and memory
usage of the driver.

Rajkumar Manoharan (4):
  ath10k: use local memory instead of shadow descriptor in ce_send
  ath10k: remove send completion validation in diag read/write
  ath10k: cleanup copy engine send completion
  ath10k: remove shadow copy of CE descriptors for source ring

 drivers/net/wireless/ath/ath10k/ce.c  | 57 +++++------------------------------
 drivers/net/wireless/ath/ath10k/ce.h  | 16 ++--------
 drivers/net/wireless/ath/ath10k/pci.c | 53 +++++---------------------------
 3 files changed, 17 insertions(+), 109 deletions(-)

-- 
2.6.1

