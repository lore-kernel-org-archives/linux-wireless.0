Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49516 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3J3LpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:10 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so566222eek.6
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 00/12] ath10k: pci fixes 2013-10-30
Date: Wed, 30 Oct 2013 12:42:14 +0100
Message-Id: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124514_566187_95BFB833)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains a slew of PCI/CE cleanups
and fixes. The aim of the patchset is to deal with
CE null dereference bugs Ben has been reporting on
the mailing list for some time now.

I've done some brief testing and don't see any
major regressions. I wasn't able to reproduce the
reported bugs though. @Ben: Could you perhaps test
this, please?


Michal Kazior (12):
  ath10k: remove ar_pci->ce_count
  ath10k: don't forget to kill fw error tasklet
  ath10k: split tasklet killing function
  ath10k: rename function to match it's role
  ath10k: make sure to mask all CE irqs
  ath10k: fix ath10k_ce_init() failpath
  ath10k: remove meaningless check
  ath10k: use ath10k_do_pci_wake/sleep
  ath10k: propagate ath10k_ce_disable_interrupts() errors
  ath10k: guard against CE corruption from firmware
  ath10k: re-arrange PCI init code
  ath10k: add some debug prints

 drivers/net/wireless/ath/ath10k/ce.c  |  56 ++++++---
 drivers/net/wireless/ath/ath10k/ce.h  |   3 +-
 drivers/net/wireless/ath/ath10k/htc.c |   5 +
 drivers/net/wireless/ath/ath10k/pci.c | 221 ++++++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/pci.h |   3 -
 5 files changed, 161 insertions(+), 127 deletions(-)

-- 
1.8.4.rc3

