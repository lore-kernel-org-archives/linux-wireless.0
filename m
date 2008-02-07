Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:46200 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbYBGD61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 22:58:27 -0500
Date: Wed, 6 Feb 2008 19:58:13 -0800
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Kishore Ramachandran <kishore@winlab.rutgers.edu>,
	Ivan Seskar <Seskar@winlab.rutgers.edu>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Message-ID: <20080207035813.GX1261@jm.kir.nu> (sfid-20080207_035831_927677_BD17314C)
References: <20080118125252.6455.41047.stgit@one> <200801241226.28394.bruno@thinktube.com> <1201193704.3454.137.camel@johannes.berg> <200801251701.59629.bruno@thinktube.com> <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com> <20080206043451.GT1261@jm.kir.nu> <43e72e890802061033k5ca3e83doca28ca43a5c1830b@mail.gmail.com> <20080206201035.GA3229@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080206201035.GA3229@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 03:10:35PM -0500, John W. Linville wrote:

> FWIW, that wouldn't be the first time we (i.e. Linux) chose to do
> something that did not completely comply with a standard.  If it
> interoperates with other equipment and is good for users, I don't
> think picky standard compliance is worthwhile.

Sure, there are cases where this is reasonable.

> Please note that I am not really taking a stand in favor of this ATM,
> only asserting that blind standard compliance is not a good reason
> to NAK it IMHO.

In this case, standard compliance is certainly not the only concern I
have. I'm worried about interoperability with non-mac80211
implementations. If mac80211 were to hardcoded the BSSID for IBSS and
refuse to change it no matter what (i.e., behave against the IEEE 802.11
standard), IBSS would not interoperate with any other implementation if
the other implementation happens to be the creator of the IBSS..

Same issues shows up (but in somewhat less frequent form) in an IBSS
splitting up and re-joining. In order to allow the STAs using other
implementation (no BSSID hacks) to join the IBSS, mac80211 will need to
be prepared to change the BSSID (or use some much more questionable
hacks to make sure it is always the mac80211-STA that wins in the
selection of which BSSID will survive.. ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
