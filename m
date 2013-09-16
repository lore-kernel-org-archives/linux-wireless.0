Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60942 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3IPMti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 08:49:38 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/4] ath10k: improve RX performance
Date: Mon, 16 Sep 2013 14:49:13 +0200
Message-ID: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com> (sfid-20130916_144941_555728_6F367541)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset gives clear RX performance
improvement on AP135. Throughput is at least
doubled (300mbps -> 600mbps, UDP RX, 2x2).

Patches depend on my RFC patch "mac80211: support
reporting A-MSDU subframes individually".


Michal.


Michal Kazior (4):
  ath10k: report A-MSDU subframes individually
  ath10k: document decap modes
  ath10k: cleanup RX decap handling
  ath10k: align RX frames properly

 drivers/net/wireless/ath/ath10k/htt.h     |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  251 ++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/hw.h      |    6 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h |   24 ++-
 drivers/net/wireless/ath/ath10k/txrx.c    |    5 +
 5 files changed, 135 insertions(+), 152 deletions(-)

-- 
1.7.9.5

