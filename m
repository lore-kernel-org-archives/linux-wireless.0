Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab1KBH4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 03:56:22 -0400
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EAAD734.10501@candelatech.com> (sfid-20111028_182428_876939_0D798225)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
	 <4EAAD734.10501@candelatech.com> (sfid-20111028_182428_876939_0D798225)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 08:56:17 +0100
Message-ID: <1320220577.3950.4.camel@jlt3.sipsolutions.net> (sfid-20111102_085624_436019_7EF6F613)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 09:24 -0700, Ben Greear wrote:

> >> +++ b/net/mac80211/cfg.c
> >> @@ -57,6 +57,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
> >>   	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> >>   	int ret;
> >>
> >> +	if (params->disable_11n != -1)
> >> +		sdata->cfg_disable_11n = params->disable_11n;
> >
> > This doesn't seem right -- why change the iface for it? It's a per
> > connection parameter.
> 
> I wanted it to be an interface parameter, or at least I think
> that is what I want.

Why? I'm thinking that it's better as a connection parameter as then
it's more temporal. I know we have interface parameters like RTS/CTS
settings etc, but I like connection parameters better as they go away
with each new connection, so the behaviour is less surprising to most
users. Imagine your wpa_supplicant crashes, and then the user who was
restricting it to no-HT starts the regular wpa_supplicant; now his
interface will be in no-HT until he reboots or figures out the right
magic to change it. I think that kind of situation is undesirable.


> I would like eventually to support this same feature for AP
> interfaces, and probably other types.  Would it still be in
> the u.mgd struct in that case?

No, but again there I'd argue that it should be a "connection" parameter
as well.

johannes

