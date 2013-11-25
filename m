Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:63765 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3KYNKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 08:10:19 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so2333077eaj.26
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 05:10:18 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/8] ath10k: pci fixes 2013-11-22
Date: Mon, 25 Nov 2013 14:06:19 +0100
Message-Id: <1385384787-12470-1-git-send-email-michal.kazior@tieto.com> (sfid-20131125_141036_371917_43E3CB67)
In-Reply-To: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
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

v2:
 * simplify ath10k_pci_irq_pending()
 * combine memory leak fix patch with a
   functionality decoupling (it's very closely
   related)
 * fix 'irq: nobody cared'
 * change MSI/MSI-X disabling parameters
 * some minor fixes & code shuffling to avoid
   forward declarations


Michal Kazior (8):
  ath10k: don't consume other's shared interrupts
  ath10k: split up pci irq code
  ath10k: don't use interrupts for BMI
  ath10k: decouple ath10k_pci_start_ce()
  ath10k: defer irq registration until hif start()
  ath10k: extract functions for legacy irq handling
  ath10k: re-add support for early fw indication
  ath10k: allow explicit MSI/MSI-X disabling

 drivers/net/wireless/ath/ath10k/ce.c  |  15 -
 drivers/net/wireless/ath/ath10k/ce.h  |   1 -
 drivers/net/wireless/ath/ath10k/hw.h  |   1 +
 drivers/net/wireless/ath/ath10k/pci.c | 577 ++++++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h |   1 +
 5 files changed, 383 insertions(+), 212 deletions(-)

-- 
1.8.4.rc3

