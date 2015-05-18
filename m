Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35760 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbbERJid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 05:38:33 -0400
Received: by wicmx19 with SMTP id mx19so71427850wic.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 02:38:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/3] ath10k: improve power efficiency
Date: Mon, 18 May 2015 09:38:15 +0000
Message-Id: <1431941898-13591-1-git-send-email-michal.kazior@tieto.com> (sfid-20150518_113836_869642_9278569D)
In-Reply-To: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
References: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
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

 drivers/net/wireless/ath/ath10k/debug.h |   1 +
 drivers/net/wireless/ath/ath10k/mac.c   |   9 +-
 drivers/net/wireless/ath/ath10k/pci.c   | 317 +++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/pci.h   |  97 +++++-----
 4 files changed, 284 insertions(+), 140 deletions(-)

-- 
2.1.4

