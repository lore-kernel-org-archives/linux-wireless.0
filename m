Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43134 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcK1OPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:15:00 -0500
Message-ID: <1480342496.8107.41.camel@sipsolutions.net> (sfid-20161128_151506_776348_0CC8F701)
Subject: Re: [PATCH 1/2] nl80211: Use different attrs for BSSID and random
 MAC addr in scan req
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Vamsi Krishna <vamsin@qti.qualcomm.com>
Date: Mon, 28 Nov 2016 15:14:56 +0100
In-Reply-To: <1480063462.2517.105.camel@coelho.fi>
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
         <1480063462.2517.105.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > + * @NL80211_ATTR_BSSID: The BSSID of the AP (various uses). Note
> > that
> 
> The BSSID may also be used for other things, like P2P GO, right? Also
> "various uses" is probably unnecessary? Every command using this
> attribute should describe it's use in their description.
> 
> 
> > 
> > + *	%NL80211_ATTR_MAC has also been used in various
> > commands/events for
> > + *	specifying the BSSID.
> 
> This can be a bit confusing.  Maybe you can specify which commands
> *used* to use NL80211_ATTR_MAC but now use NL80211_ATTR_BSSID?

I'd actually avoid that, let's not make the "compatibility quirks" part
of the documentation people read through normally ... In the code,
that's fine, but here, I think less so.

With that, perhaps just rephrase this to

"The BSSID of the AP. Note that %NL80211_ATTR_MAC is also used in
various commands/events for specifying the BSSID."

> > -	if (info->attrs[NL80211_ATTR_MAC])
> > +	/* Initial implementation used NL80211_ATTR_MAC to set the
> > specific
> > +	 * BSSID to scan for. This was problematic because that
> > same attribute
> > +	 * was already used for another purpose (local random MAC
> > address). The
> > +	 * NL80211_ATTR_BSSID attribute was added to fix this. For
> > backwards
> > +	 * compatibility with older userspace components, also use
> > the
> > +	 * NL80211_ATTR_MAC value here if it can be determined to
> > be used for
> > +	 * the specific BSSID use case instead of the random MAC
> > address
> > +	 * (NL80211_ATTR_SCAN_FLAGS is used to enable random MAC
> > address use).
> > +	 */
> 
> You should probably add this information to the
> NL80211_CMD_TRIGGER_SCAN description.

It may need an update to refer to ATTR_BSSID, but again I don't think
all the compatibility discussion should be there.

> 
> > 
> > +	if (info->attrs[NL80211_ATTR_BSSID])
> > +		memcpy(request->bssid,
> > +		       nla_data(info->attrs[NL80211_ATTR_BSSID]),
> > ETH_ALEN);
> > +	else if (!info->attrs[NL80211_ATTR_SCAN_FLAGS] &&
> 
> You should actually check that the SCAN_FLAGS attribute either
> doesn't
> exist (as you already do) or, if it exists, that it doesn't have the
> NL80211_SCAN_FLAG_RANDOM_ADDR flags.
> 

Agree with that, that would make sense.

johannes
