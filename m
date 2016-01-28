Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41522 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbcA1R4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 12:56:54 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/4] wil6210 bug fixes and performance enhancement
Date: Thu, 28 Jan 2016 19:24:01 +0200
Message-Id: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160128_185658_036605_60B3E870)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The below patches include:
- Bug fixes seen in stress connect/disconnect tests
- Increasing the TX vring size for performance boost

Hamad Kadmany (1):
  wil6210: TX vring optimization

Maya Erez (2):
  wil6210: prevent access to vring_tx_data lock during its init
  wil6210: protect synchronous wmi commands handling

Vladimir Kondratiev (1):
  wil6210: wait for disconnect completion

 drivers/net/wireless/ath/wil6210/cfg80211.c | 13 +++++++++++-
 drivers/net/wireless/ath/wil6210/debugfs.c  |  6 +++---
 drivers/net/wireless/ath/wil6210/main.c     | 31 +++++++++++------------------
 drivers/net/wireless/ath/wil6210/txrx.c     | 26 +++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h  |  3 ++-
 drivers/net/wireless/ath/wil6210/wmi.c      | 17 ++++++++++++----
 6 files changed, 63 insertions(+), 33 deletions(-)

-- 
1.8.5.2

