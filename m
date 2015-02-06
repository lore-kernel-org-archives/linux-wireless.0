Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:46422 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbbBFMDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 07:03:51 -0500
Received: by mail-we0-f171.google.com with SMTP id k11so13280916wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 04:03:50 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/7] ath10k: add multi-channel support
Date: Fri,  6 Feb 2015 13:02:47 +0100
Message-Id: <1423224174-24764-1-git-send-email-michal.kazior@tieto.com> (sfid-20150206_130358_266662_32F77823)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New qca6174 with wmi-tlv firmware supports
multi-channel operation. To make use of it
ath10k needs a few changes: implement mac80211's
chanctx API and rework tx queue control a bit.

There are still rough edges (involving seldom
beacon reports from firmware causing beacon loss
in some cases, etc). Hopefully this will be fixed
either in driver or firmware eventually.


Changes since RFC:
 * I've sent `ath10k: defer AP self-peer removal
   wait` separately now because it's not really
   required for multi-channel per se

v2:
 * fix null deref after rebasing
 * fix commit log typo

v3:
 * remove some duplication wrt mac80211 [Johannes]
 * small fixes


Michal Kazior (7):
  ath10k: allow empty ssid vdev config
  ath10k: implement chanctx API
  ath10k: implement adaptive qcs command
  ath10k: protect ar->arvifs linking with data_lock
  ath10k: rework tx queue locking
  ath10k: implement tx pause wmi event
  ath10k: enable multi-channel on supported devices

 drivers/net/wireless/ath/ath10k/core.h    |  18 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 102 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  11 +-
 drivers/net/wireless/ath/ath10k/mac.c     | 750 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/mac.h     |  68 +++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  16 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 118 ++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  46 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  18 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |   1 +
 10 files changed, 1024 insertions(+), 124 deletions(-)

-- 
1.8.5.3

