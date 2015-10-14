Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20727 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbbJNIwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 04:52:43 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 0/2 v2] ath10k: print firwmare stats specific to firmware version
Date: Wed, 14 Oct 2015 14:22:31 +0530
Message-ID: <1444812751-11103-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20151014_105249_463882_B62417FA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

Currently printing fw stats in ath10k is common to all firmware versions.
Printing all the stats might lead to confusion because some of the stats
are firmware specific and when printed will have 0's.
Below patchset prints firmware stats specific to firmware.

v2:
        > All the filtered functions moved to wmi.c
        > Added firmware stats support for 10.4 firmware.

Manikanta (2):
  ath10k: Make fw stats prints specific to firmware version
  ath10k: add fw_stats support to 10.4 firmware

 drivers/net/wireless/ath/ath10k/core.h    |   12 +
 drivers/net/wireless/ath/ath10k/debug.c   |  267 +------------
 drivers/net/wireless/ath/ath10k/debug.h   |    3 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   13 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  588 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  144 +++++++
 7 files changed, 769 insertions(+), 259 deletions(-)

-- 
1.7.9.5

