Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60755 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaJQSfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 14:35:08 -0400
Received: by mail-wg0-f44.google.com with SMTP id y10so1501529wgg.15
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2014 11:35:06 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 0/4] add VHT support to minstrel_ht 
Date: Fri, 17 Oct 2014 20:34:52 +0200
Message-Id: <1413570896-27740-1-git-send-email-karl.beldan@gmail.com> (sfid-20141017_203511_685689_DE21C182)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Hi,

This is a split version of the VHT support addition to minstrel.
Thanks for reviewing,

Karl Beldan (4):
  mac80211: minstrel_ht: Increase the range of handled rate indexes
  mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
  mac80211: minstrel_ht: include type (cck/ht) in rates flag
  mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
v2:
- typo in Kconfig
- adjust room in debugfs rc_stats buffer
- add a module param to mix ht rates with vht ones
- default to 3SS instead of 2SS (with "mac80211: minstrel_ht: macros
  adjustments for future VHT_GROUPs")
- use common MINSTREL_MAX_STREAMS both for VHT and HT so that we can get
  rid of the 'MINSTREL_MAX_STREAMS >= 3' checks for minstrel_mcs_groups

 net/mac80211/Kconfig                       |   7 +
 net/mac80211/rc80211_minstrel_ht.c         | 288 +++++++++++++++++++++++------
 net/mac80211/rc80211_minstrel_ht.h         |  38 +++-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  32 ++--
 4 files changed, 286 insertions(+), 79 deletions(-)

-- 
2.0.1

