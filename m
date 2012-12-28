Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2L1Our (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 09:50:47 -0500
Message-ID: <1356706268.9922.23.camel@jlt4.sipsolutions.net> (sfid-20121228_155051_457605_B57502E3)
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Date: Fri, 28 Dec 2012 15:51:08 +0100
In-Reply-To: <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
	 <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok so I've let these patches languish for far too long ...



> +	} else {
> +		ieee80211_ibss_auth_sta(sta);

How does this compile? I see no static forward declaration (which I
wouldn't like anyway) and the function is defined only later?

Anyway this part is really confusing. If userspace is handling auth
frames, should the kernel really mark the station as authenticated? What
then is the point in handling auth frames in userspace??

Will?

Any chance we could converge on a single implementation here?

> +static void ieee80211_ibss_auth_sta(struct sta_info *sta)
> +{
> +	if (sta->sta_state > IEEE80211_STA_NONE)
> +		return;
> +
> +	sta_info_move_state(sta, IEEE80211_STA_AUTH);
> +	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
> +	/* authorize the station only if the network is not RSN protected. If
> +	 * not wait for the userspace to authorize it
> +	 */

technically, control_port != RSN protected, but I guess for IBSS ...
who's going to do WAPI? ;-)

> +	cfg80211_ibss_sta(sta->sdata->dev, sta->sta.addr, GFP_KERNEL);

I'm not really convinced that this event is the right thing to do.

If userspace is handing the auth frame, it already has the event right
there, no? It can even reply, even if for some reason it can't send a
negative reply because the kernel has already marked the station as
authenticated (see above).

If there's no userspace, then RSN can't work anyway, so maybe this isn't
really needed?

Also, a more generic event would make more sense I think?

> +	ieee80211_ibss_auth_expire(sdata);

It seems you should have something to trigger the timer too?

johannes

