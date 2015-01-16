Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41261 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbbAPKzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:55:06 -0500
Message-ID: <1421405703.9214.4.camel@sipsolutions.net> (sfid-20150116_115511_837890_2FB85C4C)
Subject: Re: [RFCv2 6/6] mac80211: IBSS setup correctly BW for VHT
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Jan 2015 11:55:03 +0100
In-Reply-To: <1421404724-32326-6-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113943_517353_27DA5285)
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421404724-32326-6-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150116_113943_517353_27DA5285)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-16 at 11:38 +0100, Janusz Dziedzic wrote:

> +				/* we both use VHT */
> +				struct ieee80211_vht_cap vhtcap_ie;
> +				struct ieee80211_sta_vht_cap vht_cap = sta->sta.vht_cap;
> +
> +				ieee80211_vht_oper_to_chandef(channel,
> +							      elems->vht_operation,
> +							      &chandef);

Ok maybe I'm missing something - but can't this erroneously configure
the local HW to 160 MHz when it doesn't even support it, or so?

> +				memcpy(&vhtcap_ie, elems->vht_cap_elem, sizeof(vhtcap_ie));
> +				ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband, &vhtcap_ie, sta);
> +				if (memcmp(&vht_cap, &sta->sta.vht_cap, sizeof(vht_cap)))
> +						rates_updated |= true;

Indentation is wrong here.

johannes

