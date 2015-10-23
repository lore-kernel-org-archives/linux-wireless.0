Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62043 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbJWMb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 08:31:28 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 0/4] ath10k: remove shadow copy engine descriptors
Date: Fri, 23 Oct 2015 18:01:02 +0530
Message-ID: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151023_143134_065207_A18D3E35)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below series remove shadow copy of CE descriptors for source ring.
Removing the shadow copy should reduce d-cache pressure and memory
usage of the driver.

v2:
 * Since ce_send is not using shadow, fix send completion as well.

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

