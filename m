Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0EGClP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 22:41:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath9k: Rate processing fix and initval update for AR9003
Date: Thu,  6 May 2010 22:41:11 -0400
Message-Id: <1273200074-9127-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Three patches in this series. Two are related to the problem
Kalle reported earlier but it should not help him given that
we know his rates *are* 802.11n based. This still seems best
to do. The last one is an register initialization update for
ath9k for AR9003 for XB113.

Luis R. Rodriguez (3):
  ath9k_common: move the rate status setting into ath9k_process_rate()
  ath9k_common: drop incomming frames with an invalid hardware rate
  ath9k_hw: Update initvals for AR9003 for xb113

 drivers/net/wireless/ath/ath9k/ar9003_initvals.h |  204 +++++++++++-----------
 drivers/net/wireless/ath/ath9k/common.c          |   39 +++--
 2 files changed, 128 insertions(+), 115 deletions(-)

