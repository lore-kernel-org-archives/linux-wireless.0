Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56989 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249AbbJENMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 09:12:44 -0400
Message-ID: <1444050759.27220.15.camel@coelho.fi> (sfid-20151005_151252_076730_360F1608)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: egrumbach@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 05 Oct 2015 16:12:39 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2015-10-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(oops! now with Kalle's correct email address)

Hi Kalle,

Here's our second pull request for 4.4.  Nothing really stands out,
just the usual series of improvements, bugfixes and clean-ups.

There doesn't seem to be any conflict with the fixes pull request I
just sent, but if you find any problems, let me know.

Luca.

The following changes since commit
8f6c5b079cb37f01463a643182815c00aa5263f2:

  Merge tag 'iwlwifi-next-for-kalle-2015-09-21' of
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
(2015-09-26 21:25:18 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi
-next.git tags/iwlwifi-next-for-kalle-2015-10-05

for you to fetch changes up to
0316d30ea3e66379cd30ed70a114bc282159bb4c:

  iwlwifi: mvm: add minimal multi-RXQ infrastructure (2015-10-05
14:34:51 +0300)

----------------------------------------------------------------
* more clean-ups towards multiple RX queues;
* some rate scaling fixes and improvements;
* some time-of-flight fixes;
* other generic improvements and clean-ups;

----------------------------------------------------------------
Assaf Krauss (2):
      iwlwifi: mvm: Fix tof debugfs formats (dec vs. hex)
      iwlwifi: mvm: Improve debugfs tof robustness

Aviya Erenfeld (1):
      iwlwifi: mvm: move DTS command and notification to new group

Eyal Shapira (5):
      iwlwifi: mvm: rs: improve rate debug messages
      iwlwifi: mvm: rs: remove overflowing debug message
      iwlwifi: mvm: rs: minor indentation fix
      iwlwifi: mvm: rs: fix success ratio comparison in
rs_get_best_rate
      iwlwifi: mvm: rs: dynamically switch between 80MHz and 20MHz in
some scenarios

Gregory Greenman (1):
      iwlwifi: mvm: ToF - fill bssid of responder configuration

Ilan Peer (1):
      iwlwifi: mvm: Correctly update MAC context on add/del station

Johannes Berg (13):
      iwlwifi: mvm: correct skip-over-DTIM implementation
      MAINTAINERS: iwlwifi: update contact email
      iwlwifi: enable tracing by default
      iwlwifi: mvm: remove PHY RX from handlers
      iwlwifi: op-mode API: add rx_rss method
      iwlwifi: transport: track number of allocated queues
      iwlwifi: mvm: stop using DEVICE_POWER_FLAGS_CAM_MSK
      iwlwifi: remove IWL3165_UCODE_API_OK and _MIN
      iwlwifi: mvm: minor rx code cleanup
      iwlwifi: mvm: fix signedness warnings in ToF debugfs
      iwlwifi: mvm: make threshold temperatures unsigned
      iwlwifi: size firmware flags memory correctly
      iwlwifi: mvm: add minimal multi-RXQ infrastructure

Liad Kaufman (3):
      iwlwifi: mvm: fix default disabled aggs in sta
      iwlwifi: mvm: support using multiple ACs on single HW queue
      iwlwifi: mvm: support enabling a queue with a given ssn

Moshe Harel (2):
      iwlwifi: nvm: force 1x1 antenna in Series 8000
      iwlwifi: nvm: add nvm phy_sku section to debugfs

Nicolas Iooss (1):
      iwlwifi: mvm: fix tof.h header guard

 MAINTAINERS                                     |   2 +-
 drivers/net/wireless/iwlwifi/Kconfig            |   1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c         |   7 ----
 drivers/net/wireless/iwlwifi/iwl-config.h       |  12 +++---
 drivers/net/wireless/iwlwifi/iwl-drv.c          |   4 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  19 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |  15 +++++++-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h    |   2 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h      |  19 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.c        |   1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   5 +++
 drivers/net/wireless/iwlwifi/mvm/constants.h    |   1 +
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c  |  72
++++++++++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |   3 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |   8 +---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  10 +++++
 drivers/net/wireless/iwlwifi/mvm/fw.c           |   8 +---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |  27 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |   2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  53
+++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/nvm.c          |   7 +++-
 drivers/net/wireless/iwlwifi/mvm/ops.c          | 155
++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
-------
 drivers/net/wireless/iwlwifi/mvm/power.c        |  80
++++++++++++++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/rs.c           | 116
+++++++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/rx.c           |   4 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c          |  80
+++++++++++++++++++++++++---------------
 drivers/net/wireless/iwlwifi/mvm/tof.c          |   1 +
 drivers/net/wireless/iwlwifi/mvm/tof.h          |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c           |  14 ++++++-
 drivers/net/wireless/iwlwifi/mvm/tx.c           |  11 ++----
 drivers/net/wireless/iwlwifi/mvm/utils.c        | 142
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 32 files changed, 643 insertions(+), 244 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux
-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
