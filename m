Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37514 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaGULUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 07:20:11 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so6216369wgh.26
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 04:20:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>, sw@simonwunderlich.de,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: scan fixes 2014-07-21
Date: Mon, 21 Jul 2014 13:11:19 +0200
Message-Id: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com> (sfid-20140721_132016_374817_1689AD48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This addresses an issue found by Janusz with
current spectral scan patches from Simon.

This goes along patch `ath10k: prevent endless pci rx
loop` I've posted a few days ago.

There seems to be a condition in firmware which
causes some WMI events to be not delivered by
firmware to host most likely due to CE/PCI pipe
being full (that's a guess judging by the huge
amount of phyerrs reported and their behaviour
while spectral scan is enabled). This also
suggests some SWBA events may be dropped by
firmware when spectral scan is running (same goes
for management rx).

@Simon: you may be interested in applying these
patches if you run into trouble while testing
spectral scan + hw_scan/hw_roc.

@Ben: since you reported some scan issues in the
past you may be interested in this as well.


Michal Kazior (2):
  ath10k: introduce a stricter scan state machine
  ath10k: simplify scan debug prints

 drivers/net/wireless/ath/ath10k/core.c |   4 +-
 drivers/net/wireless/ath/ath10k/core.h |  10 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 219 +++++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/mac.h  |   3 +-
 drivers/net/wireless/ath/ath10k/wmi.c  | 210 ++++++++++++++++++++++---------
 5 files changed, 290 insertions(+), 156 deletions(-)

-- 
1.8.5.3

