Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/21] ath9k/iwlwifi/mac80211: rate cleanup
Date: Tue, 14 Jul 2009 20:13:52 -0400
Message-Id: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the series of pending patches for rate control cleanup
which apply on ath9k, mac80211 and iwlwifi. This series is now
rebased against the latest wireless-testing. I've also tacked along
Vasanth's rate control cleanup patches with this series for your
and Vasanth's convenience.

Luis R. Rodriguez (17):
  mac80211: drop frames for sta with no valid rate
  ath9k: downgrade assert in rc.c for invalid rate
  iwlwifi: remove rs_get_rate workaround
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
  mac80211: add helper for management / no-ack frame rate decision
  ath9k: remove rate control wraper

Vasanthakumar Thiagarajan (4):
  ath9k: Remove dead code in rate control
  ath9k: Remove unused members from rate control structure
  ath9k: Use probe interval instead of rssi reduce interval
  ath9k: Nuke struct ath_tx_ratectrl_state

 drivers/net/wireless/ath/ath9k/ath9k.h     |    1 -
 drivers/net/wireless/ath/ath9k/hw.c        |    1 -
 drivers/net/wireless/ath/ath9k/hw.h        |   17 +-
 drivers/net/wireless/ath/ath9k/main.c      |    3 +-
 drivers/net/wireless/ath/ath9k/rc.c        |  609 +++++++++-------------------
 drivers/net/wireless/ath/ath9k/rc.h        |   29 +--
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   24 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   16 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    5 +-
 include/net/mac80211.h                     |   34 ++
 net/mac80211/rate.c                        |   29 ++
 net/mac80211/rc80211_minstrel.c            |   23 +-
 net/mac80211/rc80211_pid_algo.c            |   12 +-
 net/mac80211/tx.c                          |   23 +
 14 files changed, 298 insertions(+), 528 deletions(-)

