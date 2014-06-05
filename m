Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58025 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFEH4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 03:56:19 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so620738wgh.8
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 00:56:17 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: pci fixes 2014-06-05
Date: Thu,  5 Jun 2014 09:48:38 +0200
Message-Id: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com> (sfid-20140605_095622_258688_E992C9A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've found a few issues while I was testing ath10k
in QEMU/KVM with PCI passthrough. The second patch
is something that I've found while analysing the
bmi race and I don't think anyone experienced
problems associated with it.

There's still a weird synchronization issue with
(what I think is) iomap write propagation. The
initial fw bootup interrupt doesn't come in and
it seems CE interrupts are unmasked with a lag
because explicit polling after ctl_resp timeout
seems to be sufficient to work around it. I
suspect this might be a virtualization problem
rather than ath10k. Ideas, anyone?


Michal Kazior (2):
  ath10k: fix bmi exchange tx/rx race
  ath10k: sanitize tx ring index access properly

 drivers/net/wireless/ath/ath10k/ce.c  | 11 +++++++----
 drivers/net/wireless/ath/ath10k/pci.c | 11 +++--------
 drivers/net/wireless/ath/ath10k/pci.h |  3 ++-
 3 files changed, 12 insertions(+), 13 deletions(-)

-- 
1.8.5.3

