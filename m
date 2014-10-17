Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62829 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaJQTvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 15:51:09 -0400
Received: by mail-wi0-f178.google.com with SMTP id h11so2307357wiw.17
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2014 12:51:08 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [RESEND PATCH v2 0/4] add VHT support to minstrel_ht 
Date: Fri, 17 Oct 2014 21:50:55 +0200
Message-Id: <1413575459-29612-1-git-send-email-karl.beldan@gmail.com> (sfid-20141017_215115_134803_527106EA)
In-Reply-To: <1413570896-27740-5-git-send-email-karl.beldan@gmail.com>
References: <1413570896-27740-5-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

(Sorry for spamming, Felix's address was mangled.)

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

