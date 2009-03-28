Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4532 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZC1Qlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 12:41:53 -0400
Date: Sat, 28 Mar 2009 12:39:29 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	mickflemm@gmail.com
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Message-ID: <20090328163929.GA24075@hash.localnet> (sfid-20090328_174156_719492_07FCD436)
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com> <20090324184100.GA29268@tesla> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com> <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com> <1237926664.4320.131.camel@johannes.local> <43e72e890903241504u4dfb5c76kbcb11a096bba72fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890903241504u4dfb5c76kbcb11a096bba72fc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 03:04:59PM -0700, Luis R. Rodriguez wrote:
> >> > Channel list is a good hint, maybe
> >> > it's time to fix iw/nl80211 to send back all the channels :)
> >
> > I looked into yesterday actually, and it's completely non-trivial and
> > requires userspace interface changes.
> 
> Heh, there goes that idea then. Then in that case I'd advocate even
> more trimming the channels down.

Nick, what do you think of this?  I think it's the best compromise
for now - people can still get all the channels, normal users get a
nice speedup in the default case.

--------------------
>From 7289f60a3acf3bb1cfcc2a7ef7c4d88ffd0e13f1 Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Sat, 28 Mar 2009 12:27:31 -0400
Subject: [PATCH] ath5k: reduce exported channel list

Claiming every available 5 ghz channel has a couple of negative
side-effects: scanning takes a long time, and the channel list
overflows the available buffer space for netlink commands,
resulting in:

    $ iw phy phy0 info
    command failed: No buffer space available (-105)

This patch adds a modparam so people who want to see all the channels
can do so by passing all_channels=1.  By default users will see a
smaller list of channels that works with iw.  This also halves scan
time, from 10 seconds down to less than 5.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 5d57d77..a018106 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -64,6 +64,10 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
+static int modparam_all_channels;
+module_param_named(all_channels, modparam_all_channels, int, 0444);
+MODULE_PARM_DESC(all_channels, "Expose all channels the device can use.");
+
 
 /******************\
 * Internal defines *
@@ -862,6 +866,20 @@ ath5k_ieee2mhz(short chan)
 		return 2212 + chan * 20;
 }
 
+/*
+ * Returns true for the channel numbers user without all_channels modparam.
+ */
+static bool ath5k_is_standard_channel(short chan)
+{
+	return ((chan <= 14) ||
+		/* UNII 1,2 */
+		((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
+		/* midband */
+		((chan & 3) == 0 && chan >= 100 && chan <= 140) ||
+		/* UNII-3 */
+		((chan & 3) == 1 && chan >= 149 && chan <= 165));
+}
+
 static unsigned int
 ath5k_copy_channels(struct ath5k_hw *ah,
 		struct ieee80211_channel *channels,
@@ -899,6 +917,9 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		if (!ath5k_channel_ok(ah, freq, chfreq))
 			continue;
 
+		if (!modparam_all_channels && !ath5k_is_standard_channel(ch))
+			continue;
+
 		/* Write channel info and increment counter */
 		channels[count].center_freq = freq;
 		channels[count].band = (chfreq == CHANNEL_2GHZ) ?
-- 
1.6.0.6


-- 
Bob Copeland %% www.bobcopeland.com

