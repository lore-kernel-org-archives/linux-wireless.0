Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29091 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbYJXSTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:19:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 11:19:13 -0700
Date: Fri, 24 Oct 2008 04:19:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 4/5] crda: Updated regulatory information for France
	(FR)
Message-ID: <20081024111907.GC5951@tesla> (sfid-20081024_201917_627177_0637D485)
References: <cover.1223583376.git.benoit.papillault@free.fr> <48FE399E.6050907@free.fr> <20081022150323.GO6190@tesla> <49000C21.2010808@free.fr> <20081023110746.GA5979@tesla> <49018B87.8070908@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <49018B87.8070908@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 01:47:03AM -0700, Benoit PAPILLAULT wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Luis R. Rodriguez a =E9crit :
> > On Wed, Oct 22, 2008 at 10:31:13PM -0700, Benoit PAPILLAULT wrote:
> >>> 2483.5 - 2454 =3D 29.5 so 29.5 should be the max bandwidth.
> >> Not exactly. The maximum power in this band depends on whether we =
are
> >> indoor or outdoor. If we are indoor, we are allowed to have 20dBm =
in the
> >> whole 2400 - 2454 MHz band and can still use 40MHz bandwidth. Mayb=
e I
> >> should describe that different?
> >>
> >>         (2412 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
> >>         (2412 - 2454 @ 40), (N/A, 20), NO-INDOOR
> >>         (2454 - 2483.5 @ 40) (N/A, 10), NO-INDOOR
> >>
> >> In fact, this depends on the indoor/outdoor flags issue which can =
be
> >> resolved later.
> >
> > But I wasn't speaking about power, I was speaking about channel
> > bandwidth. You cannot fit a 40 MHz channel into the freq range
> > 2483.5 - 2454.
>=20
> The whole band is still 2412-2483.5MHz in both cases (indoor/outdoor)=
,
> this is just that different TX power rules apply for frequencies belo=
w
> 2454 MHz and above when used outdoor.
>=20
> To me, it's valid to have a 40MHz channel centered at 2462 MHz coveri=
ng
> the range [2442, 2482] MHz. When used outdoor, it will be limited to =
10
> dBm on the whole range.

This is an interesting case... so right now we apply a reg rule to
a channel upon register or when a regulatory domain changes. We do
this in handle_channel(). This calls freq_reg_info() and one parameter
we can pass there is the max_bandwidth we know we want or 0 if we have
no requirement. We use 0 on max_bandwidth right now as we haven't added
code for checking max bandwidth yet in mac80211, I think we can add
desired tx power here as well and it'll then be able to pick up the
correct rule. However this does require adding code to reg.c. and
maybe mac80211. We'll have to keep this in mind and add it, but
the reg rule for 2454 - 2483.5 should still not have 40 MHz for max
bandwidth as only 29.5 MHz fits in it.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
