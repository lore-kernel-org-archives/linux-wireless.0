Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:55045 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863Ab1ECO1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 10:27:30 -0400
From: Yogesh Powar <yogeshp@marvell.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	"rossi.f@inwind.it" <rossi.f@inwind.it>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 3 May 2011 07:25:22 -0700
Subject: RE: WARNING: at net/mac80211/wep.c:101
 ieee80211_wep_add_iv+0x52/0x150 [mac80211]()
Message-ID: <7DDF37406E10F0438561DBB78326DF3902F35339F2@SC-VEXCH1.marvell.com> (sfid-20110503_162734_301000_ECD947B0)
References: <570950.1322951304422032629.JavaMail.defaultUser@defaultHost>,<BANLkTim3-ve4BD6wghA=F-asEqJmcDip6Q@mail.gmail.com>
In-Reply-To: <BANLkTim3-ve4BD6wghA=F-asEqJmcDip6Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>so may will this help? I don't know whether its a correct and with a
>quick test the warning gets fixed.
That should solve our problem with following explanation. 

The devices that require IV generation in software need tailroom reservation
for ICVs used in TKIP or WEP encryptions.

Currently, decision to skip the tailroom reservation in the tx
path was taken only on whether driver wants MMIC to be generated
in software or not. Following patch appends IV generation check for such
decisions.

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ca3c626..f3c4deb 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -102,7 +102,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+				(key->conf.flags &
+					IEEE80211_KEY_FLAG_GENERATE_IV)))
 			key->local->crypto_tx_tailroom_needed_cnt--;
 
 		return 0;
@@ -161,7 +163,9 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+				(key->conf.flags &
+					IEEE80211_KEY_FLAG_GENERATE_IV)))
 		key->local->crypto_tx_tailroom_needed_cnt++;
 }
 
-- 