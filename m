Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63105 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaK0JXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 04:23:44 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so5887053wgh.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 01:23:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/7] ath10k: add support for new wmi-tlv backend
Date: Thu, 27 Nov 2014 10:11:14 +0100
Message-Id: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com> (sfid-20141127_102354_570757_452C6088)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First 2 patches are simple fixes. Patch 3 isn't
strictly related to wmi-tlv but I decided to
include it anyway. Other patches gradually
implement wmi-tlv.

There's a bunch of false-positive checkpatch
warnings regarding `CHECK: No space is necessary
after a cast`.

v2:
 * a lot of fixes (see notes on patch #7)

Michal Kazior (7):
  ath10k: fix wmi svc bitmap dbg print
  ath10k: add sanity checks for service bmap parsing
  ath10k: make wmi service bitmap non-debug
  ath10k: implement intermediate event args
  ath10k: introduce wmi ops
  ath10k: make some wmi functions public
  ath10k: implement wmi-tlv backend

 drivers/net/wireless/ath/ath10k/Makefile   |    1 +
 drivers/net/wireless/ath/ath10k/ce.c       |    2 +
 drivers/net/wireless/ath/ath10k/core.c     |    4 +
 drivers/net/wireless/ath/ath10k/core.h     |    6 +-
 drivers/net/wireless/ath/ath10k/debug.c    |   12 +-
 drivers/net/wireless/ath/ath10k/debug.h    |    9 -
 drivers/net/wireless/ath/ath10k/hw.h       |    9 +
 drivers/net/wireless/ath/ath10k/mac.c      |   47 +
 drivers/net/wireless/ath/ath10k/spectral.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h  |  820 ++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  | 2218 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h  | 1380 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 1359 ++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h      |  386 +++--
 14 files changed, 5593 insertions(+), 661 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-ops.h
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-tlv.c
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-tlv.h

-- 
1.8.5.3

