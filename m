Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44757 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbcJTMxt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 08:53:49 -0400
Message-ID: <1476968023.4929.30.camel@sipsolutions.net> (sfid-20161020_145353_587015_3C41D129)
Subject: Re: [PATCH] cfg80211: add key management offload feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org,
        hostap <hostap@lists.infradead.org>,
        Ilan Peer <ilan.peer@intel.com>, yangzy@marvell.com,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>
Date: Thu, 20 Oct 2016 14:53:43 +0200
In-Reply-To: <20161014135207.GB8928@w1.fi>
References: <1474973796-1873-1-git-send-email-akarwar@marvell.com>
         <1474979775.5141.27.camel@sipsolutions.net> <20161014135207.GB8928@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-14 at 16:52 +0300, Jouni Malinen wrote:
> On Tue, Sep 27, 2016 at 02:36:15PM +0200, Johannes Berg wrote:
> > 
> > > 
> > > + * @NL80211_ATTR_AUTHORIZED: flag attribute, if set indicates
> > > that the
> > > + *      connection is authorized.
> > > @@ -2267,6 +2270,8 @@ enum nl80211_attrs {
> > > +	NL80211_ATTR_AUTHORIZED,
> > 
> > This already exists, no?
> > 
> > NL80211_STA_FLAG_AUTHORIZED should be more or less equivalent, if
> > you do it per station (or just for the AP in case of managed
> > connection)
> 
> It does indeed have a very similar meaning to the proposed
> NL80211_ATTR_AUTHORIZED. However, NL80211_STA_FLAG_AUTHORIZED is
> something that gets nested in NL80211_ATTR_STA or used with the
> mask/set struct in NL80211_ATTR_STA_FLAGS2. I'm not sure either of
> those would really be very clean ways to use with a connection/roam
> event..

Oh, right, this is used in the event, not for control...

I guess that makes sense then, although it should be a flag attribute
instead of a u8?

We could still put a nested NL80211_ATTR_STA, but I agree that seems
awkward.

> PMKSA caching cases, FT protocol, and 4-way handshake following EAP
> might be doable in this manner and that might indeed be the cleanest
> approach there. 

Ok

> However, there will also be need to cover possibility
> for offloading FILS at some point in the future.. 

Yeah, I hadn't considered FILS.

> For FILS with shared key, the configuration will actually include ERP
> keys that are not bound to any specific Authenticator/AP/BSSID and do
> not really have a PMKSA cache entry.. At latest at that point, I'd
> think we'll end up needing something else and that something else
> could be defined already now to cover all these cases instead of
> trying to force the current cases to go through
> NL80211_CMD_SET_PMKSA.

Could be done, I guess. But don't we then have to be careful to
actually bind the non-FILS keys to the right Authenticator/AP/BSSID,
and then we have to invent a way to bind it? Does that make sense?

> > In particular, with key management offloaded, it's not clear to me
> > what exactly the roles of the device and host are here. I'm
> > considering that the device would handle the 4-way and 2-way
> > handshakes, but then you wouldn't need the KEK/KCK/ReplayCounter in
> > the host, so there wouldn't be much point in giving them to it.
> > But if the device doesn't do that, what exactly *does* it do?
> 
> One of the key uses is to allow the Wi-Fi firmware to complete
> roaming (say, 4-way handshake based on existing PMKSA) when the host
> processor is not awake (i.e., wpa_supplicant is not running at all). 

Ah. So this might not be used when the processor *is* awake? That's a
key point I was missing, perhaps, since we're building something where
it's simply always done by the device.

Why would you want to do it in the processor when you have the ability
to do it in the firmware?

> However, this does not mean that we would necessarily offload all
> EAPOL-Key processing. GTK rekeying and the initial 4-way handshake
> for the first connection to an ESS might be performed by
> wpa_supplicant especially in cases where the host is awake anyway.
> That's why those PTK-related values need to be kept in sync between
> the driver/firmware and host (wpa_supplicant).

Interesting, ok. Whatever the reason, I guess we have to support it
being done that way.

I guess we'll have to hash out the exact details.

I think we can publish a proposal soon that uses the PMKSA cache, but
lacks all the event data since we never see EAPOL-key messages on the
host in that model.

This model here with the temporal key etc. stuff is clearly unworkable.

I'm not sure I've made up my mind on introducing a new mechanism that
covers FILS vs. PMKSA (and then later an only-FILS-style mechanism) -
that's the issue with binding to a BSSID above.

johannes
