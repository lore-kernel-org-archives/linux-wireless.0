Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbbG3Swe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 14:52:34 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2015-07-30
Date: Thu, 30 Jul 2015 18:52:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E7DC508@hasmsx107.ger.corp.intel.com> (sfid-20150730_205238_243217_24126A2A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Here is another pull request for 4.2. Three small fixes this time.
Let me know if you have any issues.

Note that my availability will be limited next week, and the week after
I'll be completely offline.
Thanks!

The following changes since commit be88a1ada9b97bb016196b7f4a1fc2fe2f798529:

  iwlwifi: nvm: remove mac address byte swapping in 8000 family
(2015-07-12 19:54:19 +0300)

are available in the git repository at:

 
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-07-30

for you to fetch changes up to aecdc63d87891c75e60906973c7b7c9cd58403d6:

  iwlwifi: pcie: fix stuck queue detection for sleeping clients
(2015-07-30 21:38:14 +0300)

----------------------------------------------------------------
* a fix for the stuck TFD queue mechanism - it was producing
  noisy false alarms.
* a fix for the NIC prepare flow that prevented the driver
  from being able to access the device on certain systems.
* a fix for the scan prority handling which allows the
  regular scan to run even if a scheduled scan is already
  running.

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: Fix regular scan priority

Emmanuel Grumbach (2):
      iwlwifi: pcie: fix prepare card flow
      iwlwifi: pcie: fix stuck queue detection for sleeping clients

 drivers/net/wireless/iwlwifi/mvm/scan.c   |  2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c | 22 +++++++++++++++++++---
 drivers/net/wireless/iwlwifi/pcie/tx.c    | 15 +++++++++++++--
 3 files changed, 33 insertions(+), 6 deletions(-)

