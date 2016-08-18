Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atlantic540.startdedicated.de ([188.138.9.77]:35477 "EHLO
	atlantic540.startdedicated.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbcHRNi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2016 09:38:27 -0400
From: Daniel Wagner <wagi@monom.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R . Rodriguez" <mcgrof@kernel.org>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH 0/2] wireless: Use complete() instead complete_all()
Date: Thu, 18 Aug 2016 15:12:04 +0200
Message-Id: <1471525926-20384-1-git-send-email-wagi@monom.org> (sfid-20160818_153915_881858_91C07E53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Hi,

Using complete_all() is not wrong per se but it suggest that there
might be more than one reader. For -rt I am reviewing all
complete_all() users and would like to leave only the real ones in the
tree. The main problem for -rt about complete_all() is that it can be
uses inside IRQ context and that can lead to unbounded amount work
inside the interrupt handler. That is a no no for -rt.

The patches grouped per subsystem and in small batches to allow
reviewing.

This series ignores all complete_all() usages in the firmware loading
path. They will be hopefully address by Luis' sysdata patches [0].
That leaves a couple of complete_all() calls.

The first patch fixes a real glitch for the carl9170 driver. I was
able to test it because I have the hardware. For the second one I
haven't found any dongle with that chip in my drawers. 

This series against net-next of today.

cheers,
daniel

[0] https://lkml.kernel.org/r/1466117661-22075-1-git-send-email-mcgrof@kernel.org

Daniel Wagner (2):
  carl9170: Fix wrong completion usage
  ath10k: use complete() instead complete_all()

 drivers/net/wireless/ath/ath10k/core.c  | 16 ++++++++--------
 drivers/net/wireless/ath/ath10k/mac.c   |  2 +-
 drivers/net/wireless/ath/carl9170/usb.c |  6 ++----
 3 files changed, 11 insertions(+), 13 deletions(-)

-- 
2.7.4
