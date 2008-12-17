Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36549 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbYLQMGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 07:06:13 -0500
Date: Wed, 17 Dec 2008 14:05:59 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Key cache allocation for AP mode
Message-ID: <20081217120559.GB19453@jm.kir.nu> (sfid-20081217_130616_477506_97D32422)
References: <20081217113217.GB18060@jm.kir.nu> <1229513411.4566.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229513411.4566.0.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 12:30:11PM +0100, Johannes Berg wrote:
> On Wed, 2008-12-17 at 13:32 +0200, Jouni Malinen wrote:
> > +		if (vif->type != NL80211_IFTYPE_AP) {
> > +			/* Only keyidx 0 should be used with unicast key, but
> > +			 * allow this for client mode for now. */
> > +			idx = key->keyidx;
> 
> Hey, good point, should we make the check in mac80211 stricter as well?
> I know we accept non-zero pairwise key idx for some broken pairwise WEP
> implementations, but that's only relevant for STA as you note.

Doing that in non-Managed modes in mac80211 sounds reasonable. I don't
see any point in making it easier for people to make APs that do such a
silly thing with WEP ;-). I did not look at more details here from the
mac80211 view point, I just knew it would break the key cache changes I
was working on for ath9k.

-- 
Jouni Malinen                                            PGP id EFC895FA
