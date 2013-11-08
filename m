Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55953 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3KHHEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:46 -0500
Received: by mail-ea0-f177.google.com with SMTP id f15so831676eak.8
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:45 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 00/13] ath10k: pci fixes 2013-10-30
Date: Fri,  8 Nov 2013 08:01:22 +0100
Message-Id: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080451_438773_43049334)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains a slew of PCI/CE cleanups
and fixes. The aim of the patchset is to deal with
CE null dereference bugs Ben has been reporting on
the mailing list for some time now.

v2:
 * fix prints
 * fix commit messages
 * add additional patch
   (ath10k: reset device upon stopping/power down)


Michal Kazior (13):
  ath10k: remove ar_pci->ce_count
  ath10k: don't forget to kill fw error tasklet
  ath10k: split tasklet killing function
  ath10k: rename ath10k_pci_reset_target()
  ath10k: make sure to mask all CE irqs
  ath10k: fix ath10k_ce_init() failpath
  ath10k: remove meaningless check
  ath10k: use ath10k_do_pci_wake/sleep
  ath10k: propagate ath10k_ce_disable_interrupts() errors
  ath10k: guard against CE corruption from firmware
  ath10k: re-arrange PCI init code
  ath10k: add and fix some PCI prints
  ath10k: reset device upon stopping/power down

 drivers/net/wireless/ath/ath10k/ce.c  |  57 +++++--
 drivers/net/wireless/ath/ath10k/ce.h  |   3 +-
 drivers/net/wireless/ath/ath10k/htc.c |   5 +
 drivers/net/wireless/ath/ath10k/pci.c | 293 ++++++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/pci.h |   3 -
 5 files changed, 205 insertions(+), 156 deletions(-)

-- 
1.8.4.rc3

