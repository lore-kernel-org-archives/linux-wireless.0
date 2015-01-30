Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54937 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbbA3Mdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 07:33:31 -0500
Received: by mail-wi0-f177.google.com with SMTP id r20so2381673wiv.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 04:33:30 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/7] ath10k: add multi-channel support
Date: Fri, 30 Jan 2015 13:31:19 +0100
Message-Id: <1422621086-28970-1-git-send-email-michal.kazior@tieto.com> (sfid-20150130_133336_450085_753687B2)
In-Reply-To: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
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
 drivers/net/wireless/ath/ath10k/mac.c     | 682 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h     |  57 +++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  16 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 118 +++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  46 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  18 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |   1 +
 11 files changed, 966 insertions(+), 87 deletions(-)

-- 
1.8.5.3

