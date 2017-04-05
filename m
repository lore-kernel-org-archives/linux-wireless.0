Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5508 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932926AbdDEL6V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:58:21 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 00/11] wil6210 patches
Date: Wed,  5 Apr 2017 14:58:03 +0300
Message-Id: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170405_142543_627871_8A858E9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various wil6210 fixes

Dedy Lansky (3):
  wil6210: align to latest auto generated wmi.h
  wil6210: fix memory access violation in wil_memcpy_from/toio_32
  wil6210: fix array out of bounds access in pmc

Hamad Kadmany (3):
  wil6210: fix sequence for scan-abort during reset
  wil6210: fix protection against connections during reset
  wil6210: fix check for sparrow D0 FW file

Lazar Alexei (1):
  wil6210: restore power save state after internal FW reset

Lior David (1):
  wil6210: support 8KB RX buffers

Maya Erez (3):
  wil6210: protect against sporadic interrupt during suspend flow
  wil6210: remove HALP voting in debugfs ioblob
  wil6210: prevent access to 11AD device if resume fails

 drivers/net/wireless/ath/wil6210/cfg80211.c   | 12 +----
 drivers/net/wireless/ath/wil6210/debugfs.c    |  5 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c     |  4 +-
 drivers/net/wireless/ath/wil6210/main.c       | 65 ++++++++++++++++--------
 drivers/net/wireless/ath/wil6210/pm.c         | 27 +++++++++-
 drivers/net/wireless/ath/wil6210/pmc.c        |  4 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 12 ++++-
 drivers/net/wireless/ath/wil6210/txrx.c       | 24 ++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h    | 13 ++---
 drivers/net/wireless/ath/wil6210/wmi.c        | 14 +++--
 drivers/net/wireless/ath/wil6210/wmi.h        | 73 +++++++++++++++++++--------
 11 files changed, 178 insertions(+), 75 deletions(-)

-- 
1.9.1
