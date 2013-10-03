Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42345 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3JCNMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 09:12:35 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 0/3] ath10k: fixes
Date: Thu, 3 Oct 2013 15:09:22 +0200
Message-ID: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com> (sfid-20131003_151240_085112_312B43BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset addresses recently spotted issue
with (yet another) scheduling while atomic bug
(the other being WEP key index setting). This one
is related to hw_config() and powersave settings.
This comes from recent changes I've do to HTC/WMI.
WMI commands can now block so it's illegal to call
them in an atomic context anymore.

ath10k needs to setup some settings per-vdev (i.e.
per-interface) such as powersave, rts, fragmentation.
Until now mac80211 iteration functions were used.
However using non-atomic iteration function variant
doesn't solve the problem as it introduces an
issue with iflist_mtx deadlock in some cases.

I briefly tried to reproduce the issue Kalle
reported but was unsuccessful thus the "/RFT".



Michal Kazior (3):
  ath10k: fix add_interface failure handling
  ath10k: track vif list internally
  ath10k: fix scheduling while atomic config bug

 drivers/net/wireless/ath/ath10k/core.c |    2 +
 drivers/net/wireless/ath/ath10k/core.h |    3 +
 drivers/net/wireless/ath/ath10k/mac.c  |  199 ++++++++++++++++----------------
 3 files changed, 107 insertions(+), 97 deletions(-)

-- 
1.7.9.5

