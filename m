Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49351 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbbBXA0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 19:26:08 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21739.50662.902775.901924@gargle.gargle.HOWL> (sfid-20150224_012612_884194_A02F80C0)
Date: Tue, 24 Feb 2015 05:59:26 +0530
To: Jouni Malinen <j@w1.fi>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: AR9462 problems connecting again..
In-Reply-To: <20150223224305.GA30228@w1.fi>
References: <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<20150223171700.GA29730@w1.fi>
	<CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
	<20150223213050.GA23232@w1.fi>
	<CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
	<CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
	<20150223224305.GA30228@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> Even I think that this goes a bit too far especially on 2.4 GHz band,
> but I would actually consider limiting EAPOL frames to using non-HT/VHT
> (e.g., 6 Mbps OFDM at least for EAPOL-Key frames) to avoid some
> interoperability issues. I would say that the current minstrel_ht
> behavior is somewhat excessive for EAPOL-Key frames in the other
> direction. Using MCS 14 with fallback to something like MCS 5 for the
> second Data frame after an association can certainly fail.
> 
> Number of Linux drivers do already limit EAPOL frame TX rate, so this
> specific item is mainly applicable only to driver that use minstrel from
> mac80211 (e.g., ath9k). Though, that IEEE80211_TX_CTL_USE_MINRATE would
> likely affect most mac80211 drivers.

We had this in the ath9k RC, where EAPOL frames were sent out at min-rate
on the VO queue. I think instead of re-introducing it in the driver,
having it in minstrel is cleaner.

Sujith
