Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:55671 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1J3TPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 15:15:53 -0400
Subject: [PATCH 0/5] ath6kl: cut power when interface is down
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Oct 2011 21:15:33 +0200
Message-ID: <20111030190922.20466.299.stgit@localhost6.localdomain6> (sfid-20111030_201601_783166_40F96AF4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series changes interface handling so that power is
cut from the chip whenever interface is down compared to the current
situation when the harware is powered all the time since module
is loaded.

I'm not really sure if this is going be the final implementation
but I'll send this for review anyway. I structured the code so that
it's easy to go back to the old functionality if we so desire.

Also I need to solve support for multivif. Currently these patches
work as there's only one vif.

---

Kalle Valo (5):
      ath6kl: create ath6kl_hif_stop()
      ath6kl: power down hardware when interface is down
      ath6kl: fix WLAN_ENABLE usage in ath6kl_close()
      ath6kl: print firmware crashes always
      ath6kl: print seqno in htc debug logs


 drivers/net/wireless/ath/ath6kl/bmi.c     |    5 ++
 drivers/net/wireless/ath/ath6kl/bmi.h     |    2 +
 drivers/net/wireless/ath/ath6kl/core.h    |    5 +-
 drivers/net/wireless/ath/ath6kl/hif-ops.h |    7 ++
 drivers/net/wireless/ath/ath6kl/hif.c     |   69 ++++++++++++++++++++--
 drivers/net/wireless/ath/ath6kl/hif.h     |    1 
 drivers/net/wireless/ath/ath6kl/htc.c     |   14 +++--
 drivers/net/wireless/ath/ath6kl/init.c    |   90 ++++++++++-------------------
 drivers/net/wireless/ath/ath6kl/main.c    |   25 ++++++--
 drivers/net/wireless/ath/ath6kl/sdio.c    |   45 +++++++++++++++
 10 files changed, 187 insertions(+), 76 deletions(-)

