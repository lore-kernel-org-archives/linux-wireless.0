Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51472 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaHWNmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 09:42:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/4] ath9k patches
Date: Sat, 23 Aug 2014 19:12:12 +0530
Message-Id: <1408801336-7626-1-git-send-email-sujith@msujith.org> (sfid-20140823_154223_791650_CF7CC4C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Third series cleaning up the channel context code. Most of the code
has been moved inside CONFIG_ATH9K_CHANNEL_CONTEXT. Since the normal
path also makes use of certain channel context specific variables,
they have been left unmodified - like 'cur_chan', 'cur_chandef' etc.

After this series, just 3 functions in channel.c are outside
CONFIG_ATH9K_CHANNEL_CONTEXT.

All the pending patches are in:
http://msujith.org/dir/patches/wl/Aug-23-2014/

Sujith

Sujith Manoharan (4):
  ath9k: Fix channel context variables in ath_softc
  ath9k: Remove redundant ifdef
  ath9k: Move ath9k_beacon_add_noa to channel.c
  ath9k: Fix ath_chanctx_get()

 drivers/net/wireless/ath/ath9k/ath9k.h   | 29 ++++++++++++++----
 drivers/net/wireless/ath/ath9k/beacon.c  | 49 ------------------------------
 drivers/net/wireless/ath/ath9k/channel.c | 51 ++++++++++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 57 deletions(-)

-- 
2.0.4

