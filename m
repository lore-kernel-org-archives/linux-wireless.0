Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35553 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbbAWKBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 05:01:16 -0500
Message-ID: <1422007273.2728.24.camel@sipsolutions.net> (sfid-20150123_110129_219030_C5F6C60B)
Subject: Re: [RFCv3 1/4] mac80211: ibss/mesh move bw checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 11:01:13 +0100
In-Reply-To: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150120_133644_653402_AD13860F)
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150120_133644_653402_AD13860F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-20 at 13:35 +0100, Janusz Dziedzic wrote:
> We will need this as a preparetion for VHT.

"preparation" :)

It'd be good to explain it a little more though. At least the very last
hunk:

> @@ -401,6 +402,9 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
>  					      elems->ht_cap_elem, sta))
>  		changed |= IEEE80211_RC_BW_CHANGED;
>  
> +	if (bw != sta->sta.bandwidth)
> +		changed |= IEEE80211_RC_BW_CHANGED;
> +

seems new - not just moved.

johannes

