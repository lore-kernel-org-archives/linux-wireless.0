Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:50456 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaJTMel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:34:41 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so3790702lab.5
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:34:39 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/3] ath10k: speed up recovery
Date: Mon, 20 Oct 2014 14:22:35 +0200
Message-Id: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com> (sfid-20141020_143444_429513_C3864DC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch #1 fixes a bug I've found while testing
patches #2 and #3. It's safe to cherry-pick it in
case patches #2 and/or #3 aren't accepted or need
a re-spin.

I've mainly used patch #2 to test reset and
recovery. It's pretty handy for (stress-)testing.

Patch #3 should improve recovery speed in some
cases. Notably when there's a long chain of WMI
commands involved which take a painfully long time
to timeout/complete if firmware crashes mid-way.

Note: Patches #2 and #3 depend on `ath10k: pci
related fixes 2014-10-09`. Without the patchset
patches #2 and #3 must not be applied. Patch #1 is
fine though.

v2:
 * add additional comments [Kalle]
 * rename new fw crash debugfs sub-command [Kalle]
 * fix crash [Janusz]


Michal Kazior (3):
  ath10k: fix possible bmi crash
  ath10k: expose hw restart via debugfs
  ath10k: speed up hw recovery

 drivers/net/wireless/ath/ath10k/ce.c     |  7 +++++++
 drivers/net/wireless/ath/ath10k/core.c   | 23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h   |  5 +++++
 drivers/net/wireless/ath/ath10k/debug.c  |  7 ++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  1 -
 drivers/net/wireless/ath/ath10k/mac.c    | 14 ++++++++++++--
 drivers/net/wireless/ath/ath10k/mac.h    |  1 +
 drivers/net/wireless/ath/ath10k/pci.c    |  3 +++
 drivers/net/wireless/ath/ath10k/txrx.c   |  3 ++-
 drivers/net/wireless/ath/ath10k/wmi.c    |  5 ++++-
 10 files changed, 63 insertions(+), 6 deletions(-)

-- 
1.8.5.3

