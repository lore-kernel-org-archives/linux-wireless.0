Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57737 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaHWH7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 00/18] ath9k patches
Date: Sat, 23 Aug 2014 13:29:05 +0530
Message-Id: <1408780763-27974-1-git-send-email-sujith@msujith.org> (sfid-20140823_095936_227283_F9164937)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This series continues to cleanup the channel context code,
trying to make a clear separation between the two modes of operation.

All the pending patches (including the earlier series) are here:
http://msujith.org/dir/patches/wl/Aug-23-2014/

Sujith

Sujith Manoharan (18):
  ath9k: Add a routine for initializing channel contexts
  ath9k: Add a routine to tear down channel contexts
  ath9k: Make ath_chanctx_work static
  ath9k: Cleanup mgd_prepare_tx callback
  ath9k: Conditionally compile a few functions
  ath9k: Exclude more functions
  ath9k: Conditionally compile more functions
  ath9k: Make ath_chanctx_offchan_switch static
  ath9k: Make ath_chanctx_get_oper_chan static
  ath9k: Make ath_chanctx_switch static
  ath9k: Fix channel context events
  ath9k: Fix function declarations
  ath9k: Add wrappers for beacon events
  ath9k: Add ath9k_chanctx_wake_queues
  ath9k: Add ath9k_offchannel_init
  ath9k: Use ath_chanctx_check_active properly
  ath9k: Fix function argument type
  ath9k: Fix 'offchannel' in ath_softc

 drivers/net/wireless/ath/ath9k/ath9k.h   |  68 ++-
 drivers/net/wireless/ath/ath9k/beacon.c  |  10 +-
 drivers/net/wireless/ath/ath9k/channel.c | 839 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/init.c    |   7 +-
 drivers/net/wireless/ath/ath9k/main.c    |  64 ++-
 drivers/net/wireless/ath/ath9k/recv.c    |   7 +-
 drivers/net/wireless/ath/ath9k/wow.c     |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c    |   7 +-
 8 files changed, 556 insertions(+), 449 deletions(-)

-- 
2.0.4

