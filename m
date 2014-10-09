Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39986 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJIJtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:49:53 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi2so934627wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 02:49:52 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: speed up recovery
Date: Thu,  9 Oct 2014 11:38:44 +0200
Message-Id: <1412847527-25983-1-git-send-email-michal.kazior@tieto.com> (sfid-20141009_114957_594604_96B16F87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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


Michal Kazior (3):
  ath10k: fix possible bmi crash
  ath10k: expose hw restart via debugfs
  ath10k: speed up hw recovery

 drivers/net/wireless/ath/ath10k/ce.c    |  7 +++++++
 drivers/net/wireless/ath/ath10k/core.c  | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h  |  5 +++++
 drivers/net/wireless/ath/ath10k/debug.c |  7 ++++++-
 drivers/net/wireless/ath/ath10k/mac.c   | 14 ++++++++++++--
 drivers/net/wireless/ath/ath10k/mac.h   |  1 +
 drivers/net/wireless/ath/ath10k/pci.c   |  3 +++
 drivers/net/wireless/ath/ath10k/txrx.c  |  3 ++-
 drivers/net/wireless/ath/ath10k/wmi.c   |  4 ++++
 9 files changed, 56 insertions(+), 4 deletions(-)

-- 
1.8.5.3

