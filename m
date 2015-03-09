Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:43657 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbCIMnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 08:43:07 -0400
Received: by labgf13 with SMTP id gf13so46003578lab.10
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 05:43:06 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v3 0/3] ath10k: add basic tdls support
Date: Mon,  9 Mar 2015 13:45:35 +0100
Message-Id: <1425905138-9966-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20150309_134312_234872_61A53A9D)
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
already sent for review by Arik Nemtsov.


v2:
-introduce tdls peer counter
-minor changes after review

v3:
-more minor changes after review
-replace tdls peer counter variable by iterate station function

Marek Puzyniak (2):
  ath10k: make peer type configurable
  ath10k: introduce basic tdls functionality

Michal Kazior (1):
  ath10k: unify tx mode and dispatch

 drivers/net/wireless/ath/ath10k/core.h    |   2 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   8 -
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  30 ++-
 drivers/net/wireless/ath/ath10k/mac.c     | 318 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/mac.h     |   8 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  50 ++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 158 ++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  53 +++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   3 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  43 ++++
 10 files changed, 597 insertions(+), 76 deletions(-)

-- 
2.1.4

