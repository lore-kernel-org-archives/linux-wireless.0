Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33137 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZGRWdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 18:33:00 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: WARN_ON at minstrel_get_rate (include/net/mac80211.h:2111) with p54usb
Date: Sun, 19 Jul 2009 00:32:57 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <4A611FC0.9040507@lwfinger.net> <4A61E436.9060808@lwfinger.net> <b6c5339f0907181419h28b84166s72ba9386f2833c61@mail.gmail.com>
In-Reply-To: <b6c5339f0907181419h28b84166s72ba9386f2833c61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907190032.58156.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 18 July 2009 23:19:36 Bob Copeland wrote:
> On Sat, Jul 18, 2009 at 11:03 AM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> > Christian Lamparter wrote:
> >> On Saturday 18 July 2009 03:05:04 Larry Finger wrote:
> >>> Johannes and Christian,
> >>>
> >>> I am getting a WARN_ON from mac80211 in the location stated in the
> >>> subject. I put in some test prints and got the following:
> >>>
> >>> sband->n_bitrates 8, Band 1, supp_rates 0x0
> >> hmm, so something decides to talk to a 5GHz network here?
> >> But the AP doesn't have any available rates in that band!?
> >
> > Ah, band 1 is 5GHz, not 2.4. There are no 802.11a AP's in my neighborhood.
> >
> >> If my memory serves my right some people have triggered the same WARN_ON
> >> with the ath5k driver as well...
> >> unfortunately, I didn't follow the thread and now I can't find it anymore.
> >>
> >> (btw: is your b43 11a capable as well?)
> >
> > Yes it is, but that section is software crippled.
> >
> > Thanks for the patch. I'll let you know what happens.
> 
> In the ath5k case as well, I'm willing to bet it has something to do with dual
> band operation.  IIRC at least some instances of this in the past were due to
> getting the rate after the band was changed, e.g. due to scanning, and the peer
> of course didn't support any rates on that band.
> 
well, ieee80211_sta_monitor_work - which probes the AP every now and then -
didn't check if we're scanning.
The attached diff survives a non-stop scanning without throwing the WARN in
rate_lowest_index once.

However, I'm not so sure about the locking for hw_scanning and sw_scanning.
It looks like only scan.c manipulates them under the scan mutex.
But then, do we need locking for a single threaded workqueue? guess not.
---
Larry,

here's another _fix_ which might even fix the problem after all ;-)

Regards,
	Chr
---
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 18dad22..4833e7c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2210,6 +2210,9 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.monitor_work);
 
+	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+		return;
+
 	ieee80211_mgd_probe_ap(sdata, false);
 }
 
