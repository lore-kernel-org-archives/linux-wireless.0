Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26119 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1IEOjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 10:39:12 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 0/4] ath6kl: Fix AP mode PS buffering and enable AP/P2P
Date: Mon, 5 Sep 2011 17:38:43 +0300
Message-ID: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20110905_163916_354953_03CCD99D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first two patches in this set fix couple of issues in TIM updates
for AP mode PS buffering. With those fixed, the AP mode support is ready
to be enabled and since the initial P2P support was waiting for AP mode
to work properly, that can also be enabled now. Please note that the P2P
operations need a firmware update which has not yet been released.

Jouni Malinen (4):
  ath6kl: Fix WMI message structure for AP_SET_PVB
  ath6kl: Fix AP mode connect event parsing and TIM updates
  ath6kl: Allow AP mode to be configured
  ath6kl: Allow enabling of P2P support

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   17 +++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    6 ++
 drivers/net/wireless/ath/ath6kl/init.c     |   31 +++++++--
 drivers/net/wireless/ath/ath6kl/main.c     |   92 ++++++++++++----------------
 drivers/net/wireless/ath/ath6kl/target.h   |    6 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   45 ++++++++++++--
 drivers/net/wireless/ath/ath6kl/wmi.h      |   30 ++++++++--
 7 files changed, 157 insertions(+), 70 deletions(-)

-- 
1.7.4.1

