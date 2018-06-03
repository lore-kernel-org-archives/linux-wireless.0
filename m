Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37979 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbeFCSWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:10 -0400
Received: by mail-lf0-f68.google.com with SMTP id i83-v6so9617382lfh.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:09 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 00/12] ath10k high latency
Date: Sun,  3 Jun 2018 20:20:17 +0200
Message-Id: <20180603182029.8914-1-erik.stromdahl@gmail.com> (sfid-20180603_202214_526617_5F4D72E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v4:

I have tried to reduce the number of patches to a
minimum for getting high latency up and running.

The hw_params items for the two QCA9377 based devices
included in the previous patchset (one Linksys USB and
one SDIO device) have been skipped, and thus there is
no board-2.bin support.

I have planned to submit them in separate patches later
(together with board-2.bin support).

USB might be even more broken due to a lot of ugly
special cases beeing removed.

The main issue with USB right now is that there are no
TX_COMPL_IND's from fw.

The special cases for handling this have been removed.
If needed, they could be added back in a future patch.

The rename of the *is_high_latency* boolean to ATH10K_HTT_MODE
ended up in a rename to ATH10K_DEV_TYPE instead,
 since this is not only related to HTT.

The start_once patch was removed as well.
SDIO seems to work well without it.
If needed by USB, we can add it in a future patch.

Erik Stromdahl (12):
  ath10k: add struct ath10k_bus_params
  ath10k: add device type enum to ath10k_bus_params
  ath10k: add bus type check in ath10k_init_hw_params
  ath10k: use hw_params.num_peers for num_tids in TLV init
  ath10k: add per target config of max_num_peers
  ath10k: DMA related fixes for high latency devices
  ath10k: add HTT TX HL ops
  ath10k: add HTT RX HL ops
  ath10k: htt: RX ring config HL support
  ath10k: htt: High latency TX support
  ath10k: htt: High latency RX support
  ath10k: wmi: disable softirq's while calling ieee80211_rx

 drivers/net/wireless/ath/ath10k/ahb.c     |   9 +-
 drivers/net/wireless/ath/ath10k/core.c    |  39 ++++--
 drivers/net/wireless/ath/ath10k/core.h    |  22 +--
 drivers/net/wireless/ath/ath10k/htc.c     |  19 ++-
 drivers/net/wireless/ath/ath10k/htt.h     |  47 +++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 135 ++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  | 155 +++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h      |   9 ++
 drivers/net/wireless/ath/ath10k/pci.c     |  13 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h |  15 +++
 drivers/net/wireless/ath/ath10k/sdio.c    |   8 +-
 drivers/net/wireless/ath/ath10k/snoc.c    |   5 +-
 drivers/net/wireless/ath/ath10k/txrx.c    |   3 +-
 drivers/net/wireless/ath/ath10k/usb.c     |   7 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   5 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |   3 +-
 16 files changed, 444 insertions(+), 50 deletions(-)

-- 
2.17.0
