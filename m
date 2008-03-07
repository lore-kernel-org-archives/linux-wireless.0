Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:25070 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755534AbYCGI5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 03:57:44 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] RCPI support in radiotap and in our wireless subsystems
Date: Fri, 7 Mar 2008 17:57:18 +0900
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@mail.ojctech.com,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Simon Barber" <simon@devicescape.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	"Javier Cardona" <javier@cozybit.com>,
	"Sam Leffler" <sam@errno.com>, "Jean Tourrilhes" <jt@hpl.hp.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com> <200803070932.51396.bruno@thinktube.com> <43e72e890803061904h742df37fuaa12977c45e457a@mail.gmail.com>
In-Reply-To: <43e72e890803061904h742df37fuaa12977c45e457a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803071757.19302.bruno@thinktube.com> (sfid-20080307_085750_256814_D6EDF4CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 March 2008 12:04:24 Luis R. Rodriguez wrote:
> >  it could be changed to something like:
> >
> >   * @signal: signal strength in dBm above noise or RCPI according to flag
>
> As it stands I don't think all drivers could populate this field under
> that description. For example, ssi in b43 is set to some magical value
> we have no clue what it means.
>
> We *could* test this stuff and see if it matches RCPI for each device,
> or just try to figure out at least what RSSI is wrt to the observed
> signal through a spectrum analyser (and even jssi is for b43) but I
> wonder how this will change upon hw revisions.
>
> >   * @noise: PHY noise in dBm when receiving this frame
> >   (remove ssi)
>
> Again, the problem in clarifying this also puts a restriction on what
> driver developers may know about their hardware.

yes, but you suggested RCPI which is even more difficult to deliver. well - i 
don't know *any* device which could...

ok. what about 3 hw flags then?

something like:
_SIGNAL_RSSI_UNITLESS
_SIGNAL_RSSI_DBM
_SIGNAL_RCPI

so mac80211 can fill in the right radiotap headers, and drivers can make it 
clear what they support. it's clear that drivers should strive to deliver the 
most exact when they can.

we have the same problem with the rx timestamp. we made a definition and ath5k 
for example can't deliver. but i think a clear definition and a clear note 
where it cannot be delivered is better than no definition at all :)

bruno
