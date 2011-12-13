Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36914 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1LMMvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 07:51:07 -0500
Subject: [PATCH v2 0/6] ath6kl: scheduled scan support
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2011 14:50:51 +0200
Message-ID: <20111213124923.10834.20626.stgit@localhost6.localdomain6> (sfid-20111213_135111_319789_0E6E75F5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's v2 of my sched scan patches. Changes from v1 are just a
proper a commit log for patch 6 and removed a fixme comment which
I had already fixed.

---

Kalle Valo (6):
      ath6kl: remove a workaround from ath6kl_cfg80211_stop()
      ath6kl: call ath6kl_cfg80211_stop() from ath6kl_close()
      ath6kl: implement ath6kl_cfg80211_stop_all()
      ath6kl: fix value of WOW_FILTER_SSID
      ath6kl: fix reading of FW IE capabilities
      ath6kl: implement scheduled scan


 drivers/net/wireless/ath/ath6kl/cfg80211.c |  203 ++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    6 +
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +
 drivers/net/wireless/ath/ath6kl/init.c     |    8 +
 drivers/net/wireless/ath/ath6kl/main.c     |   12 --
 drivers/net/wireless/ath/ath6kl/sdio.c     |   26 +++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   27 ++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    4 -
 8 files changed, 249 insertions(+), 44 deletions(-)

