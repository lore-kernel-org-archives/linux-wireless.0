Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48212 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0BAUph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 15:45:37 -0500
Date: Mon, 1 Feb 2010 15:36:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix access to freed data on unload
Message-ID: <20100201203637.GE4952@tuxdriver.com>
References: <1264905444.10146.9.camel@mj> <43e72e891002011011h4714ecddrb9421a877832bffd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e891002011011h4714ecddrb9421a877832bffd@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 01, 2010 at 10:11:54AM -0800, Luis R. Rodriguez wrote:
> On Sat, Jan 30, 2010 at 6:37 PM, Pavel Roskin <proski@gnu.org> wrote:
> > Calling ath_bus_cleanup() after ieee80211_free_hw() resulted in acc=
ess
> > to common->bus_ops, which is already freed as part of the device da=
ta.
> >
> > Remove the cleanup field in struct ath_bus_ops, as it was never use=
d
> > properly. =A0Remove ath_bus_cleanup(). =A0Merge cleanup functions i=
n place
> > of the ath_bus_cleanup() calls. =A0Take care not to use any device =
data
> > after ieee80211_free_hw().
> >
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> > ---
> >
> > The bug was causing a hang on a kernel with most debugging options
> > enabled. =A0I think the fix is important and simple enough for stab=
le
> > kernels. =A0I wish I could make the patch smaller, but I didn't wan=
t to
> > leave unused and dangerous fields and functions.
> >
> > ath9k was tested on the PCI bus. =A0ath9k on AHB was compile tested=
=2E
> > ath5k and ar9170 use struct ath_bus_ops, but don't use the cleanup
> > field, so they are not affected.
>=20
> Thanks, can you please resend with a Cc: stable@kernel.org on the com=
mit log?

Doesn't look to me like the patch even applies to 2.6.33...?

--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
