Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:52364 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754700AbcJNN7o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 09:59:44 -0400
Date: Fri, 14 Oct 2016 16:52:07 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org,
        hostap <hostap@lists.infradead.org>,
        Ilan Peer <ilan.peer@intel.com>, yangzy@marvell.com,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>
Subject: Re: [PATCH] cfg80211: add key management offload feature
Message-ID: <20161014135207.GB8928@w1.fi> (sfid-20161014_155948_116568_5C415A86)
References: <1474973796-1873-1-git-send-email-akarwar@marvell.com>
 <1474979775.5141.27.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1474979775.5141.27.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2016 at 02:36:15PM +0200, Johannes Berg wrote:
> > + * @NL80211_ATTR_AUTHORIZED: flag attribute, if set indicates that the
> > + *      connection is authorized.
> > @@ -2267,6 +2270,8 @@ enum nl80211_attrs {
> > +	NL80211_ATTR_AUTHORIZED,
> 
> This already exists, no?
> 
> NL80211_STA_FLAG_AUTHORIZED should be more or less equivalent, if you
> do it per station (or just for the AP in case of managed connection)

It does indeed have a very similar meaning to the proposed
NL80211_ATTR_AUTHORIZED. However, NL80211_STA_FLAG_AUTHORIZED is
something that gets nested in NL80211_ATTR_STA or used with the mask/set
struct in NL80211_ATTR_STA_FLAGS2. I'm not sure either of those would
really be very clean ways to use with a connection/roam event..

> > @@ -3687,6 +3692,9 @@ enum nl80211_key_attributes {
> > +	NL80211_KEY_REPLAY_CTR,
> > +	NL80211_KEY_KCK,
> > +	NL80211_KEY_KEK,
> 
> I don't think we should conflate the (P)MK and *TK concepts in nl80211,
> they're both keys, but they're completely separate in terms of expected
> usage.
> 
> 
> Ilan and I looked at this, considering 4-way-HS offload after 1X
> authentication, and think that the more natural API would be to add all
> the necessary data to the PMKSA cache entry. Thus, a PMKSA cache entry
> for a device that does 4-way-handshake offloading would include the PMK
> (or perhaps MSK?), and for FT it would also including the PMK-R0,
> PMKR0Name (and possibly the MDID, or can it be derived?)

PMKSA caching cases, FT protocol, and 4-way handshake following EAP
might be doable in this manner and that might indeed be the cleanest
approach there. However, there will also be need to cover possibility
for offloading FILS at some point in the future.. For FILS with shared
key, the configuration will actually include ERP keys that are not bound
to any specific Authenticator/AP/BSSID and do not really have a PMKSA
cache entry.. At latest at that point, I'd think we'll end up needing
something else and that something else could be defined already now to
cover all these cases instead of trying to force the current cases to go
through NL80211_CMD_SET_PMKSA.


> However, I'm wondering what exactly the offloads here do. Jouni, could
> you also chime in with the QCA (vendor command) design?

The QCA vendor command/event allows multiple different authentication
cases to be offloaded to the driver (well, firmware) and depending on
the driver/firmware version, there could be a bit different behavior
based on whether the particular exchange was offloaded. In other words,
there is automatic fallback to wpa_supplicant completing the exchange if
the driver does not report that it was completed.

> In particular, with key management offloaded, it's not clear to me what
> exactly the roles of the device and host are here. I'm considering that
> the device would handle the 4-way and 2-way handshakes, but then you
> wouldn't need the KEK/KCK/ReplayCounter in the host, so there wouldn't
> be much point in giving them to it.
> But if the device doesn't do that, what exactly *does* it do?

One of the key uses is to allow the Wi-Fi firmware to complete roaming
(say, 4-way handshake based on existing PMKSA) when the host processor
is not awake (i.e., wpa_supplicant is not running at all). However, this
does not mean that we would necessarily offload all EAPOL-Key
processing. GTK rekeying and the initial 4-way handshake for the first
connection to an ESS might be performed by wpa_supplicant especially in
cases where the host is awake anyway. That's why those PTK-related
values need to be kept in sync between the driver/firmware and host
(wpa_supplicant).

-- 
Jouni Malinen                                            PGP id EFC895FA
