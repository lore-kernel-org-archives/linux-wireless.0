Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:45351 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LRXhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 18:37:46 -0500
From: Henrik Austad <henrik@austad.us>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Henrik Austad <henrik@austad.us>
Subject: [PATCH 00/10] update of make iwlwifi RT friendly
Date: Thu, 19 Dec 2013 00:25:55 +0100
Message-Id: <1387409165-28319-1-git-send-email-henrik@austad.us> (sfid-20131219_003758_451897_5EE04E25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a move of the series posted by Emmanuel a few days ago to the
tip of Linus' master. It also applies pretty easily to 3.12.5-rt5

0010: iwlwifi: pcie: stop using _irqsave
  * There's no function iwl_trans_pcie_op_mode_leave(), instead
    iwl_trans_pcie_stop_hw() was updated

A part from that, the port was relatively straight forward, but someone
should probably have a look to make sure I didn't miss anything

So, some tests on my laptop (Lenovo X220, i5-2520M)

3.12.1-rt4 (which has Sebastians iwlwifi workaround):

cyclictest -p80 -i 1000 -l500000 -a -n -m -t2
# /dev/cpu_dma_latency set to 0us
policy: fifo: loadavg: 0.40 2.19 1.69 2/513 4682

T: 0 ( 4118) P:80 I:1000 C: 500000 Min:      2 Act:   12 Avg:    8 Max:      47
T: 1 ( 4119) P:80 I:1500 C: 333338 Min:      2 Act:   20 Avg:   11 Max:      49

Over time (~6hr run), Max grew to about 300us

3.12.5-rt6 (with the iwlwifi patches):
cyclictest -p80 -i 1000 -a -n -m -t2
# /dev/cpu_dma_latency set to 0us
policy: fifo: loadavg: 0.35 0.44 0.40 2/518 4244

T: 0 ( 3132) P:80 I:1000 C:1492239 Min:      2 Act:    3 Avg:    2 Max:    3089
T: 1 ( 3133) P:80 I:1500 C: 994824 Min:      2 Act:    3 Avg:    4 Max:    2206

Granted, this was a longer run, but a 3ms spike is pretty awful. Still
trying to recreate that with traces running, but no luck so
far. Removing the iwlwifi module gives low values for cyclictest,
consistent with 3.12.1-rt4 (with iwlwifi disabled).



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

 drivers/net/wireless/iwlwifi/iwl-csr.h       |    3 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h |    9 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  393 +++++++++++---------------
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   25 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   10 +-
 5 files changed, 184 insertions(+), 256 deletions(-)

-- 
1.7.10.4

