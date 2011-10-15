Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:37361 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab1JOIuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 04:50:24 -0400
Date: Sat, 15 Oct 2011 11:50:02 +0300
From: Jouni Malinen <j@w1.fi>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: handle HT PHY BSS membership selector value
 correctly
Message-ID: <20111015085002.GA2642@jm.kir.nu> (sfid-20111015_105031_835359_4A3BB201)
References: <201110132108.50019.chunkeey@googlemail.com>
 <20111013224532.GA1959@jm.kir.nu>
 <201110140942.37085.chunkeey@googlemail.com>
 <201110141012.21010.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201110141012.21010.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 14, 2011 at 10:12:20AM +0200, Christian Lamparter wrote:
> > On Friday, October 14, 2011 12:45:32 AM Jouni Malinen wrote:
> > > Well, it can be used to try to make legacy stations not attempt
> > > connection, but no guarantees on them actually checking whether they
> > > support all the "basic rates".. For example, where is mac80211 (or
> > > wpa_supplicant) doing that check? ;-)
> > 
> Actually, you have already implemented the check in hostapd :)

That's for AP mode which does not really use the BSS membership selector
in any way. The point of this mechanism is that it is supposed to allow
legacy stations to not even try to associate with the AP that requires
some new functionality that the station is not even aware of. For this
to have any real benefit, the station would need verify whether they
support all "basic rates" (i.e., these would look like basic rates for
them, but BSS membership selectors for any station that is aware of the
new functionality). This would allow mandating this type of new
requirement on BSS by BSS basis in an ESS without causing problems to
the legacy stations.

> So, what's the exact difference between then BasicRate and a MembershipRate
> in this context then? Is a rate called "basic rate" when it's one of the
> legacy e.g.: 6, 12, 24 Mbit rates [And likewise: is a rate called a MembershipRate
> when only in the magic 127 HT PHY case?] 

More or less (though, I would not call the membership selector a
"rate"). This is not really that clearly described, but I would indeed
split the values in Supported Rates element (and Extended Supported
Rates elements) in that way. This obviously depends on knowing
the full list of rates or full list of membership selectors (which may
be the easier thing to know in full).

The exact definition of what the value is does not really matter for a
legacy station since the rule for them is that they would need to
support any rate (& 0x7f) that has the 0x80 bit set.

> Also, there's 22mbit 8-PSK PBCC [I think mwl8k supports it and some TI
> stuff could support it as well]. The check is questionable, but fixing
> it may no be trivial either. [Anyway, it's a bit outside the scope and
> requires another patch]

Agreed.

-- 
Jouni Malinen                                            PGP id EFC895FA
