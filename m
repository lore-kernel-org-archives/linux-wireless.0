Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2922 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbcCOObl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 10:31:41 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, <kvalo@codeaurora.org>,
	<mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH 0/2] Parsing per station rx duration for 10.4
Date: Tue, 15 Mar 2016 20:00:48 +0530
Message-ID: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160315_153144_253571_CFCF8F92)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Peer Stats for 10.4 is enabled by Extended Resource Configuration
API (based on one of the earlier patch from Raja Mani), and parsing
of the same is based also 'stats_id' which also provides backward
compatibility with older f/w (or) ath10k by design

review help:

1. Fixed documentation related comments from Kalle / Michal
2. Fixed indentation related comments from Michal
3. Removed the check for excluding peer stats for test mode (Michal)
4. Fix checking for peer stats feature enabled

Dependency over

[PATCH v5] ath10k: Enable debugfs provision to enable Peer Stats

Mohammed Shafi Shajakhan (1):
  ath10k: Enable parsing per station rx duration for 10.4

Raja Mani (1):
  ath10k: Introduce Extended Resource Config support for 10.4

 drivers/net/wireless/ath/ath10k/core.c    |   19 +++++++++-
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   23 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   54 +++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.h     |   49 +++++++++++++++++++++++++-
 4 files changed, 137 insertions(+), 8 deletions(-)

-- 
1.7.9.5

