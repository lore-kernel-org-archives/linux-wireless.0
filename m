Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60410 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbbEKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 05:53:30 -0400
Message-ID: <1431338007.1964.16.camel@sipsolutions.net> (sfid-20150511_115333_602398_1F8020F0)
Subject: Re: [PATCH] mac80211: IBSS, clear fast_sta when update rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 May 2015 11:53:27 +0200
In-Reply-To: <1431337921.1964.15.camel@sipsolutions.net> (sfid-20150511_115210_912154_EBE83A3A)
References: <1431337193-17472-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150511_113957_922464_EF6D0870) <1431337921.1964.15.camel@sipsolutions.net>
	 (sfid-20150511_115210_912154_EBE83A3A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-11 at 11:52 +0200, Johannes Berg wrote:
> On Mon, 2015-05-11 at 11:39 +0200, Janusz Dziedzic wrote:
> > This is required to handle sta.wme correctly
> > after update rates (eg. when using HT/VHT) when
> > driver using IEEE80211_HW_SUPPORT_FAST_XMIT.
> 
> Wouldn't you want to check, so it can be re-assigned?

i.e. something like

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bfef1b215050..7e62183525aa 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1031,8 +1031,11 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (sta && elems->wmm_info && local->hw.queues >= IEEE80211_NUM_ACS)
+	if (sta && !sta->sta.wme && elems->wmm_info &&
+	    local->hw.queues >= IEEE80211_NUM_ACS) {
 		sta->sta.wme = true;
+		ieee80211_check_fast_xmit(sta);
+	}
 
 	if (sta && elems->ht_operation && elems->ht_cap_elem &&
 	    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&


johannes

