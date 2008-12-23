Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22657 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbYLWX7A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:59:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 15:59:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 00/16] ath9k: first series for regulatory cleanup
Date: Tue, 23 Dec 2008 15:58:35 -0800
Message-ID: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com> (sfid-20081224_005906_846942_B6B77A43)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first series of general cleanup to get us into
abandon our complex internal regulatory infrastructure. This is
quite a lot of work as we rely on our own internal "mode" stuff
and our own ath9k_channel heavily.

We start this work by ditching the mode stuff where we can
and set a staging ground for us to abandon our own internal
ath9k_channel. The values which we want to actually keep from
ath9k_channel are the calibration data. To make use of this
we will eventually map channels to our private channel structure
by indexing on their position on the static array.

The next series will deal more with this and then slowly start
to nuke our complex regulatory infrastructure in favor for
internal generic CRDA/cfg80211 regulatory infrastructure.

This work is all being done so we won't have to malloc() all
over again our new set of channels on country IE changes as
doing that would be a bit messy. We will instead prefer to use
static channels.

This should not have any major functional changes, its mostly
cleanup stuff.

This v3 abandones the private void pointer in ieee80211_channel
based on Johannes's recommendations.

Luis R. Rodriguez (16):
  mac80211: add HT conf helpers
  ath9k: use hw->conf on ath_setcurmode()
  ath9k: remove cache of rate preference when using 11g protection
  ath9k: Rename ath_setcurmode() to ath_cache_conf_rate()
  ath9k: consolidate arguments on hw reset
  ath9k: make request to get the noisefloor threshold band specific
  ath9k: use ieee80211_conf on ath9k_hw_iscal_supported()
  ath9k: make use of conf_is_ht*() in the rest of the driver
  iwlwifi: make use of conf_is_ht*() helpers
  mac80211: no need for ht.enabled
  ath9k: Make ANI CCK and OFDM error triggers band specific
  ath9k: remove mode specific default noise floor values
  ath9k: remove ath9k_hw_chan2wmode()
  ath9k: remove ath9k_hw_check_chan()
  ath9k: remove superfluous check on changing channel
  ath9k: fix sparse warnings

 drivers/net/wireless/ath9k/ani.c          |   12 +-
 drivers/net/wireless/ath9k/ath9k.h        |    9 +-
 drivers/net/wireless/ath9k/calib.c        |   93 ++++------
 drivers/net/wireless/ath9k/core.h         |    1 -
 drivers/net/wireless/ath9k/eeprom.c       |   30 ++--
 drivers/net/wireless/ath9k/hw.c           |  154 +++++------------
 drivers/net/wireless/ath9k/hw.h           |    8 +
 drivers/net/wireless/ath9k/main.c         |  268 +++++++++++++----------------
 drivers/net/wireless/ath9k/rc.c           |    4 +-
 drivers/net/wireless/ath9k/xmit.c         |   31 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 +-
 include/net/mac80211.h                    |   31 ++++-
 net/mac80211/ht.c                         |    3 +-
 net/mac80211/main.c                       |   10 -
 net/mac80211/mlme.c                       |    1 -
 16 files changed, 289 insertions(+), 378 deletions(-)

