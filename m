Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40190 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaDDLoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 07:44:11 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so3249544wgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 04:44:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFT 0/4] ath10k: fix flushing and tx stalls
Date: Fri,  4 Apr 2014 13:37:40 +0200
Message-Id: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> (sfid-20140404_134418_904297_B212643F)
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

@Ben: Can you check if this helps you? I tested
this briefly and at least [1/4] seems fixes the
WMI Tx starvation. I'm hoping patches 2-4 help
with your ath10k_flush() failures which I haven't
been successfull in reproducing (but have observed
improvement with purging some frames out of FW/HW
queues).


Michal Kazior (4):
  ath10k: fix wmi-htc tx credit starvation
  ath10k: rework peer accounting
  ath10k: wait for mgmt tx when flushing too
  ath10k: improve tx flushing

 drivers/net/wireless/ath/ath10k/core.h |   7 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 254 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/txrx.c |  29 ++--
 drivers/net/wireless/ath/ath10k/wmi.c  |   5 -
 drivers/net/wireless/ath/ath10k/wmi.h  |   4 +
 5 files changed, 253 insertions(+), 46 deletions(-)

-- 
1.8.5.3

