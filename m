Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17504 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752459AbdBUOcN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 09:32:13 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 00/10] wil6210 patches
Date: Tue, 21 Feb 2017 16:31:58 +0200
Message-Id: <1487687528-12832-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170221_153216_628010_5334F27B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

various wil6210 patches

Dedy Lansky (4):
  wil6210: use print_hex_dump_debug instead of print_hex_dump_bytes
  wil6210: store bss object and use cfg80211_connect_bss()
  wil6210: use WMI_DISCONNECT_CMDID upon connect timeout
  wil6210: correctly report locally generated disconnect in STA mode

Hamad Kadmany (2):
  wil6210: set dma mask to reflect device capability
  wil6210: protect list of pending wmi events during flush

Lior David (3):
  wil6210: do not start regular scan on stopped p2p device
  wil6210: bus_request platform operation refinement
  wil6210: add oob_mode for AP certification

Maya Erez (1):
  wil6210: missing reinit_completion in HALP voting

 drivers/net/wireless/ath/wil6210/cfg80211.c | 68 ++++++++++++++------------
 drivers/net/wireless/ath/wil6210/main.c     | 75 +++++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 16 ++++++
 drivers/net/wireless/ath/wil6210/pmc.c      | 17 ++++++-
 drivers/net/wireless/ath/wil6210/txrx.c     | 19 +++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h  | 21 +++++++-
 drivers/net/wireless/ath/wil6210/wmi.c      | 21 ++++++--
 7 files changed, 183 insertions(+), 54 deletions(-)

-- 
1.9.1
