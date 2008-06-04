Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYFDONh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 10:13:37 -0400
Subject: Re: mac80211 ad-hoc mode problems
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1212570001.14371.16.camel@johannes.berg>
References: <1212543664.4237.14.camel@localhost.localdomain>
	 (sfid-20080604_034126_005983_906C2124)  <1212570001.14371.16.camel@johannes.berg>
Content-Type: text/plain; charset=utf8
Date: Wed, 04 Jun 2008 10:13:19 -0400
Message-Id: <1212588799.13676.11.camel@localhost.localdomain> (sfid-20080604_161414_157171_FB116E76)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 11:00 +0200, Johannes Berg wrote:
> On Tue, 2008-06-03 at 21:41 -0400, Dan Williams wrote:
> > Hi,
> >=20
> > While adding adhoc shared network support to NM, I ran into a few
> > mac80211 problems.
> >=20
> > 1) doesn't send SIOCGIWAP event on successful adhoc activation (pat=
ch
> > forthcoming)
>=20
> Thanks.
>=20
> > 2) takes a _really_ long time to create an adhoc network.  This is
> > controlled by IEEE80211_IBSS_JOIN_TIMEOUT.  Why is that 20 seconds?=
  The
> > problem here is that wpa_supplicant has an association timer shorte=
r
> > than =EF=BB=BFIEEE80211_IBSS_JOIN_TIMEOUT and will re-try the conne=
ction,
> > causing mac80211 to reset ifsta->ibss_join_req.  FullMAC drivers wi=
ll
> > simply look in their scan list (and optionally perform one scan) an=
d if
> > the IBSS isn't found, create it.  I'd really like to
> > take =EF=BB=BFIEEE80211_IBSS_JOIN_TIMEOUT down to 5 or 7 seconds.  =
This is only
> > the initial IBSS creation, IBSS merging will still be in effect.  I
> > simply thing 20 seconds is really too long here.
>=20
> Yeah, I don't know why it is that long. Jouni, do you remember maybe?
> I'm ok with reducing it.
>=20
> > 3) doesn't send NULL SIOCGIWAP disassoc events when the device goes=
 down
> > or the module is removed.  Where's the best place to put the event =
on
> > module remove?
>=20
> Huh? Why does that matter, the network interface is going away so...?

I guess it doesn't, but traditionally drivers have sent a disassoc even=
t
when they go down/away.

> > 4) Is the association expected to survive a up->down->up sequence? =
 If
> > not, then we should be sending NULL SIOCGIWAP event whenever dev_cl=
ose()
> > gets called.
>=20
> No, it's not, yes, we probably should send that event somewhere. Is i=
t
> ok to send the event while not associated?

Yeah, there's no ordering or pairing guarantee for SIOCGIWAP events
since there isn't an association transaction model with WEXT.

> > 5) mac80211 requires the device to be down when changing modes.  Th=
at's
> > fine; but requires a patch to wpa_supplicant to handle this.  This =
would
> > cause failures when switching AP that were different modes from NM.
> > See:
> >=20
> > http://lists.shmoo.com/pipermail/hostap/2008-June/017894.html
>=20
> Don't understand. How can you switch to an IBSS AP? :)

Sorry, when switching from BSS -> IBSS, like picking an IBSS from the
NetworkManager menu while you're connected to an AP.  Or, creating a ne=
w
IBSS while connected.

> It's probably fairly easy to remove this restriction because they all
> use ieee80211_if_sta internally (sta, ibss, mesh) but since I don't c=
are
> too much about IBSS and see mesh as being quite different, I have no
> motivation to try (and test) this.

I think it's fine to leave it as-is.  At least prism54 required the
interface to be !IFF_UP while changing modes, and I think madwifi has
required this too at some point.  This can be handled in the supplicant=
,
Jouni and I have already worked out what should be done and I'm going t=
o
update the linked patch.

Thanks,
Dan

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
