Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31175 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbZG0SxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:53:06 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:53:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath9k: move mac80211 workqueue cancelations
Date: Mon, 27 Jul 2009 11:53:01 -0700
Message-ID: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This corrects the ath9k cancelations of work for the mac80211 workqueue
on the stop callback.

Luis R. Rodriguez (3):
  ath9k: re-order cancelling of work on mac80211 workqueue
  ath9k: move cancel_delayed_work_sync() out of ath_deinit_leds()
  ath9k: move workqueue cancels to stop callback

 drivers/net/wireless/ath/ath9k/main.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

