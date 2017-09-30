Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35648 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdI3Ri0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Sep 2017 13:38:26 -0400
Received: by mail-pf0-f195.google.com with SMTP id i23so1765976pfi.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 Sep 2017 10:38:26 -0700 (PDT)
From: silexcommon@gmail.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>
Subject: [PATCH 00/11] SDIO support for ath10k
Date: Sat, 30 Sep 2017 23:07:37 +0530
Message-Id: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com> (sfid-20170930_193750_815485_2D12AEBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alagu Sankar <alagusankar@silex-india.com>

This patchset, generated against master-pending branch, enables a fully
functional SDIO interface driver for ath10k.  Patches have been verified on
QCA9377-3 WB396 and Silex's SX-SDCAC reference cards with Station, Access Point
and P2P modes.

The driver is verified with the firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1
with the board data from respective SDIO card vendors. Receive performance
matches the QCA reference driver when used with SDIO3.0 enabled platforms.
iperf tests indicate a downlink UDP of 275Mbit/s and TCP of 150Mbit/s

This patchset differs from the previous high latency patches, specific to SDIO.
HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET is enabled for HI_ACS. This instructs the
firmware to use HTT_T2H_MSG_TYPE_TX_COMPL_IND for outgoing packets. Without
this flag, the management frames are not sent out by the firmware. Possibility
of management frames being sent via WMI and data frames through the reduced Tx
completion needs to be probed further.

Further improvements can be done on the transmit path by implementing packet
bundle. Scatter Gather is another area of improvement for both Transmit and
Receive, but may not work on all platforms

Known issues: Surprise removal of the card, when the device is in connected
state, delays sdio function remove due to delayed WMI command failures.
Existing ath10k framework can not differentiate between a kernel module
removal and the surprise removal of teh card.

Alagu Sankar (11):
  ath10k_sdio: sdio htt data transfer fixes
  ath10k_sdio: wb396 reference card fix
  ath10k_sdio: DMA bounce buffers for read write
  ath10k_sdio: reduce transmit msdu count
  ath10k_sdio: use clean packet headers
  ath10k_sdio: high latency fixes for beacon buffer
  ath10k_sdio: fix rssi indication
  ath10k_sdio: common read write
  ath10k_sdio: virtual scatter gather for receive
  ath10k_sdio: enable firmware crash dump
  ath10k_sdio: hif start once addition

 drivers/net/wireless/ath/ath10k/core.c    |  35 ++-
 drivers/net/wireless/ath/ath10k/debug.c   |   3 +
 drivers/net/wireless/ath/ath10k/htc.c     |   4 +-
 drivers/net/wireless/ath/ath10k/htc.h     |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  19 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  24 +-
 drivers/net/wireless/ath/ath10k/hw.c      |   2 +
 drivers/net/wireless/ath/ath10k/hw.h      |   1 +
 drivers/net/wireless/ath/ath10k/mac.c     |  31 ++-
 drivers/net/wireless/ath/ath10k/sdio.c    | 398 ++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/sdio.h    |  10 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   2 +-
 12 files changed, 403 insertions(+), 127 deletions(-)

-- 
1.9.1
