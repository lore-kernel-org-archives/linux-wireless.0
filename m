Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:37518 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab3KHQe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 11:34:58 -0500
Received: by mail-we0-f177.google.com with SMTP id x55so2142211wes.8
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 08:34:57 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 2/2] mac80211: minstrel_ht: do not sample unsupported rates
Date: Fri,  8 Nov 2013 17:34:33 +0100
Message-Id: <1383928473-798-2-git-send-email-karl.beldan@gmail.com> (sfid-20131108_173505_453121_7B33D58D)
In-Reply-To: <1383928473-798-1-git-send-email-karl.beldan@gmail.com>
References: <1383928473-798-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM minstrel_ht does not check whether the sampling rate is supported.
Unsupported rates attempts can trigger when there are holes between
supported MCSes belonging to the same group (e.g many devices are
capable of MCS32 without being capable of MCS33->MCS39).
This change replaces an unsupported sample index with the fls of the
bitfield of supported indexes.
This is not a problem in minstrel which fills a per STA sample table
with only supported rates (though only at init).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index aeec401..1b835ad 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -703,6 +703,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 	mg = &mi->groups[mi->sample_group];
 	sample_idx = sample_table[mg->column][mg->index];
+	if (!(mg->supported & BIT(sample_idx)))
+		sample_idx = fls(sample_idx) - 1;
 	mr = &mg->rates[sample_idx];
 	sample_group = mi->sample_group;
 	sample_idx += sample_group * MCS_GROUP_RATES;
-- 
1.8.2

