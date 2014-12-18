Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaLRHxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 02:53:52 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "kvalo@codeaurora.com" <kvalo@codeaurora.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: pull request: iwlwifi 2014-12-18
Date: Thu, 18 Dec 2014 07:53:40 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com> (sfid-20141218_085356_646884_DA2DE9B2)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

First congrats on your new role - I am sure we'll find the way to work together in the new layout.
John - it was a pleasure. I stepped up as a maintainer of iwlwifi only a bit more than a year ago.
You had the patience to bear with me while I was doing my mistakes of the beginning.
Your signature is: "One day - the world will need a hero and you might be all we have - be ready".
Wireless used to be like Jeff described in the post you sent, but then came the "hero" and said:
https://lkml.org/lkml/2006/1/10/458
Thank you John - take care of yourself and who knows... we might see you again around :)

Back to work. This is for 3.19.
As usual, the details are below - let me know if you have issues.
Thanks!

The following changes since commit 70e71ca0af244f48a5dcf56dc435243792e3a495:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-12-11 14:27:06 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-fixes-for-kalle-2014-12-18

for you to fetch changes up to baa21e834941ee5fbe4bd421c871f7c0c5f9a086:

  iwlwifi: pcie: limit fw chunk sizes given to fh (2014-12-14 10:20:30 +0200)

----------------------------------------------------------------
I have here new device IDs and a fix for double free bug I introduced.
I also fix an issue with the RFKILL interrupt - the HW needs us to ACK
the interrupt again after we reset it.
Liad fixes an issue with the firmware debugging infrastructure.
While working on torture scenarios of firmware restarts, Eliad found an
issue which he fixed.

----------------------------------------------------------------
Eliad Peller (1):
      iwlwifi: mvm: clear IN_HW_RESTART flag on stop()

Emmanuel Grumbach (3):
      iwlwifi: pcie: re-ACK all interrupts after device reset
      iwlwifi: don't double free a pointer if no FW was found
      iwlwifi: add new device IDs for 3165

Liad Kaufman (1):
      iwlwifi: pcie: limit fw chunk sizes given to fh

 drivers/net/wireless/iwlwifi/iwl-drv.c      |  2 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 15 +++++++++++++--
 drivers/net/wireless/iwlwifi/pcie/drv.c     |  4 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c   | 17 +++++++++++------
 5 files changed, 30 insertions(+), 9 deletions(-)
