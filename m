Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35381 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbbEHJRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 05:17:01 -0400
Received: by lbbuc2 with SMTP id uc2so48906498lbb.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2015 02:16:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: improve power efficiency
Date: Fri,  8 May 2015 09:13:05 +0000
Message-Id: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com> (sfid-20150508_111708_029709_21BEC8A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some measurements for QCA61X4:

            Loaded    Started   Associated
Unpatched    31mA      88mA       43mA
Patched      14mA      15mA       23mA

Loaded = module loaded, driver bound, no interface
         is running

Started = Loaded, but one client interface is
          running, not associated

Associated = Started, but associated to an AP as
             client

Note: Unpatched was consuming more power when
Started than when Associated. This is no mistake.

I didn't have a way to measure QCA988X.


Janusz Dziedzic (2):
  ath10k: enable ASPM
  ath10k: fix idle power consumption

Michal Kazior (1):
  ath10k: enable pci soc powersaving

 drivers/net/wireless/ath/ath10k/debug.h  |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   1 +
 drivers/net/wireless/ath/ath10k/mac.c    |   9 +-
 drivers/net/wireless/ath/ath10k/pci.c    | 317 ++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/pci.h    |  97 +++++-----
 5 files changed, 285 insertions(+), 140 deletions(-)

-- 
2.1.4

