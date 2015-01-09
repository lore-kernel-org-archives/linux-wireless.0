Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59315 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbbAILOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 06:14:46 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so1567503wiv.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 03:14:45 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/8] ath10k: add multi-channel support
Date: Fri,  9 Jan 2015 12:14:01 +0100
Message-Id: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com> (sfid-20150109_121451_528392_50CE6BBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New wmi-tlv firmware and new hardware will support
multi-channel operation.

This prepares the driver by implementing chanctx,
improves tx queue locking and introduces initial
interface combinations.

I'm posting this as an RFC first because I'd like
to get some early feedback (if possible) while I
upstream other patches this patchset is basing on.


Michal Kazior (8):
  ath10k: defer AP self-peer removal wait
  ath10k: allow empty ssid vdev config
  ath10k: implement chanctx API
  ath10k: implement adaptive qcs command
  ath10k: protect ar->arvifs linking with data_lock
  ath10k: rework tx queue locking
  ath10k: implement tx pause wmi event
  ath10k: add proper wmi-tlv combinations

 drivers/net/wireless/ath/ath10k/core.c    |   1 +
 drivers/net/wireless/ath/ath10k/core.h    |  16 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  80 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |   9 +-
 drivers/net/wireless/ath/ath10k/mac.c     | 692 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h     |  57 +++
 drivers/net/wireless/ath/ath10k/txrx.c    |   6 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  16 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 118 ++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  46 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  18 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |   1 +
 12 files changed, 975 insertions(+), 85 deletions(-)

-- 
1.8.5.3

