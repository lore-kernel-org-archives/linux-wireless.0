Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44401 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1K1R4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 12:56:24 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 0/4] add HT support for IBSS
Date: Mon, 28 Nov 2011 18:55:12 +0100
Message-Id: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111128_185634_207138_2941612B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set adds support for HT datarates in IBSS. It is based on Alexander
Simons previous work. The changes can be found in the individual patch messages.

The first patch fixes probe requests sending no rates supported (at least
wireshark does not find this funny). The second patch adds support for nl80211.
Feature checking is implicitly performed through rdev_freq_to_chan(), which
denies the configuration if HT support is not available. The third patch adds
the mac80211 ibss support. Finally, further IEEE 802.11 standard compatibility
questions are adressed in the fourth patch.

The HT configuration set through nl80211 is not adopted from other STAs as the
standard (10.3.2.2.2/11.14.2) suggests - after several discussion with other
developers, we agreed that this may lead to unpredictable behaviour. We prefer
to keep the local configuration and adapt the HT parameters for transmission
to other STAs individually. 

For further standard compatibility (see fourth patch):
 * 9.13.3.1: IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED is set and may
   be used, so far only a few drivers consider it (iwl*, rt2x00, wl12xx,
   brcm80211, mwl8k)
 * 9.13.3.1: IEEE80211_HT_PARAM_RIFS_MODE is set and may be used, so far
   no driver seems to consider it.
 * 11.5.1.1: BA is only allowed when we previously received a probe response
   or beacon with HT information. Therefore, this is partially implemented
   - we don't implement a probe request. However, this should serve the same
   purpose IMHO and and avoids sending the ADDBA requests to legacy stations.

I have tested this feature in an IBSS of two ath9k and one ath5k device. The
devices join the cell succesfully and the ath9k use HT40 if the configuration
matches (I've measured 70 Mbit/s) or HT20 (~40 Mbit/s) if it does not. 
Also the (legacy) communication to ath5k works.

There is an iw patch as well to make use of this feature.

It should apply well on the latest wireless-testing kernel.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

Simon Wunderlich (4):
  mac80211: fill rate filter for internal scan requests
  nl80211: Parse channel type attribute in an ibss join request
  mac80211: Add HT operation modes for IBSS
  mac80211: handle protection mode, RIFS and ADDBA for HT IBSS

 include/net/cfg80211.h     |   11 +++++
 net/mac80211/agg-rx.c      |    2 +
 net/mac80211/agg-tx.c      |   26 +++++++++++-
 net/mac80211/ht.c          |    2 +
 net/mac80211/ibss.c        |  101 ++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |    6 +++
 net/mac80211/rx.c          |    3 +-
 net/mac80211/util.c        |    3 +
 net/wireless/chan.c        |   12 +++--
 net/wireless/nl80211.c     |   27 +++++++++++-
 11 files changed, 176 insertions(+), 18 deletions(-)

-- 
1.7.7.3

