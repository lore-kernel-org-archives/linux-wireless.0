Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44827 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab3CINFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 08:05:03 -0500
Subject: [PATCH v2 0/7] ath6kl: tracing support
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 15:04:57 +0200
Message-ID: <20130309130223.13371.75809.stgit@localhost6.localdomain6> (sfid-20130309_140519_809011_D670FA16)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Second version of the tracing support to ath6kl. Changes based on Johannes' comments.

v2:

o simplify sdio trace calls so that their overhead is smaller when tracing is disabled

o add ath6kl_sdio_scat for scatter gather

o uninline ath6kl_info/warn/err() functions, fixes a compilation warning

---

Kalle Valo (7):
      ath6kl: add tracing support and tracing points for wmi packets
      ath6kl: add tracing points for sdio transfers
      ath6kl: add tracing point for hif irqs
      ath6kl: adding tracing points for htc_mbox
      ath6kl: convert ath6kl_info/err/warn macros to real functions
      ath6kl: add tracing support to log functions
      ath6kl: add tracing support to debug message macros


 drivers/net/wireless/ath/ath6kl/Kconfig    |    9 +
 drivers/net/wireless/ath/ath6kl/Makefile   |    5 
 drivers/net/wireless/ath/ath6kl/debug.c    |   66 +++++-
 drivers/net/wireless/ath/ath6kl/debug.h    |   11 -
 drivers/net/wireless/ath/ath6kl/hif.c      |    3 
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   21 ++
 drivers/net/wireless/ath/ath6kl/sdio.c     |   10 +
 drivers/net/wireless/ath/ath6kl/trace.c    |   23 ++
 drivers/net/wireless/ath/ath6kl/trace.h    |  332 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c     |    3 
 drivers/net/wireless/ath/ath6kl/wmi.c      |    3 
 11 files changed, 474 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.h

