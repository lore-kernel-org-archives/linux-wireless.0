Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62229 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaKCTss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 14:48:48 -0500
Received: by mail-wi0-f170.google.com with SMTP id q5so6986156wiv.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2014 11:48:46 -0800 (PST)
Message-ID: <5457DC1C.7020200@gmail.com> (sfid-20141103_204851_670186_E0C0CB06)
Date: Mon, 03 Nov 2014 21:48:44 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi 2014-11-03
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a pull request for 3.18.

Details below, please pull.

Thanks!

The following changes since commit 7f2ac8fb31896c9fb70dbd2a2e6642b79996fc13:

  iwlwifi: pcie: fix polling in various places (2014-10-23 21:21:49 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-john-2014-11-03

for you to fetch changes up to 31b8b343e019e0a0c57ca9c13520a87f9cab884b:

  iwlwifi: fix RFkill while calibrating (2014-11-03 15:29:17 +0200)

----------------------------------------------------------------
I fix here two issues that are related to the firmware
loading flow. A user reported that he couldn't load the
driver because the rfkill line was pulled up while we
were running the calibrations. This was happening while
booting the system: systemd was restoring the "disable
wifi settings" and that raised an RFKILL interrupt during
the calibration. Our driver didn't handle that properly
and this is now fixed.

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: mvm: initialize the cur_ucode upon boot
      iwlwifi: fix RFkill while calibrating

 drivers/net/wireless/iwlwifi/mvm/fw.c       | 10 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      | 12 +++++++++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  4 ++--
 5 files changed, 24 insertions(+), 4 deletions(-)
