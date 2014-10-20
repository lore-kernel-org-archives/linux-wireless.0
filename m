Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56415 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaJTNqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:46:20 -0400
Received: by mail-wg0-f50.google.com with SMTP id a1so5541366wgh.9
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:46:19 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, karl.beldan@gmail.com
Subject: [PATCH v5 0/4] add VHT support to minstrel_ht
Date: Mon, 20 Oct 2014 15:45:58 +0200
Message-Id: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com> (sfid-20141020_154624_760716_0E7EB2D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Hi,

Varka Bhadram reported checkpatch is noisy on this series.
I made another pass which affects [2/4](trivially) and [4/4].
This could have been a patch on top of what Felix acked, I hope you
won't bother too much.
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
v3:
- put module param *vht_only* under CONFIG_MAC80211_RC_MINSTREL_VHT
v4:
- rebase on v2 of "mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats"
v5:
- fix some checkpatch complaints this, leaves 2 false positives 
  "ERROR: Macros with complex values should be enclosed in parenthesis"
  in array initialization

 net/mac80211/Kconfig                       |   7 +
 net/mac80211/rc80211_minstrel_ht.c         | 311 +++++++++++++++++++++++------
 net/mac80211/rc80211_minstrel_ht.h         |  40 +++-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  33 +--
 4 files changed, 309 insertions(+), 82 deletions(-)

-- 
2.0.1

