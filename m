Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63673 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaENMXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 08:23:33 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so1291418eek.18
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 05:23:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: fixes 2014-05-14
Date: Wed, 14 May 2014 14:16:24 +0200
Message-Id: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com> (sfid-20140514_142337_785233_D8D570B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is another pair of patches.

It fixes a crash recently reported by Ben, but..

I've been able to find only a single code path
that called free_irq() twice in upstream code.
However it doesn't match the call trace reported
by Ben. I have to assume this is related to his
local patches or this is a very wierd case of
recovery race between userspace/mac80211/driver.


Michal Kazior (2):
  ath10k: fix core start sequence
  ath10k: prevent hif_stop being called twice

 drivers/net/wireless/ath/ath10k/core.c   | 101 +++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/htc.c    |   6 --
 drivers/net/wireless/ath/ath10k/htt.c    |  42 +------------
 drivers/net/wireless/ath/ath10k/htt.h    |  18 +++---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   8 +--
 drivers/net/wireless/ath/ath10k/pci.c    |   3 +
 drivers/net/wireless/ath/ath10k/wmi.c    |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.h    |   2 +-
 9 files changed, 79 insertions(+), 107 deletions(-)

-- 
1.8.5.3

