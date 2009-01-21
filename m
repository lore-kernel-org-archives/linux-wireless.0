Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42660 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZAUQas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 11:30:48 -0500
Date: Wed, 21 Jan 2009 11:24:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Pavel Roskin <proski@gnu.org>, orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC
	in kmalloc in orinoco_ioctl_set_genie
Message-ID: <20090121162456.GA9043@tuxdriver.com> (sfid-20090121_173053_274826_F20F9796)
References: <200901171822.45476.arvidjaar@mail.ru> <1232334964.5609.37.camel@dv> <200901202026.49518.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200901202026.49518.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 08:26:46PM +0300, Andrey Borzenkov wrote:
> On 19 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 06:16:04 Pavel Roskin=
 wrote:
> > On Sat, 2009-01-17 at 18:22 +0300, Andrey Borzenkov wrote:
> > > Subject: [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC in kmalloc =
in
> > > orinoco_ioctl_set_genie
> > > From: Andrey Borzenkov <arvidjaar@mail.ru>
> > >
> > > kmalloc is called with interrupt disabled and may not sleep. This
> > > fixes this BUG:
> >
> > Please move kmalloc before the lock.  I don't see any reason to
> > allocate memory with irqs disabled.  The contention happens later,
> > when priv->wpa_ie is freed and assigned a new value.
>=20
> OK.
>=20
> This looks like -stable candidate.

Just FYI, the best way to indicate is to add a line like this after
your Signed-off-by:

Cc: stable@kernel.org

I'll take care of this one.

Thanks,

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
