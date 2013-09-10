Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42868 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3IJNuJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 09:50:09 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/7] ath10k: improve TX path
Date: Tue, 10 Sep 2013 15:49:56 +0200
Message-ID: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com> (sfid-20130910_155018_342748_9FA6A17A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset addresses two issues:

 * system/userspace starvation on heavy briding
   UDP TX
 * unstable/inconsistent UDP TX throughput

In short the patchset simplifies TX path by
removing HTC TX workers, makes WMI commands block
and makes ath10k more responsive to queues
becoming full. This contributes to both improved
throughput and makes the system more responsive
under heavy UDP TX load.

Max stable briding TX (ath10k as TX):
 UDP w/o patchset: 520mbps
 UDP w/  patchset: 570mbps

 TCP w/o patchset: 350mbps
 TCP w/  patchset: 400mbps

Measured with two 2x2 cards, one acting as an AP
on AP135 board, the other as a STA on a core i5
laptop. The AP135 was passing traffic from a
station on LAN/eth1, to the STA/wlan0.


Michal Kazior (7):
  ath10k: simplify HTC credits calculation
  ath10k: add HTC TX credits replenishing notification
  ath10k: make WMI commands block by design
  ath10k: simplify HTC command submitting
  ath10k: improve beacon submission latency
  ath10k: remove wmi pending count limit
  ath10k: remove wmi event worker thread

 drivers/net/wireless/ath/ath10k/core.h  |    7 +-
 drivers/net/wireless/ath/ath10k/htc.c   |  215 +++++++------------------------
 drivers/net/wireless/ath/ath10k/htc.h   |    5 +-
 drivers/net/wireless/ath/ath10k/mac.c   |   16 +--
 drivers/net/wireless/ath/ath10k/trace.h |   11 +-
 drivers/net/wireless/ath/ath10k/wmi.c   |  197 +++++++++++++---------------
 drivers/net/wireless/ath/ath10k/wmi.h   |    5 +-
 7 files changed, 156 insertions(+), 300 deletions(-)

-- 
1.7.9.5

