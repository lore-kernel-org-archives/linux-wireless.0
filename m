Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47041 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3KVNIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:08:44 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so494913ead.8
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:08:40 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/8] ath10k: pci fixes 2013-11-22
Date: Fri, 22 Nov 2013 14:05:10 +0100
Message-Id: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com> (sfid-20131122_140901_162834_87907C8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

ath10k didn't play well with other devices on a
shared irq line. This patchset fixes support for
shared legacy interrupts. 

Some rework was necessary because ath10k was using
disable_irq and CE irq masking (which is not
sufficient for shared interrupts).

Since main irq handlers are now registered after
boot, BMI is now polling for CE updates. I haven't
observed any differences in boot speed.

Also this plugs a leak I spotted during rework and
adds an option for testing different irq modes.


Michal Kazior (8):
  ath10k: don't consume other's shared interrupts
  ath10k: split up pci irq code
  ath10k: fix memory leak on hif_start failpath
  ath10k: don't use interrupts for BMI
  ath10k: defer irq registration until hif start()
  ath10k: extract functions for legacy irq handling
  ath10k: re-add support for early fw indication
  ath10k: allow explicit MSI/MSI-X disabling

 drivers/net/wireless/ath/ath10k/hw.h  |   1 +
 drivers/net/wireless/ath/ath10k/pci.c | 503 ++++++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h |   1 +
 3 files changed, 333 insertions(+), 172 deletions(-)

-- 
1.8.4.rc3

