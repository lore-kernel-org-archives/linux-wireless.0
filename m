Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbZFEFlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 01:41:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/15] ath9k/mac80211/iwlwifi: rate control cleanup
Date: Fri,  5 Jun 2009 01:41:27 -0400
Message-Id: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k's rate control code is so convoluted that it really make it
difficult to spot bugs and fix them. Here's a bunch of cleanups for
ath9k rate control code, and a few for mac80211. I just tested ath9k.
Will have to test others later.

Luis R. Rodriguez (15):
  ath9k: fix oops by downgrading assert in rc.c
  ath9k: cleanup try count for MRR in rate control
  ath9k: remove unused min rate calculation code
  ath9k: remove unused stepdown when looking for the next rate
  ath9k: remove pointless wrapper ath_rc_rate_getidx()
  ath9k: rename ath_rc_get_nextlowervalid_txrate()
  ath9k: remove unused ath_rc_isvalid_txmask()
  ath9k: remove ATH9K_MODE_11B
  ath9k: remap ATH9K_MODE_*
  ath9k: rename ath_rc_ratefind_ht() to ath_rc_get_highest_rix()
  ath9k: remove unnecessary IEEE80211_TX_CTL_NO_ACK checks
  mac80211: make minstrel/pid RC use ieee80211_is_data(fc)
  iwlwifi: use ieee80211_is_data(fc)
  mac80211: move management / no-ack frame rate decision to mac80211
  ath9k: remove rate control wraper

 drivers/net/wireless/ath/ath9k/ath9k.h     |    1 -
 drivers/net/wireless/ath/ath9k/debug.h     |    1 +
 drivers/net/wireless/ath/ath9k/hw.c        |    1 -
 drivers/net/wireless/ath/ath9k/hw.h        |   17 ++--
 drivers/net/wireless/ath/ath9k/main.c      |    3 +-
 drivers/net/wireless/ath/ath9k/rc.c        |  190 ++++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   21 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   10 --
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    5 +-
 net/mac80211/rate.c                        |   29 ++++-
 net/mac80211/rc80211_minstrel.c            |   24 ----
 net/mac80211/rc80211_pid_algo.c            |   15 ---
 12 files changed, 111 insertions(+), 206 deletions(-)

