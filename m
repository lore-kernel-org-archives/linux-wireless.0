Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3476 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0AUEwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 23:52:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/2] ath5k AP mode fixes
Date: Wed, 20 Jan 2010 23:51:02 -0500
Message-Id: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a couple of fixes to ath5k AP mode that have been
kicking around for a bit.

The sleep clock is disabled by legacy HAL for AP mode and at
least one person had beaconing issues as a result of our not
also doing so.

Although we decided 'fix setup for CAB queue' was not ideal,
there's no alternative at the moment and the current setup is
causing problems for people, so IMO we should just take this
patch as-is for now.

Bob Copeland (2):
  ath5k: dont use external sleep clock in AP mode
  ath5k: fix setup for CAB queue

 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |   22 +++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/qcu.c   |    5 +++--
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++--
 4 files changed, 26 insertions(+), 8 deletions(-)


