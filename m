Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab2KIUHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:37 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWurY-0003aq-9v
	for linux-wireless@vger.kernel.org; Fri, 09 Nov 2012 21:07:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: pull-request: iwlwifi-next 2012-11-09
Date: Fri,  9 Nov 2012 21:07:59 +0100
Message-Id: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210741_479756_40EEAC8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please pull (see below) these iwlwifi changes.

In addition to the previous four patches that I'm not resending,
we have a number of cleanups, message reduction, firmware error
handling improvements (yes yes... we need to fix them instead)
and various other small things all over.

Thanks,
johannes

The following changes since commit 4e760f1ab267edcd6e4b232ff732fc9cdc659ebb:

  iwlwifi: don't WARN when a non empty queue is disabled (2012-10-16 16:41:40 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john

for you to fetch changes up to d18aa87fbfe80f33076942d11f19c9d813e835b1:

  iwlwifi: return commands with error on FW error (2012-11-09 20:55:14 +0100)

----------------------------------------------------------------
Assaf Krauss (1):
      iwlwifi: remove MFP Kconfig option

Emmanuel Grumbach (5):
      iwlwifi: don't leak Tx skb when a queue is disabled
      iwlwifi: handle RFKILL logic in the transport layer
      iwlwifi: don't call stop_device twice
      iwlwifi: check the SCD conf from ALIVE response
      iwlwifi: zero trans_cfg before settings its fields

Johannes Berg (11):
      iwlwifi: support host command with copied data
      iwlwifi: clarify NOCOPY/DUP documentation
      iwlwifi: fix flush command
      iwlwifi: don't clear CTL_AMPDU on frame status
      iwlwifi: fix queue flush confusion
      iwlwifi: use list_first_entry
      iwlwifi: remove EEPROM version message by default
      iwlwifi: remove SKU/antenna messages by default
      iwlwifi: remove useless messages
      iwlwifi: fix typo in RX data tracing
      iwlwifi: return commands with error on FW error

 drivers/net/wireless/iwlwifi/Kconfig            |  9 ---
 drivers/net/wireless/iwlwifi/dvm/agn.h          |  4 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h     |  7 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c      |  2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c          | 37 ++++++-----
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |  4 +-
 drivers/net/wireless/iwlwifi/dvm/main.c         | 18 ++----
 drivers/net/wireless/iwlwifi/dvm/rx.c           |  2 -
 drivers/net/wireless/iwlwifi/dvm/tx.c           |  9 +--
 drivers/net/wireless/iwlwifi/dvm/ucode.c        |  2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h     |  2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |  4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h        | 27 +++++---
 drivers/net/wireless/iwlwifi/pcie/internal.h    | 17 +++--
 drivers/net/wireless/iwlwifi/pcie/rx.c          | 39 ++++++++----
 drivers/net/wireless/iwlwifi/pcie/trans.c       | 30 ++++-----
 drivers/net/wireless/iwlwifi/pcie/tx.c          | 85 +++++++++++++++++++++----
 17 files changed, 183 insertions(+), 115 deletions(-)
