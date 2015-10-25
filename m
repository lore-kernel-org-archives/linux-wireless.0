Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbbJYL6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 07:58:49 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2015-10-25
Date: Sun, 25 Oct 2015 11:58:03 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com> (sfid-20151025_125852_851231_D944128A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Last (obviously) pull request for 4.4.
I came back from a long vacation and took maintenance over back from Luca.
Please note that you'll have to merge mac80211-next/master (or net-next)
before you pull from me. I created this pull request giving
mac80211-next/master
as the start point to have the correct output.
I hope it will still make it.

Details in the tag.

Thank!

The following changes since commit e5a9f8d04660da7ef3a98260aa74c3976f9cb4cd:

  mac80211: move station statistics into sub-structs (2015-10-21
10:08:22 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git

for you to fetch changes up to 2edb7a3372c76c9379d0fc00e4274ea8f018248a:

  iwlwifi: nvm: free old section data when reading nvm file (2015-10-25
13:45:09 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: rs: Remove workaround that disables MIMO on P2P

Andrei Otcheretianski (1):
      iwlwifi: mvm: Implement per vif frame registration API

Arik Nemtsov (2):
      iwlwifi: mvm: correctly request DTS-measure for new cards
      iwlwifi: mvm: disable TDLS ac queues correctly

Assaf Krauss (1):
      iwlwifi: mvm: Allow setting ctrl-chnl-position in FTM responder

Avraham Stern (1):
      iwlwifi: mvm: Add support for two scheduled scan plans

Eliad Peller (2):
      iwlwifi: avoid read/write operations if the bus is dead
      iwlwifi: mvm: take scan ref only on success

Emmanuel Grumbach (2):
      Merge remote-tracking branch 'mac80211-next/master' into next
      iwlwifi: pcie: fix (again) prepare card flow

Johannes Berg (4):
      iwlwifi: mvm: use wowlan RX/TX timeouts in D0i3
      iwlwifi: mvm: use short timeouts in P2P low latency if supported
      iwlwifi: mvm: clean up some whitespace in scan code
      iwlwifi: mvm: remove pointless scan plan checks

Luca Coelho (1):
      iwlwifi: mvm: let any command flag be passed to iwl_mvm_flushtx_path()

Matti Gottlieb (1):
      iwlwifi: mvm: Dump FW's virtual image in the case of a NIC error

Moshe Harel (1):
      iwlwifi: nvm: free old section data when reading nvm file

 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |   4 ++++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   2 ++
 drivers/net/wireless/iwlwifi/mvm/constants.h     |   4 +++-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c   |  25
++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   |   5 +++--
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        |  63
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |   3 +++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |  67
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |   2 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c           |   1 +
 drivers/net/wireless/iwlwifi/mvm/power.c         |  41
+++++++++++++++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/rs.c            |   6 ------
 drivers/net/wireless/iwlwifi/mvm/scan.c          | 120
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/sta.c           |   9 +++++----
 drivers/net/wireless/iwlwifi/mvm/time-event.c    |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c            |  11 +++++++++--
 drivers/net/wireless/iwlwifi/mvm/tx.c            |   4 +---
 drivers/net/wireless/iwlwifi/pcie/trans.c        |  10 ++--------
 20 files changed, 296 insertions(+), 101 deletions(-)

