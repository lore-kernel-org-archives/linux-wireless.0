Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:52076 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZDWRgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:36:11 -0400
Received: by fg-out-1718.google.com with SMTP id 16so37269fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 10:36:10 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 19:35:55 +0200
Message-ID: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com> (sfid-20090423_193615_455996_4524641B)
Subject: [PATCH 0/5] mac80211, iwlwifi, ath9k: Fix rate scaling for
	IEEE80211_TX_CTL_NO_ACK packets
To: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handling of multicast/NO_ACK packets by mac80211 rate scaling is a
mess. Basically, the rule of thumb is that any packet with
IEEE80211_TX_CTL_NO_ACK (including multicasts and broadcasts, which
always have this flag set) should be sent at lowest rate (unless
overridden by radiotap - this is not covered in this patchset), with
no retries.

So, the right thing to do in any rate scaling algorithm:
 * Check for IEEE80211_TX_CTL_NO_ACK. No need to check
is_multicast_ether_addr, as multicasts always have NO_ACK set.
 * If it is set, select the lowest available rate (unless overridden
by radiotap), with a retry count of 0 (total try count of 1).

However, the actual rate scaling algorithms get this wrong in various w=
ays:
 * Minstrel checks for both is_multicast_ether_addr and
IEEE80211_TX_CTL_NO_ACK (redundant, since the former implies the
latter), and sets the rate to the lowest (correct), and the retry
count to the max (wrong).
 * PID only checks is_multicast_ether_addr (completely leaving out
unicasts with IEEE80211_TX_CTL_NO_ACK set by e.g. Radiotap), setting
the rate to the lowest (correct). However, the same logic is used for
determining retry count of multicasts as for unicasts (wrong).
 * Iwlwifi's rate scaling algorithms behave like PID. In addition,
they appear to not care about retry count at all, which is handled in
the drivers themselves I guess.
 * Ath5k's algorithm correctly sets both the rate and the retry count
- but incorrectly bases its checks on is_multicast_ether_addr instead
of IEEE80211_TX_CTL_NO_ACK, again missing unicasts with this flag set.

Most PHYs can gracefully handle this error (with the help of a no-ACK
knob in the PHY TX header that disables retries), but those that have
no such knob, and instead depend on getting a correct retry count of 0
(total try count of 1), such as RTL818x, end up always transmitting
multicast/NO_ACK frames multiple times, as (incorrectly) requested by
the RC algorithm.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Louis R. Rodriguez <mcgrof@gmail.com>

G=E1bor Stefanik (5):
 mac80211: Fix handling of retry count of NO_ACK frames in minstrel
 mac80211: Fix handling of retry count of NO_ACK frames in PID
 iwlwifi: Fix handling of retry count of NO_ACK frames for iwl-{3945|ag=
n}-rs
 ath5k: Fix handling of retry count of NO_ACK frames
 mac80211: Warn if the rate controller requests retries for a NO_ACK fr=
ame

 drivers/net/wireless/ath/ath9k/rc.c        |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   14 +++++++-------
 net/mac80211/rc80211_minstrel.c            |    8 +++++---
 net/mac80211/rc80211_pid_algo.c            |    8 +++++---
 net/mac80211/tx.c                          |    4 ++++
 6 files changed, 28 insertions(+), 19 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
