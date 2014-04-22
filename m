Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545AbaDVVuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 17:50:14 -0400
Date: Tue, 22 Apr 2014 23:50:12 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Michael Leun <lkml20140418@newton.leun.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	arik@wizery.com, linux@eikelenboom.it
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
Message-ID: <20140422215012.GS27882@wotan.suse.de> (sfid-20140422_235119_729143_17F51BAA)
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com> <20140422180003.6438dbb7@xenia.leun.net> <20140422204552.GR27882@wotan.suse.de> <20140422233213.780405d1@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140422233213.780405d1@xenia.leun.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 11:32:13PM +0200, Michael Leun wrote:
> On Tue, 22 Apr 2014 22:45:52 +0200
> "Luis R. Rodriguez" <mcgrof@suse.com> wrote:
> 
> 
> > > I only see this on an Acer PTZ1825 with an ath9k wireless card, but
> > > that machine was not sold with that wlan card, so other people with
> > > the same model won't neccesarily see the same issue.
> > 
> > OK I see the issue and its clear now how this could have
> > gone through, the wiphy comes from the country IE and it
> > could have gone disappearing during suspend / hotplug, so
> > we do need to check for it again.
> [...]
> > -		if (wiphy->regulatory_flags &
> > REGULATORY_COUNTRY_IE_IGNORE)
> > +		if (wiphy &&
> > +		    wiphy->regulatory_flags &
> > REGULATORY_COUNTRY_IE_IGNORE) return REG_REQ_IGNORE;
> 
> Yup, thats it. I can hear it whisper "put me into stable".

I was a bit perplexed that this was not picked up before, so I hunted
a bit and found a fix that was applied to the mac80211-next upstream
development tree but not propagated to stable. Can you remove that pach,
just git checkout -f and try this one instead? It applies cleanly and
since its upstream on Linus' tree already we should be able to get this
to Greg faster if you confirm it fixes your issue. So all we need is
a Tested-by.

  Luis

commit 772f0389338cfcf96da1c178046dc7e1649ab554
Author: Ilan Peer <ilan.peer@intel.com>
Date:   Tue Jan 14 15:17:23 2014 +0200

    cfg80211: fix few minor issues in reg_process_hint()
    
    Fix the following issues in reg_process_hint():
    
    1. Add verification that wiphy is valid before processing
       NL80211_REGDOMAIN_SET_BY_COUNTRY_IE.
    2. Free the request in case of invalid initiator.
    3. Remove WARN_ON check on reg_request->alpha2 as it is not a
       pointer.
    
    Signed-off-by: Ilan Peer <ilan.peer@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b897fc..484facf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1683,17 +1683,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
 
-	if (WARN_ON(!reg_request->alpha2))
-		return;
-
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER && !wiphy) {
-		kfree(reg_request);
-		return;
-	}
-
 	switch (reg_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 		reg_process_hint_core(reg_request);
@@ -1706,20 +1698,29 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
+		if (!wiphy)
+			goto out_free;
 		treatment = reg_process_hint_driver(wiphy, reg_request);
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		if (!wiphy)
+			goto out_free;
 		treatment = reg_process_hint_country_ie(wiphy, reg_request);
 		break;
 	default:
 		WARN(1, "invalid initiator %d\n", reg_request->initiator);
-		return;
+		goto out_free;
 	}
 
 	/* This is required so that the orig_* parameters are saved */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
 	    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
+
+	return;
+
+out_free:
+	kfree(reg_request);
 }
 
 /*
