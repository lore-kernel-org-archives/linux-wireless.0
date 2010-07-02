Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0GBSNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:13:24 -0400
Subject: Re: [PATCH 2.6.34] mac80211: Fix auth retries if AP sends
 temporary deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTikfegnc1gAwIUiZKaMeDoUYOFqK8eSc6_3wUggm@mail.gmail.com>
References: <AANLkTilV1t1737ciSPyyETeBEcN_QXsYxgEwpZIIucR2@mail.gmail.com>
	 <1278091743.15412.17.camel@jlt3.sipsolutions.net>
	 <AANLkTikfegnc1gAwIUiZKaMeDoUYOFqK8eSc6_3wUggm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 20:13:21 +0200
Message-ID: <1278094401.15412.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-02 at 11:09 -0700, Paul Stewart wrote:
> It may be a weird patch, but probably just because I'm still wrapping
> my head around how things work.  

Sure.

> The problem is ultimately the call to
> __cfg80211_send_deauth() in wireless/mlme.c that is triggered by
> reception of the DEAUTH.  

Is it? I thought it was without double underscore from another code
path?

> That function removes wdev->auth_bsses[i],

No, the BSS can't be in auth_bsses yet. I think the problem is more
complex, and wpa_supplicant itself will remove it from auth_bsses
because the kernel erroneously told it we got deauthenticated.

> which is needed in order for an auth to succeed.  The code path that
> gets us there is:
> 
>     mac80211/rx.c: ieee80211_rx_h_mgmt()
>     mac80211/mlme.c: ieee80211_sta_rx_mgmt()
>     ...then through the queued work and...
>     ieee80211_sta_rx_queued_mgmt()
> 
> At the bottom of the latter function, outside of the block that checks
> for our authentication state, we call cfg80211_send_deauth() in
> response to IEEE80211_STYPE_DEAUTH, which quite arguably should never
> be called if we're authenticated.  The only time this issue touches
> cfg80211 is that final call to send_deauth() which I believe is done
> in error.  I think the fix should be in mac80211 somewhere.
> 
> I didn't find a way to tell where we were in the authentication proces
> from within ieee80211_sta_rx_queued_mgmt(), so I swallowed the packet
> much earlier in the process from within ieee80211_work_rx_mgmt(),
> which has access to that state, and can indeed claim packets for
> itself it it believes it knows best what to do with them.
> 
> I hope this clears up my thinking on this.  I'd be happy to change the
> patch in whatever way makes sense.

Can you try the patch below instead of yours? I'll explain it a bit more
later, but my church wedding ceremony is tomorrow :)

johannes

--- wireless-testing.orig/net/wireless/mlme.c	2010-07-02 20:12:19.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-07-02 20:12:43.000000000 +0200
@@ -44,10 +44,10 @@ void cfg80211_send_rx_auth(struct net_de
 		}
 	}
 
-	WARN_ON(!done);
-
-	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
-	cfg80211_sme_rx_auth(dev, buf, len);
+	if (done) {
+		nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
+		cfg80211_sme_rx_auth(dev, buf, len);
+	}
 
 	wdev_unlock(wdev);
 }


