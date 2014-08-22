Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52967 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbaHVHx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:59 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/4] ath9k patches
Date: Fri, 22 Aug 2014 13:23:55 +0530
Message-Id: <1408694039-28927-1-git-send-email-sujith@msujith.org> (sfid-20140822_095418_385203_46B02D63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

With the introduction of channel context support, ath9k now supports
two types of operation, with separate paths for HW scan and SW scan.
The paths interleave in many places with code overlap and this makes the code
a bit hard to follow. This series begins to separate the two modes by making
the channel context code more self-contained. There is still lots to
be done, though.

Sujith Manoharan (4):
  ath9k: Add a config option for channel context
  ath9k: Move P2P functions to channel.c
  ath9k: Isolate P2P powersave routines
  ath9k: Isolate ath9k_use_chanctx module parameter

 drivers/net/wireless/ath/ath9k/Kconfig   |   9 ++
 drivers/net/wireless/ath/ath9k/ath9k.h   |  47 +++++++++-
 drivers/net/wireless/ath/ath9k/channel.c | 149 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c    |  72 ++++++++-------
 drivers/net/wireless/ath/ath9k/main.c    | 119 +++---------------------
 drivers/net/wireless/ath/ath9k/recv.c    |   6 +-
 6 files changed, 258 insertions(+), 144 deletions(-)

-- 
2.0.4

