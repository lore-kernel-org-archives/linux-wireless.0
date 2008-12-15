Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40383 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYLOTpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 14:45:16 -0500
Date: Mon, 15 Dec 2008 14:35:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Improve wireless statistics for RTL8187
Message-ID: <20081215193549.GD3519@tuxdriver.com> (sfid-20081215_204520_117358_2FCF9DD5)
References: <27385.37285.qm@web23104.mail.ird.yahoo.com> <49374C8E.6010500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <49374C8E.6010500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 03, 2008 at 09:20:46PM -0600, Larry Finger wrote:
> Hin-Tak Leung wrote:
> > --- On Thu, 4/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote=
:
> >=20
> >> The current wireless statistics for the RTL8187 poorly
> >> indicate the signal
> >> strength and quality. With testing, I found that the AGC
> >> value is inversely
> >> correlated with the strength as in the RTL8187B. By
> >> implementing a similar
> >> calculation, much more code becomes common to the two
> >> devices.
> >>
> >> Signed-off-by: Larry Finger
> >> <Larry.Finger@lwfinger.net>
> >> Tested by: Mart=EDn Ernesto Barreyro
> >> <barreyromartin@gmail.com>
> >> ---
> > Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> >=20
> > Acually eveything to do with "quality" can be moved out of the if/t=
hen.
> >=20
> > I mean these 3 lines:
> >=20
> > +		if (quality > 100)
> > +			quality =3D 100;
> > +		....
> > +		rx_status.qual =3D quality;
> >=20
> > You have removed "rx_status.qual =3D quality;" from the "then" part=
, but didn't put it back in the common portion afterwards?
> >=20
> > Also, what happened to "dev->max_signal =3D 65;" at the end?
>=20
> Thanks for the comments. I'll fix up the code and resubmit.
>=20
> The dev->max_signal is only needed if the IEEE80211_HW_SIGNAL_UNSPEC =
flag is
> used. Once we switch to IEEE80211_HW_SIGNAL_DBM, then the maximum is =
known.

I'm dropping this patch from my mailbox.  Is a new version of this
still coming?

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
