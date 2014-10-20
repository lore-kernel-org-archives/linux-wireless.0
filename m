Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39083 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaJTIz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:55:57 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so4866619wgh.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 01:55:56 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, karl.beldan@gmail.com
Subject: [PATCH v4 0/4] add VHT support to minstrel_ht
Date: Mon, 20 Oct 2014 10:55:38 +0200
Message-Id: <1413795342-11995-1-git-send-email-karl.beldan@gmail.com> (sfid-20141020_105604_644794_C32DA7AE)
In-Reply-To: <1413652424-14345-5-git-send-email-karl.beldan@gmail.com>
References: <1413652424-14345-5-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Hi,

This is just a respin rebased on v2 of "mac80211: minstrels: fix buffer
overflow in HT debugfs" which only affects 4/4.

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
v3:
- put module param *vht_only* under CONFIG_MAC80211_RC_MINSTREL_VHT
v4:
- rebase on v2 of "mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats"

 net/mac80211/Kconfig                       |   7 +
 net/mac80211/rc80211_minstrel_ht.c         | 292 +++++++++++++++++++++++------
 net/mac80211/rc80211_minstrel_ht.h         |  38 +++-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  32 ++--
 4 files changed, 290 insertions(+), 79 deletions(-)

-- 
2.0.1

