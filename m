Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59698 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbZCRIp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 04:45:26 -0400
Date: Wed, 18 Mar 2009 10:43:34 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [RFC] nl80211: Add MLME primitives to support external SME
Message-ID: <20090318084334.GA10374@jm.kir.nu> (sfid-20090318_094531_178367_DDAE1B29)
References: <20090303144038.GA8435@jm.kir.nu> <1236625410.9658.17.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236625410.9658.17.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 09, 2009 at 08:03:30PM +0100, Johannes Berg wrote:
> On Tue, 2009-03-03 at 16:40 +0200, Jouni Malinen wrote:

> > + * enum nl80211_auth_type - AuthenticationType
> > + * @NL80211_AUTHTYPE_AUTO: Automatic selection (try Open System, Shared Key,
> > + *	Network EAP and accept first one that goes through)

> Do we really need or even want "auto"? Or is that for a future
> "connect()" method that replaces auth/assoc for some hardware designs?

We do not really need it since the same functionality can be implemented
in user space after these patches (i.e., try again if AP denies
authentication with status code indicating unaccepted auth alg). I added
this mainly because we already have support for this in mac80211, but it
would be fine to drop this, too. Both connect() and some firmware
designs that could allow separate auth/assoc may also have use for the
auto setting, but even in those cases, it would probably not be
required.

> > +static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
> > +			   struct cfg80211_assoc_request *req)

> This function or cfg80211 should eventually reject any calls that don't
> refer to a BSS we have already authenticated with, otherwise weird
> things might happen, I think?

Sounds reasonable. MLME-ASSOCIATE.confirm even has a ResultCode for this
(REFUSED_NOT_AUTHENTICATED). The AP would reply to Association Request
with Deauthentication, so it is probably cleaner to reject this
internally regardless of whether it actually causes problems or not in
kernel.

-- 
Jouni Malinen                                            PGP id EFC895FA
