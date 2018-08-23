Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:6039 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727247AbeHWPQk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:40 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 0/9] wil6210 patches
Date: Thu, 23 Aug 2018 14:47:04 +0300
Message-Id: <1535024833-15178-1-git-send-email-merez@codeaurora.org> (sfid-20180823_134721_962276_2DEE22F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The followings et of patches include:
- Various wil6210 fixes
- Add FT roam support for AP and station
- Add support for channel 4

Ahmad Masri (1):
  wil6210: add FT roam support for AP and station

Alexei Avshalom Lazar (1):
  wil6210: add support for channel 4

Dedy Lansky (2):
  wil6210: drop Rx multicast packets that are looped-back to STA
  wil6210: fix invalid memory access for rx_buff_mgmt debugfs

Karthick Gopalasubramanian (1):
  wil6210: remove reset file from debugfs

Maya Erez (4):
  wil6210: set edma variables only for Talyn-MB devices
  wil6210: allocate rx reorder buffer only if rx reorder is enabled
  wil6210: prevent usage of tx ring 0 for eDMA
  wil6210: fix RX buffers release and unmap

 drivers/net/wireless/ath/wil6210/cfg80211.c   | 333 ++++++++++++++++++++----
 drivers/net/wireless/ath/wil6210/debugfs.c    |  47 ++--
 drivers/net/wireless/ath/wil6210/main.c       |  13 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |   1 +
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  12 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  98 +++++++-
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |  26 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  19 ++
 drivers/net/wireless/ath/wil6210/wmi.c        | 350 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.h        |   2 +
 10 files changed, 799 insertions(+), 102 deletions(-)

-- 
1.9.1
