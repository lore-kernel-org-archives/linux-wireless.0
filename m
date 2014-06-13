Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44754 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaFMOnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 10:43:08 -0400
Received: by mail-pa0-f48.google.com with SMTP id et14so939599pad.21
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2014 07:43:07 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id xk3sm4004074pbb.65.2014.06.13.07.43.06
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 13 Jun 2014 07:43:07 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/5] Fixes, changes for 40MHz and adding support for 5GHz and bgscan.
Date: Fri, 13 Jun 2014 20:12:59 +0530
Message-Id: <1402670579-8818-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140613_164313_334706_6EA818C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches contains some fixes, adds support for
5GHz and bgscan and contains changes required for 40MHz. Also
the logic related to dequeuing of packets from hal has been
changed.

Jahnavi Meher (5):
  Fixes and clean up of code
  Change the logic for dequeuing packets in hal.
  Adding support for 5GHz.
  Adding support for host based bgscan
  Changes for 40MHz

 drivers/net/wireless/rsi/rsi_91x_core.c     |   85 +++++++---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  143 ++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  237 +++++++++++++++++++--------
 drivers/net/wireless/rsi/rsi_91x_pkt.c      |   17 ++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    8 +-
 drivers/net/wireless/rsi/rsi_main.h         |   12 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         |   25 +++-
 drivers/net/wireless/rsi/rsi_sdio.h         |    8 +-
 9 files changed, 416 insertions(+), 129 deletions(-)

