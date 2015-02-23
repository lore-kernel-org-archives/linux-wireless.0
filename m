Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57461 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbbBWWnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 17:43:08 -0500
Date: Tue, 24 Feb 2015 00:43:05 +0200
From: Jouni Malinen <j@w1.fi>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: AR9462 problems connecting again..
Message-ID: <20150223224305.GA30228@w1.fi> (sfid-20150223_234312_503484_74421E52)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2015 at 02:22:32PM -0800, Adrian Chadd wrote:
> On 23 February 2015 at 13:53, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > So the theory that the driver starts at too high a transmit rate, and
> > then does not handle failures well, might be true. Of course, "not
> > handle failures well" is something of an understatement.

> Hm, can we just hack mac80211/ath9k to set /all/ EAPOL frames to the
> lowest negotiated basic rate and test? That way we don't have to worry
> about things resetting fixed rates or whatnot.

This did not get exactly supportive response when this was proposed last
time (Sep 2013). Anyway, for a quick test, this can be done with the
following one-liner:

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c314c59..b45038f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -566,6 +566,7 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
 		if (tx->sdata->control_port_no_encrypt)
 			info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 		info->control.flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+		info->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 	}
 
 	return TX_CONTINUE;


Even I think that this goes a bit too far especially on 2.4 GHz band,
but I would actually consider limiting EAPOL frames to using non-HT/VHT
(e.g., 6 Mbps OFDM at least for EAPOL-Key frames) to avoid some
interoperability issues. I would say that the current minstrel_ht
behavior is somewhat excessive for EAPOL-Key frames in the other
direction. Using MCS 14 with fallback to something like MCS 5 for the
second Data frame after an association can certainly fail.

Number of Linux drivers do already limit EAPOL frame TX rate, so this
specific item is mainly applicable only to driver that use minstrel from
mac80211 (e.g., ath9k). Though, that IEEE80211_TX_CTL_USE_MINRATE would
likely affect most mac80211 drivers.

-- 
Jouni Malinen                                            PGP id EFC895FA
