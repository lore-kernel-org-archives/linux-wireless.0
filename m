Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1KRR2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 12:28:46 -0500
Subject: Re: [PATCH v9 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EC69155.4060306@candelatech.com>
References: <1321566884-31757-1-git-send-email-greearb@candelatech.com>
	 <1321566884-31757-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111117_225512_858995_688665F5) <1321611355.10266.30.camel@jlt3.sipsolutions.net>
	 <4EC69155.4060306@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 18:28:42 +0100
Message-ID: <1321637322.10266.70.camel@jlt3.sipsolutions.net> (sfid-20111118_182901_712145_9CF4D730)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 09:09 -0800, Ben Greear wrote:
> On 11/18/2011 02:15 AM, Johannes Berg wrote:
> > On Thu, 2011-11-17 at 13:54 -0800, greearb@candelatech.com wrote:
> >
> >> -void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
> >> +bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
> >> +{
> >> +	const u16 flg = IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> >> +	if ((sdata->u.mgd.ht_capa_mask.cap_info&  flg)&&
> >> +	    !(sdata->u.mgd.ht_capa.cap_info&  flg))
> >> +		return true;
> >
> > This looks like it has endian bugs. Note that sband->ht_cap is
> > ieee80211_sta_ht_cap, whereas sdata->u.mgd.ht_capa[_mask] is
> > ieee80211_ht_cap -- the latter is in IEEE format (LE) while the former
> > is in a complete different format that's easier to digest for the
> > CPU :-)
> 
> So, the ht-caps & mask data coming from user-space via netlink
> should be in network-byte order?

It is that way right now, and that makes sense.

> Or do you want me to flip the bytes around when copying
> it into the u.mgd.ht_cap structs?

No. Just use them in little endian ("network byte order" for 802.11)

johannes

