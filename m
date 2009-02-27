Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbZB0VHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:07:11 -0500
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kalle.valo@iki.fi>, Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1235459626.4320.3.camel@johannes.local> (sfid-20090224_081432_459157_E571CC87)
References: <49A01922.1090106@lwfinger.net>
	 <1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>
	 <8763j33rgq.fsf@litku.valot.fi>
	 (sfid-20090222_074023_562332_D346678B) <1235441441.4455.58.camel@johannes.local>
	 <49A37531.70907@lwfinger.net> <1235452576.4455.81.camel@johannes.local>
	 <49A39C9C.7040002@lwfinger.net>  <1235459626.4320.3.camel@johannes.local>
	 (sfid-20090224_081432_459157_E571CC87)
Content-Type: text/plain
Date: Fri, 27 Feb 2009 18:45:54 +0100
Message-Id: <1235756754.7426.77.camel@johannes.local> (sfid-20090227_220714_914747_7DFF2907)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-02-23 at 23:13 -0800, Johannes Berg wrote:

> > >> No, I just wondered if it was intentional that it was changed to /70. It appears
> > >> that it was, therefore, at least 3 drivers must be changed as they are
> > >> calculating on the basis of /100. For example, my b43 is showing an iwconfig
> > >> Link Quality of 93/70 while the KNM applet is showing 50%.
> > > 
> > > Well that _is_ a bug, since this shouldn't have required driver changes!
> > > I'll take a look into why that might be happening.
> > 
> > Drivers b43, b43legacy, rtl8187, and p54usb all assume a Link Quality scaled to
> > 100, which was the behavior before the commit in the subject. I don't quite
> > understand why as the old code had this fragment:
> 
> Ahh. I see now, you're talking wireless_stats and I'm thinking scan
> results. Yeah, I see what's going on, I'll fix it tomorrow.

Ok so tomorrow wasn't it, but I think I've fixed it. I didn't test it
because I'm sitting on an airplane from Portland to DC right now.

Since I'll be gone for a week once you read this email, I would
appreciate if you could submit this patch if it works (or if it doesn't
and you can fix it), adding appropriate tested-by tags, and maybe adding
some more of the information that you had to the commit log.

johannes


From: Johannes Berg <johannes@sipsolutions.net>

Fix mac80211 quality repoorting for wireless stats.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Larry Finger <larry.finger@lwfinger.net>
---
 net/mac80211/wext.c |   58 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 19 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-02-27 18:28:24.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-27 18:45:17.000000000 +0100
@@ -886,21 +886,6 @@ static int ieee80211_ioctl_siwauth(struc
 	return ret;
 }
 
-static u8 ieee80211_get_wstats_flags(struct ieee80211_local *local)
-{
-	u8 wstats_flags = 0;
-
-	wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
-					   IEEE80211_HW_SIGNAL_DBM) ?
-				IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
-	wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
-				IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		wstats_flags |= IW_QUAL_DBM;
-
-	return wstats_flags;
-}
-
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
 static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
@@ -922,10 +907,45 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.noise = 0;
 		wstats->qual.updated = IW_QUAL_ALL_INVALID;
 	} else {
-		wstats->qual.level = sta->last_signal;
-		wstats->qual.qual = sta->last_qual;
-		wstats->qual.noise = sta->last_noise;
-		wstats->qual.updated = ieee80211_get_wstats_flags(local);
+		wstats->qual.updated = 0;
+		/*
+		 * mirror what cfg80211 does for iwrange/scan results,
+		 * otherwise userspace gets confused.
+		 */
+		if (local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
+				       IEEE80211_HW_SIGNAL_DBM)) {
+			wstats->qual.updated |= IW_QUAL_LEVEL_UPDATED;
+			wstats->qual.updated |= IW_QUAL_QUAL_UPDATED;
+		} else {
+			wstats->qual.updated |= IW_QUAL_LEVEL_INVALID;
+			wstats->qual.updated |= IW_QUAL_QUAL_INVALID;
+		}
+
+		if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC) {
+			wstats->qual.level = sta->last_signal;
+			wstats->qual.qual = sta->last_signal;
+		} else if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+			int sig = sta->last_signal;
+
+			wstats->qual.updated |= IW_QUAL_DBM;
+			wstats->qual.level = sig;
+			if (sig < -110)
+				sig = -110;
+			else if (sig > -40)
+				sig = -40;
+			wstats->qual.qual = sig + 110;
+		}
+
+		if (local->hw.flags & IEEE80211_HW_NOISE_DBM) {
+			/*
+			 * This assumes that if driver reports noise, it also
+			 * reports signal in dBm.
+			 */
+			wstats->qual.noise = sta->last_noise;
+			wstats->qual.updated |= IW_QUAL_NOISE_UPDATED;
+		} else {
+			wstats->qual.updated |= IW_QUAL_NOISE_INVALID;
+		}
 	}
 
 	rcu_read_unlock();


