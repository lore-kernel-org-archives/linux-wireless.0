Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42613 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaFNNsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:48:20 -0400
Received: by mail-pb0-f46.google.com with SMTP id md12so2158833pbc.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:48:19 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id ci4sm8993152pbb.50.2014.06.14.06.48.17
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:48:18 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/16] Fixes, adding support for 5GHz, bgscan and 40MHz.
Date: Sat, 14 Jun 2014 19:18:09 +0530
Message-Id: <1402753689-13819-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_154827_352350_921CBDDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches contains fixes, adds support for
5GHz and bgscan and 40MHz.

Jahnavi Meher (16):
  rsi: Mapping the debugfs stats to the correct s/w queues.
  rsi: Fixed the kernel doc
  rsi: Using band from rsi_common to fill in ieee80211_rx_status
  rsi: Add macros for endpoints and set default value of endpoint.
  rsi: Changed the radio caps frame.
  rsi: Changed the rsi_set_channel() and rsi_program_bb_rf().
  rsi: Changed rate handling.
  rsi: Lower level debug messages and changed handling of confirm    
    received for rsi_program_bb_rf().
  rsi: Use SGI if configured for fixed rate transmission.
  rsi: Changed the SDIO interrupt variables and some clean up.
  rsi: Changed the logic of dequeuing packets from hal queues.
  rsi: Added debug messages.
  rsi: Sending QoS null packet via the mgmt queue.
  rsi: Adding support for 5GHz
  rsi: Adding support for host based bgscan.
  rsi: Changes for 40MHz

 drivers/net/wireless/rsi/rsi_91x_core.c     |   85 +++++++---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  143 ++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  236 +++++++++++++++++++--------
 drivers/net/wireless/rsi/rsi_91x_pkt.c      |   17 ++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    8 +-
 drivers/net/wireless/rsi/rsi_main.h         |   12 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         |   25 +++-
 drivers/net/wireless/rsi/rsi_sdio.h         |    8 +-
 9 files changed, 416 insertions(+), 128 deletions(-)

