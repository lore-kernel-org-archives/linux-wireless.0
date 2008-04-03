Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:35165 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758021AbYDCBz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 21:55:56 -0400
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Date: Thu, 3 Apr 2008 10:55:43 +0900
Cc: jt@hpl.hp.com, ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
	"Sanjit Kaul" <sanjitkaul@gmail.com>
References: <20080326123042.11233.80949.stgit@localhost> <20080327001909.GA17555@bougret.hpl.hp.com> <43e72e890804021619k4e8fea71i152c5dafe010ddfc@mail.gmail.com>
In-Reply-To: <43e72e890804021619k4e8fea71i152c5dafe010ddfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200804031055.43707.bruno@thinktube.com> (sfid-20080403_025601_410090_AAB27F58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 April 2008 08:19:07 Luis R. Rodriguez wrote:
> >  > Jean, if range->max_qual.level is set to -110 does this mean sig=
nal
> >  > level can be set only from -110 up to 0 ? Is max_qual.level supp=
osed
> >  > to be the weakest signal possibly detected?
> >
> >         Yes. This is what make most sense.
>
> How so? I think I must still be seriously misunderstanding something
> then. If the weakest signal possibly detected is -110 dbm it does not
> imply the strongest signal will be 0 dbm. On the contrary, I expect t=
o
> be able to receive frames with positive dbm values. For example, if I
> hook up a card's antenna which is transmitting at 20dbm to another
> card's antenna directly with cables with 10 dbm attenuator in the
> middle I expect to see 10 dbm on the reception side. Therefore
> shouldn't the max be close the max allowed, or at least expected,
> EIRP?

from a paper, from Joshua Bardwell, also available at:
http://madwifi.org/attachment/wiki/UserDocs/RSSI/you_believe_D100201.pd=
f

"Bear in mind that, realistically, stations will nearly always receive =
signals=20
below 1 mW, unless they are very close (within a few feet) of the acces=
s=20
point. Therefore, the power levels below 1 mW are critical to the opera=
tion=20
of an 802.11 chipset."
=2E..
"Realistically, 1 mW is about the maximum power that a station is likel=
y to=20
receive, and the station would have to be within inches of a powerful A=
P to=20
receive even that much! (That might surprise you, but remember that 802=
=2E11=20
NICs can receive signals down to about 10-7 to 10-9 mW, so a =E2=80=9Cw=
eak=E2=80=9D 1 mW=20
signal is actually millions of times stronger than the weakest signal t=
he=20
card could discern.)"
=2E..
"Consequently, the RSSI ranges used by the 802.11 chipset manufacturers=
 don=E2=80=99t=20
measure at all above 1 mW. The maximum RSSI value for all 802.11 chipse=
ts and=20
NICs represents a power level that is less than 1 mW. Everything betwee=
n 1 mW=20
and 100 mW is simply considered =E2=80=9C100 %=E2=80=9D RSSI."

bruno
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
