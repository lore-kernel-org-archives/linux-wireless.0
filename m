Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35705 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbCTLAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 07:00:25 -0400
Received: by labjg1 with SMTP id jg1so84056277lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 04:00:23 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v4 0/6] ath10k: add basic tdls support
Date: Fri, 20 Mar 2015 12:02:53 +0100
Message-Id: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20150320_120029_587818_ECC14161)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces tdls funtionality without tdls peer uapsd
and tdls channel switching. Tdls is supported by qca6174 hardware 
what is indicated by firmware through supported services.
Tdls station when authorized requires some parameters that are filled in 
by rate control initialization. Rate control for tdls is initialized
at proper time in mac80211 patch:
mac80211: initialize rate control earlier for tdls station

So tdls funtionality implemented by this patchset depends on 
mac80211: initialize rate control earlier for tdls station

v2:
-introduce tdls peer counter
-minor changes after review

v3:
-more minor changes after review
-replace tdls peer counter variable by iterate station function

v4:
-provide functions for counting tdls station per vif and tdls vifs
-handle maximum number of tdls vifs
-split code into more patches

Marek Puzyniak (5):
  ath10k: make peer type configurable
  ath10k: store max tdls vdevs that fw can handle
  ath10k: update station counting
  ath10k: add wmi support for tdls
  ath10k: introduce basic tdls functionality

Michal Kazior (1):
  ath10k: unify tx mode and dispatch

 drivers/net/wireless/ath/ath10k/core.c    |   1 +
 drivers/net/wireless/ath/ath10k/core.h    |   3 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   8 -
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  30 ++-
 drivers/net/wireless/ath/ath10k/hw.h      |   1 +
 drivers/net/wireless/ath/ath10k/mac.c     | 391 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/mac.h     |   8 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  50 +++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 160 +++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  53 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   3 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  43 ++++
 12 files changed, 664 insertions(+), 87 deletions(-)

-- 
2.1.4

