Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41125 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaHENFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 09:05:55 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so6869800wib.4
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2014 06:05:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 0/2] ath10k: scan fixes 2014-07-21
Date: Tue,  5 Aug 2014 14:54:42 +0200
Message-Id: <1407243284-19803-1-git-send-email-michal.kazior@tieto.com> (sfid-20140805_150559_043177_F5560425)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

v2:
 * addressed some comments from Kalle
 * fixed a few more issues


Michal Kazior (2):
  ath10k: simplify scan debug prints
  ath10k: introduce a stricter scan state machine

 drivers/net/wireless/ath/ath10k/core.c |   5 +-
 drivers/net/wireless/ath/ath10k/core.h |  27 +++-
 drivers/net/wireless/ath/ath10k/mac.c  | 238 ++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/mac.h  |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.c  | 208 +++++++++++++++++++---------
 5 files changed, 317 insertions(+), 165 deletions(-)

-- 
1.8.5.3

