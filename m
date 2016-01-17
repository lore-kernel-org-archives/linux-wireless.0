Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44475 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcAQKjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 05:39:45 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/5] 11AD fixes
Date: Sun, 17 Jan 2016 12:39:05 +0200
Message-Id: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160117_114010_844717_45FF0160)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The below patches include several fixes to wil6210 driver:
- Fixes in IEs handling
- Fixes in TX vring validation before access
- Fix in connect flow to allow concurrent multiple connect events

Lior David (2):
  wil6210: fix privacy flag calculation in change_beacon
  wil6210: use extra IEs from probe response

Maya Erez (3):
  wil6210: handle tx completions only if vring tx data is enabled
  wil6210: find TX vring only if vring_tx_data is enabled
  wil6210: handle multiple connect/disconnect events

 drivers/net/wireless/ath/wil6210/cfg80211.c | 149 ++++++++++++++++++--------
 drivers/net/wireless/ath/wil6210/main.c     |  81 +++++++-------
 drivers/net/wireless/ath/wil6210/netdev.c   |   5 +-
 drivers/net/wireless/ath/wil6210/txrx.c     |  20 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |   8 +-
 drivers/net/wireless/ath/wil6210/wmi.c      | 157 ++++++++++++++++++++--------
 6 files changed, 277 insertions(+), 143 deletions(-)

-- 
1.8.5.2

