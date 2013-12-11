Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab3LKIey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 03:34:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 00/10] make iwlwifi RT friendly
Date: Wed, 11 Dec 2013 10:33:35 +0200
Message-Id: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131211_093500_976789_EB353A33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RT folks have raised issues with iwlwifi wrt. RT kernel some time
ago. Johannes had a few patches to address this, but I had a few
concerns with them. This series tries to address the RT concerns:
* we don't do anything in hard-irq context besides stopping the
  interrupts in the device.
* the interrupt cause is read from the irq handler and is handled
  there.

This allows us to avoid the usage of _irqsave all over the driver
and also avoids any kind of locks in the hard-irq context.
We still have some work to do with the locks in the handler.
I believe the locking model can be improved there.

This patch series is split is very small patches. While this can
annoy the reader - it helped me much to make sure I don't do anything
wrong (well - I am still not sure) - and IMHO, it makes the review easier.
For example, in patch 
    iwlwifi: pcie: move the ICT / non-ICT handling functions
I just copy code from place to place without changing a bit. This makes
the significant diff smaller.

Emmanuel Grumbach (10):
  iwlwifi: pcie: clean up ICT allocation code
  iwlwifi: pcie: track interrupt mask in SW
  iwlwifi: pcie: re-organize the PCIe ISR code
  iwlwifi: pcie: move the ICT / non-ICT handling functions
  iwlwifi: pcie: read the interrupt cause from the handler
  iwlwifi: pcie: determine the interrupt type in the handler
  iwlwifi: pcie: return inta from iwl_pcie_int_cause_{non_}ict
  iwlwifi: pcie: no need to save inta in trans_pcie
  iwlwifi: pcie: move interrupt prints to the common handler
  iwlwifi: pcie: stop using _irqsave

 drivers/net/wireless/iwlwifi/iwl-csr.h       |   3 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h |   9 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 389 +++++++++++----------------
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  27 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       |  10 +-
 5 files changed, 185 insertions(+), 253 deletions(-)

-- 
1.8.3.2

