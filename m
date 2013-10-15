Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50685 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JORc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:26 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so9098214pbb.41
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/7] ath10k: fixes 2013-10-15
Date: Tue, 15 Oct 2013 10:29:49 -0700
Message-Id: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193230_191539_23A89085)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a bunch of fixes I've had queued up for
some time now. I was reluctant to send them
without some additional checks and because some of
the fixes are not ideal. At least we can get a
discussion going if anything raises any serious
concern.


Michal Kazior (7):
  ath10k: prevent starting monitor without a vdev
  ath10k: add sanity checks for monitor management
  ath10k: fix endianess in prints
  ath10k: fix NSS reporting in RX
  ath10k: fix NULL deref upon early FW crash
  ath10k: fix device initialization routine
  ath10k: fix FW crashes on heavy TX on 10.1.389 AP FW

 drivers/net/wireless/ath/ath10k/ce.c     |  11 +++
 drivers/net/wireless/ath/ath10k/core.c   |   3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  11 +--
 drivers/net/wireless/ath/ath10k/hw.h     |   7 ++
 drivers/net/wireless/ath/ath10k/mac.c    |  24 +++++-
 drivers/net/wireless/ath/ath10k/pci.c    | 130 +++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/txrx.c   |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |  16 ++--
 8 files changed, 134 insertions(+), 70 deletions(-)

-- 
1.8.4.rc3

