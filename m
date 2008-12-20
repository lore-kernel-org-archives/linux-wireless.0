Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32072 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYLTFzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:25 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 00/16] ath9k: first series for regulatory cleanup
Date: Fri, 19 Dec 2008 21:55:06 -0800
Message-ID: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065536_564094_E102CD62)
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
ath9k_channel are the calibration data. Since it seems other
drivers can make use of this we add a priv section to
ieee80211_channel and start making use of this in ath9k.

The next series will deal more with this and then slowly start
to nuke our complex regulatory infrastructure in favor for
internal generic CRDA/cfg80211 regulatory infrastructure.

This work is all being done so we won't have to malloc() all
over again our new set of channels on country IE changes as
doing that would be a bit messy. We will instead prefer to use
static channels.

This should not have any major functional changes, its mostly
cleanup stuff. I've tested HT20 on 2 GHz, will test 5 GHz tomorrow
with the HT20/HT40 configurations but I figured I'll get this out
today. If someone beats me to testing 5 GHz HT20/HT40 configs me
please let me know.

Luis R. Rodriguez (16):
  mac80211: add HT conf helpers
  ath9k: use hw->conf on ath_setcurmode()
  ath9k: remove cache of rate preference when using 11g protection
  ath9k: Rename ath_setcurmode() to ath_cache_conf_rate()
  wireless: allow for private channel area
  ath9k: start making use of channel->priv
  ath9k: consolidate arguments on hw reset
  ath9k: make request to get the noisefloor threshold band specific
  ath9k: use ieee80211_conf on ath9k_hw_iscal_supported()
  ath9k: make use of conf_is_ht40() in the rest of the driver
  ath9k: Make ANI CCK and OFDM error triggers band specific
  ath9k: remove mode specific default noise floor values
  ath9k: remove ath9k_hw_chan2wmode()
  ath9k: remove ath9k_hw_check_chan()
  ath9k: remove superfluous check on changing channel
  ath9k: fix sparse warnings

 drivers/net/wireless/ath9k/ani.c    |   12 +-
 drivers/net/wireless/ath9k/ath9k.h  |   13 +-
 drivers/net/wireless/ath9k/calib.c  |  103 +++++-------
 drivers/net/wireless/ath9k/core.h   |    1 -
 drivers/net/wireless/ath9k/eeprom.c |   30 ++--
 drivers/net/wireless/ath9k/hw.c     |  210 +++++++-----------------
 drivers/net/wireless/ath9k/hw.h     |    8 +
 drivers/net/wireless/ath9k/main.c   |  317 +++++++++++++++-------------------
 drivers/net/wireless/ath9k/xmit.c   |   27 ++--
 include/net/mac80211.h              |   40 +++++
 include/net/wireless.h              |    3 +
 11 files changed, 334 insertions(+), 430 deletions(-)

