Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:34961 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab1K3P4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 10:56:39 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCHv2 0/3] add HT support for IBSS
Date: Wed, 30 Nov 2011 16:56:31 +0100
Message-Id: <1322668595-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111130_165642_834310_1164E575)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set adds support for HT datarates in IBSS. It is based on Alexander
Simons previous work. The changes can be found in the individual patch messages.

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

Changes between this version and PATCH:
 * change patch order
 * add 802.11n-2009 reference name
 * fix authorship
 * add nl80211_feature_flag for HT IBSS
 * remove internal scan request fix to send it separately

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

Alexander Simon (2):
  nl80211: Parse channel type attribute in an ibss join request
  mac80211: Add HT operation modes for IBSS

Simon Wunderlich (1):
  mac80211: handle protection mode, RIFS and ADDBA for HT IBSS

 include/linux/nl80211.h    |    2 +
 include/net/cfg80211.h     |   11 +++++
 net/mac80211/agg-rx.c      |    2 +
 net/mac80211/agg-tx.c      |   26 +++++++++++-
 net/mac80211/ht.c          |    2 +
 net/mac80211/ibss.c        |  101 ++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |    3 +-
 net/mac80211/rx.c          |    3 +-
 net/mac80211/util.c        |    5 ++
 net/wireless/chan.c        |   12 +++--
 net/wireless/nl80211.c     |   32 +++++++++++++-
 12 files changed, 181 insertions(+), 19 deletions(-)

-- 
1.7.7.3

