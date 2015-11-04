Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55976 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbKDMF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 07:05:56 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 0/3] Fix few WMI/HTT interfaces
Date: Wed, 4 Nov 2015 17:35:34 +0530
Message-ID: <1446638737-7953-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20151104_130559_983979_002C1839)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set fixes mismatch in peer_assoc complete wmi command for
version 10.4 and peer_id configuration for HTT version < 3.4.

V2:
	- Add cover letter
	- Rename ath10k_mac_need_offchan_tx_work() to
	  ath10k_mac_tx_frm_has_freq(). Add htt-op-version check
	  to the helper and use it in ath10k_htt_tx() while configuring
	  peerid.

Vasanthakumar Thiagarajan (3):
  ath10k: Fix peer assoc complete WMI command for 10.4
  ath10k: Rename the helper which is used for off-channel tx
  ath10k: Fix peerid configuration in htt tx desc for htt version < 3.4

 drivers/net/wireless/ath/ath10k/htt.h    |  9 ++++++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 11 ++++++++--
 drivers/net/wireless/ath/ath10k/mac.c    |  9 ++++----
 drivers/net/wireless/ath/ath10k/mac.h    |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c    | 37 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h    |  5 +++++
 6 files changed, 63 insertions(+), 9 deletions(-)

-- 
1.9.1

