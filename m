Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39106 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EIH0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 03:26:11 -0400
Message-ID: <4FAA1C0C.1080804@qca.qualcomm.com> (sfid-20120509_092615_383363_E399662D)
Date: Wed, 9 May 2012 10:26:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Pull request: ath6kl 20120509
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's an ath6kl pull request for 3.5, I hope there's enough time still
to get this in.

There's not anything exciting here, lots of small fixes everywhere. The
only patch standing out is Ray Chen's patch adding support to our newest
baby AR6004 hw1.2, and even that is just adding a new item to struct
ath6kl_hw list.

Oddly enough the original diffstat from git merge-request was really
scary, it claimed that this merge request was adding htc_pipe.c to
ath6kl. I do have actually submitted that already earlier, I don't know
what went wrong but I just added a new diffstat manually. Please let me
know if there are any problems.

The following changes since commit 341352d13dae752610342923c53ebe461624ee2c:

  iwlwifi: fix-up some merge damage from commit 0d6c4a2 (2012-05-08
22:18:09 -0400)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Dan Carpenter (3):
      ath6kl: list_first_entry() is never NULL
      ath6kl: change || to &&
      ath6kl: fix an indenting issue

Jesper Juhl (1):
      ath6kl: fix memory leak in ath6kl_fwlog_block_read()

Jouni Malinen (2):
      ath6kl: Remove incorrect Probe Response offload support for
Interworking
      ath6kl: Configure probed SSID list consistently

Kalle Valo (2):
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: merge split format strings into one

Kevin Fang (2):
      ath6kl: handle background(BK) stream properly on htc mbox layer
      ath6kl: assign Tx packet drop threshold per endpoint on htc pipe layer

Luis R. Rodriguez (1):
      ath6kl: include in.h explicitly

Ming Jiang (2):
      ath6kl: allow deepsleep_suspend function when wlan interface down
      ath6kl clear the MMC_PM_KEEP_POWER for cutpower case

Naveen Gangadharan (1):
      ath6kl: Multicast filter support in wow suspend and non-suspend

Raja Mani (1):
      ath6kl: Retain bg scan period value modified by the user

Ray Chen (2):
      ath6kl: Add AR6004 1.2 support for USB and SDIO
      ath6kl: Fix system crash sometimes for USB hotplug

Subramania Sharma Thandaveswaran (1):
      ath6kl: Fix bug in bg scan configuration in schedule scan

Thomas Pedersen (6):
      ath6kl: handle concurrent AP-STA channel switches
      ath6kl: support fw reporting phy capabilities
      ath6kl: only restore supported HT caps
      ath6kl: disallow WoW with multiple vifs
      ath6kl: unblock fwlog_block_read() on exit
      ath6kl: check for sband existence when creating scan cmd

Tim Gardner (1):
      ath6kl: Normalize use of FW_DIR

Vasanthakumar Thiagarajan (6):
      ath6kl: Fix possible unaligned memory access in ath6kl_get_rsn_capab()
      ath6kl: Configure 0 as rsn cap when it is not there in rsn ie
      ath6kl: Don't advertise HT capability for incapable firmware
      ath6kl: Fix bss filter setting while scanning
      ath6kl: Update netstats for some of the tx failrues in
ath6kl_data_tx()
      ath6kl: Complete failed tx packet in ath6kl_htc_tx_from_queue()

Vivek Natarajan (1):
      ath6kl_sdio: Fix the EAPOL out of order issue

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  238
+++++++++++++++++++--------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +
 drivers/net/wireless/ath/ath6kl/core.h     |   33 +++-
 drivers/net/wireless/ath/ath6kl/debug.c    |   12 ++-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   45 ++++--
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   11 +-
 drivers/net/wireless/ath/ath6kl/init.c     |   29 +++-
 drivers/net/wireless/ath/ath6kl/main.c     |  104 ++++++++++--
 drivers/net/wireless/ath/ath6kl/sdio.c     |   17 ++-
 drivers/net/wireless/ath/ath6kl/txrx.c     |   12 +-
 drivers/net/wireless/ath/ath6kl/usb.c      |   12 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   94 +++++++-----
 drivers/net/wireless/ath/ath6kl/wmi.h      |   24 +++
 13 files changed, 455 insertions(+), 178 deletions(-)

