Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56908 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968706AbdD1VCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 17:02:42 -0400
Message-ID: <1493413355.2431.19.camel@sipsolutions.net> (sfid-20170428_230403_683687_67ED3C05)
Subject: Re: [PATCH 5/9] cfg80211/nl80211: add authorized flag to roaming
 event
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Apr 2017 23:02:35 +0200
In-Reply-To: <30808bad-1f15-20bd-9bfe-0c10ab8555cd@broadcom.com> (sfid-20170426_120601_633858_AC9F0B99)
References: <20170426075854.13546-1-luca@coelho.fi>
         <20170426075854.13546-6-luca@coelho.fi>
         <30808bad-1f15-20bd-9bfe-0c10ab8555cd@broadcom.com>
         (sfid-20170426_120601_633858_AC9F0B99)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-26 at 12:05 +0200, Arend van Spriel wrote:
> 
> > the mobility domain does not require new 802.1X authentication, but
> > roaming to another mobility domain does.
> 
> Not sure about the terminology here. Is "mobility domain" the same
> as  "ESS" which stands for extended service set as definced in
> 802.11  standard. If so, I would prefer use of that term here.

No. "Mobility domain" was defined in 802.11r, it's unrelated to ESS.

> > + * @authorized: true if the 802.1X authentication was done by the
> > driver or is
> > + *	not needed (e.g., when Fast Transition protocol was
> > used), false
> > + *	otherwise. Ignored for networks that don't use 802.1X
> > authentication.
> 
> It is not ignored in this patch so it is expected user-space
> behavior you are describing, which is not really needed here in
> cfg80211 driver api.

Still kinda makes sense though to give that hint to the driver authors,
don't you think? Though it should be pretty clear ...

> >    *	well to remain backwards compatible.
> >    * @NL80211_CMD_ROAM: request that the card roam (currently not
> > implemented),
> 
> Do we want to keep this comment about the request scenario. Is it
> likely implemented soon/ever?

Heh, good question. Probably not, but it's kinda an unrelated cleanup,
no?

> >    *	sent as an event when the card/driver roamed by itself.
> > + *	When used as an event, and the driver roamed in a
> > network that requires
> > + *	802.1X authentication,
> > %NL80211_ATTR_CONNECTION_AUTHORIZED should be set
> > + *	if the 802.1X authentication was done by the driver or
> > if roaming was
> > + *	done using Fast Transition protocol (in which case
> > 802.1X authentication
> > + *	is not needed). If %NL80211_ATTR_CONNECTION_AUTHORIZED
> > is not set,
> > + *	user space is responsible for the 802.1X authentication.
> 
> Would you consider using NL80211_ATTR_PORT_AUTHORIZED instead
> referring to the 802.1X port entities.

I guess that makes sense, yeah.

johannes
