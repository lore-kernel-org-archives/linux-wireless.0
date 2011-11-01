Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:48919 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1KAGnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 02:43:53 -0400
Subject: [PATCH v2 0/7] ath6kl: suspend cutpower mode
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Nov 2011 08:43:45 +0200
Message-ID: <20111101064140.6798.7006.stgit@localhost6.localdomain6> (sfid-20111101_074356_534570_D41FE45D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my v2 of suspend cutpower patches.

v2:

o fix ath6kl_cfg80211_stop() to clear connect flags
o refactor sdio configuration to a separate function

---

Kalle Valo (7):
      ath6kl: add aborted parameter to ath6kl_cfg80211_scan_complete_event()
      ath6kl: create ath6kl_cfg80211_stop()
      ath6kl: reset CONNECT_PEND and CONNECTED flags in ath6kl_cfg80211_stop()
      ath6kl: implement ath6kl_cfg80211_suspend()
      ath6kl: add state variable depicting hw/fw state
      ath6kl: refactor sdio configuration to a separate function
      ath6kl: cut power during suspend


 drivers/net/wireless/ath/ath6kl/cfg80211.c |  158 ++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath6kl/cfg80211.h |   13 ++
 drivers/net/wireless/ath/ath6kl/core.h     |   11 ++
 drivers/net/wireless/ath/ath6kl/debug.h    |    1 
 drivers/net/wireless/ath/ath6kl/init.c     |    4 +
 drivers/net/wireless/ath/ath6kl/main.c     |   64 +----------
 drivers/net/wireless/ath/ath6kl/sdio.c     |  146 ++++++++++++++++++--------
 drivers/net/wireless/ath/ath6kl/wmi.h      |    4 +
 8 files changed, 283 insertions(+), 118 deletions(-)

