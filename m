Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12231 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab0LDBU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 20:20:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 17:20:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <amod.bodas@atheros.com>,
	<pstew@google.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 0/3] ath9k: sleep paranoia series
Date: Fri, 3 Dec 2010 17:20:50 -0800
Message-ID: <1291425653-2884-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to ensure the device is in full sleep when going to
suspend, otherwise the device becomes completely unresponsive
upon resume. This series has one fix on a theoretical imbalance
which would leave the device awake all the time, and some two
paranoia warnings which we should look out for. Hitting any
of these warnings should be investigated.

I'm marking only one patch as a ready patch, the two others
are RFCs as I'd like more wider testing first. At least with
my AR9280 I get no warnings.

Luis R. Rodriguez (3):
  ath9k: warn when we get a ATH9K_INT_TIM_TIMER and are idle
  ath9k: Fix power save count imbalance on ath_radio_enable()
  ath9k_hw: warn if we cannot change the power to the chip

 drivers/net/wireless/ath/ath9k/hw.c   |    2 ++
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
1.7.3.2.90.gd4c43

