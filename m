Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32646 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbcHPMer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 08:34:47 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Xu, Peng" <pxu@qca.qualcomm.com>
Subject: Re: [PATCH] cfg80211: Add HT and VHT information in start_ap
Date: Tue, 16 Aug 2016 12:34:43 +0000
Message-ID: <20160816123441.GA3678@jouni.qca.qualcomm.com> (sfid-20160816_143450_251454_26813F27)
References: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
 <1471330367.16783.23.camel@sipsolutions.net>
In-Reply-To: <1471330367.16783.23.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2016 at 08:52:47AM +0200, Johannes Berg wrote:
> On Mon, 2016-08-15 at 21:07 +0300, Jouni Malinen wrote:
> > From: Peng Xu <pxu@qca.qualcomm.com>
> > Add HT and VHT information in struct cfg80211_ap_settings when
> > starting ap so that driver does not need to parse IE to obtain
> > the information.
>=20
> > +enum ht_vht_support {
> > +	HT_VHT_DISABLED,
> > +	HT_VHT_ENABLED,
> > +	HT_VHT_NOT_INDICATED
> > +};
>=20
> So if you get HT_VHT_NOT_INDICATED in the driver, don't you *still*
> have to parse the IEs?

Well.. Yes, I guess one would need to do that for some time until
relevant user space is expected to have been updated to support the new
attribute.

> Arguably, cfg80211 could know itself by parsing though, so it could
> already fall back to that, no?
>=20
> But if you do that, you already need the parsing code, so then perhaps
> it would make sense to just always use the parsing in cfg80211? Or
> export a parsing function to use in driver(s)?

I guess that could be considered reasonable approach for the existing
HT and VHT cases and new attributes would obviously be significantly
easier to introduce with new extensions (need to remember to do this for
HE from the beginning..).

The parsing for these HT/VHT enabled/required is a bit strange
combination having to go over three IEs. I'm not sure a parsing function
to do so would be that nice.. The parsing code could indeed be moved to
cfg80211 so that it would not need to be duplicated into each driver
needing this, though.

--=20
Jouni Malinen                                            PGP id EFC895FA=
