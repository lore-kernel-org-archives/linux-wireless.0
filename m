Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47597 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763AbbA3Imp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 03:42:45 -0500
Received: by mail-wg0-f49.google.com with SMTP id k14so25556405wgh.8
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:44 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/7] ath10k: add multi-channel support
Date: Fri, 30 Jan 2015 09:41:20 +0100
Message-Id: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com> (sfid-20150130_094251_384373_5592EC53)
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


Michal Kazior (7):
  ath10k: allow empty ssid vdev config
  ath10k: implement chanctx API
  ath10k: implement adaptive qcs command
  ath10k: protect ar->arvifs linking with data_lock
  ath10k: rework tx queue locking
  ath10k: implement tx pause wmi event
  ath10k: enable multi-channel on supported devices

 drivers/net/wireless/ath/ath10k/core.c    |   1 +
 drivers/net/wireless/ath/ath10k/core.h    |  16 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  87 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  11 +-
 drivers/net/wireless/ath/ath10k/mac.c     | 672 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h     |  57 +++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  16 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 118 +++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  46 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  18 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |   1 +
 11 files changed, 958 insertions(+), 85 deletions(-)

-- 
1.8.5.3

