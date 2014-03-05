Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbaCEMKx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:10:53 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 0/9] iwlegacy rework rx allocation
Date: Wed,  5 Mar 2014 13:13:25 +0100
Message-Id: <1394021614-11514-1-git-send-email-sgruszka@redhat.com> (sfid-20140305_131057_230976_D8160A75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those patches replace compicated rx allocation algoritm with
simple one which always assure we have RX buffers ready for 
firmware. This fix long standing problem with microcode errors
when system is under load.

I tested them only on 4965.  

Stanislaw Gruszka (9):
  iwlegacy: add pkt pointer to command
  iwlegacy: use CMD_COPY_PKT on il3945_get_measurement
  iwlegacy: use CMD_COPY_PKT on il_send_scan_abort
  iwlegacy: use CMD_COPY_PKT on il_send_add_sta
  iwlegacy: use CMD_COPY_PKT on il_send_remove_station
  iwlegacy: use CMD_COPY_PKT on il3945_send_rxon_assoc
  iwlegacy: get rit of CMD_WANT_SKB
  iwlegacy: treat RX notify specially
  iwlegacy: rework rx buffers allocation

 drivers/net/wireless/iwlegacy/3945-mac.c | 495 +++++--------------------------
 drivers/net/wireless/iwlegacy/3945.c     |  74 ++---
 drivers/net/wireless/iwlegacy/3945.h     |   8 +-
 drivers/net/wireless/iwlegacy/4965-mac.c | 447 +++++-----------------------
 drivers/net/wireless/iwlegacy/4965.h     |   6 +-
 drivers/net/wireless/iwlegacy/common.c   | 348 ++++++++++++++--------
 drivers/net/wireless/iwlegacy/common.h   |  71 ++---
 drivers/net/wireless/iwlegacy/debug.c    |   3 -
 8 files changed, 432 insertions(+), 1020 deletions(-)

-- 
1.7.11.7

