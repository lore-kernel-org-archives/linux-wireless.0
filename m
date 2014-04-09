Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:36713 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbaDIKz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:55:29 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so1747037eek.10
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:55:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFTv2 0/5] ath10k: ath10k: fix flushing and tx stalls
Date: Wed,  9 Apr 2014 12:48:46 +0200
Message-Id: <1397040531-6224-1-git-send-email-michal.kazior@tieto.com> (sfid-20140409_125533_279023_BAC89E56)
In-Reply-To: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After digging around I've found what seems to be
the problem with WMI Tx credit starvation and
inability to properly flush Tx in ath10k_flush().

Long story short: if a client that was asleep (as
per what firmware thinks) goes out of range (or
just stops responding) then Tx rots in FW/HW
queues for a few seconds before it's discarded.
For WMI Tx credits this means management frames
eat up Tx credits for a few seconds (causing other
WMI commands to timeout and return -EAGAIN/-11).
For HTT Tx this means NullFunc frames would get
stuck for a few seconds before completion was
received.

v2:
 * added tx replenishment patch
 * added conf_mutex locking
 * change condition for flushing mgmt tx


Michal Kazior (5):
  ath10k: always request htc tx replenishment
  ath10k: fix wmi-htc tx credit starvation
  ath10k: rework peer accounting
  ath10k: wait for mgmt tx when flushing too
  ath10k: improve tx flushing

 drivers/net/wireless/ath/ath10k/core.h |   7 +-
 drivers/net/wireless/ath/ath10k/htc.c  |  15 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 275 ++++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/txrx.c |  29 ++--
 drivers/net/wireless/ath/ath10k/wmi.c  |   5 -
 drivers/net/wireless/ath/ath10k/wmi.h  |   4 +
 6 files changed, 275 insertions(+), 60 deletions(-)

-- 
1.8.5.3

