Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbbKOTah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 14:30:37 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2015-11-15
Date: Sun, 15 Nov 2015 19:30:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com> (sfid-20151115_203106_534527_A6F4B456)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Here is the first pull request for 4.4. I admit that the FW API is
borderline but since we are very early in the cycle, I think it is fine.
The firmware is far from being released yet (so that this patch doesn't
change much now), but having this patch in will allow me to provide the
new firmware to the 4.4 users.
Along with that various bug fixes, a fix for a NULL pointer exception
other things as explained in the tag.

Please pull - thanks!


The following changes since commit a493bcf8d6caf28f062c5f8f2ba486fdbf1ae899:

  Merge tag 'wireless-drivers-next-for-davem-2015-10-29' of
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next (2015-10-30
20:38:24 +0900)

are available in the git repository at:

 
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-11-15

for you to fetch changes up to 9513c5e18a0dc55a1fc9c890715098ba2315830b:

  iwlwifi: mvm: Avoid dereferencing sta if it was already flushed
(2015-11-15 21:18:01 +0200)

----------------------------------------------------------------
* bump API to firmware 19 - not released yet.
* fix D3 flows (Luca)
* new device IDs (Oren)
* fix NULL pointer dereference (Avri)

----------------------------------------------------------------
Avri Altman (1):
      iwlwifi: mvm: Avoid dereferencing sta if it was already flushed

Emmanuel Grumbach (1):
      iwlwifi: bump firmware API to 19

Luca Coelho (1):
      iwlwifi: mvm: don't overwrite the key indices in D3 entry

Oren Givon (1):
      iwlwifi: Add new PCI IDs for the 8260 series

 drivers/net/wireless/iwlwifi/iwl-7000.c     |  2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  8 ++------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 11 ++++++++---
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 88
+++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/drv.c     | 19 ++++++++++++++++++-
 7 files changed, 79 insertions(+), 55 deletions(-)

