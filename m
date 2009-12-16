Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbZLPQvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 11:51:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: greg@kroah.com, stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] stable-2.6.32: few ath9k fixes/mac80211 which missed CC'ing stable
Date: Wed, 16 Dec 2009 11:51:40 -0500
Message-Id: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg, here's a few patches which are stable fixes for which we missed
to CC stable on. They are all upstream on Linus' tree now. A few required
some backport work so I took the time to do this for you.

Felix Fietkau (1):
  ath9k: fix tx status reporting

Luis R. Rodriguez (2):
  ath9k: fix processing of TX PS null data frames
  ath9k: Fix maximum tx fifo settings for single stream devices

Sujith (1):
  ath9k: Fix TX hang poll routine

Vivek Natarajan (1):
  mac80211: Fix dynamic power save for scanning.

 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +++
 drivers/net/wireless/ath/ath9k/hw.c    |   11 ++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 drivers/net/wireless/ath/ath9k/mac.c   |    6 ++++--
 drivers/net/wireless/ath/ath9k/mac.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    9 ++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c  |   20 +++++++++++++++++++-
 net/mac80211/ieee80211_i.h             |    1 +
 net/mac80211/scan.c                    |   20 ++++++++++++++++----
 9 files changed, 63 insertions(+), 9 deletions(-)

