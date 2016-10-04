Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43010 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753237AbcJDQPj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 12:15:39 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Xu, Peng" <pxu@qca.qualcomm.com>
Subject: Re: [PATCH] cfg80211: Add HT and VHT information in start_ap
Date: Tue, 4 Oct 2016 16:15:20 +0000
Message-ID: <20161004161518.GD5430@jouni.qca.qualcomm.com> (sfid-20161004_181543_213056_D77D93CF)
References: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
 <1471330367.16783.23.camel@sipsolutions.net>
 <20160816123441.GA3678@jouni.qca.qualcomm.com>
 <1472198948.390.20.camel@sipsolutions.net>
 <1473674982.29016.10.camel@sipsolutions.net>
 <20161003211523.GA6585@jouni.qca.qualcomm.com>
 <1475587551.5324.57.camel@sipsolutions.net>
In-Reply-To: <1475587551.5324.57.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 04, 2016 at 03:25:51PM +0200, Johannes Berg wrote:
> > ath6kl:
> > Use cfg80211_get_chandef_type(&info->chandef) !=3D NL80211_CHAN_NO_HT
> > to determine whether HT is enabled. No VHT support. HT-required case
> > not covered. No parsing of HT/VHT IEs used.
>=20
> Hmm. Wouldn't the supported rates IE still advertise the cookie for HT
> only, to make sure HT-required was done?

I'm not completely sure how the driver/firmware behaves for this. There
is a reference to info->beacon.head, but that code looks like dead code
that does nothing as far as configuring the firmware with the supported
rates elements from user space. As such, I'd expect the firmware to
build (Ext)Supp Rates element from scratch and I'd assume ath6kl does
not currently support HT-required signaling. I'm not sure whether the
current firmware would even allow such configuration.

> [snip other drivers]

By the way, I did not find any clear example that would be either using
(Extended) Supported Rates element from start_ap() as-is or parsing it
for the BSS membership selectors in any of the in-tree drivers. In other
words, the HT/VHT required configuration may not really work properly
with non-mac80211 cases.


PS.

And even if the driver were to simply copy the IEs with the BSS
membership selectors, this would only work with stations that implement
this part correctly, i.e., the AP would not necessarily have any means
for rejecting the association if a non-HT/VHT station were to try to
associate.. With mac80211-drivers, this happens in hostapd.

--=20
Jouni Malinen                                            PGP id EFC895FA=
