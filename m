Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50180 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab3HZIxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 04:53:37 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/4] ath10k: fixes
Date: Mon, 26 Aug 2013 10:53:21 +0200
Message-ID: <1377507205-5386-1-git-send-email-michal.kazior@tieto.com> (sfid-20130826_105340_130675_8C7A4FB3)
In-Reply-To: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset addresses some throughput/stability
issues.

v2:
 * add new patch
 * fix WARNING due to wrong ieee80211_rx() usage


Pozdrawiam / Best regards,
Michal Kazior.


Michal Kazior (4):
  ath10k: synchronize tx/rx reporting to mac80211
  ath10k: make the workqueue multithreaded
  ath10k: move htt rx processing to worker
  ath10k: fix issues on non-preemptible systems

 drivers/net/wireless/ath/ath10k/core.c   |    5 ++-
 drivers/net/wireless/ath/ath10k/core.h   |   10 ++++++
 drivers/net/wireless/ath/ath10k/htc.c    |    4 +++
 drivers/net/wireless/ath/ath10k/htt.h    |    3 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   58 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/txrx.c   |    6 +++-
 drivers/net/wireless/ath/ath10k/wmi.c    |    4 +++
 7 files changed, 81 insertions(+), 9 deletions(-)

-- 
1.7.9.5

