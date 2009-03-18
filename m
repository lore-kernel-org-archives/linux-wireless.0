Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:18011 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbZCRNca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 09:32:30 -0400
Received: by nf-out-0910.google.com with SMTP id d21so9775nfb.21
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 06:32:27 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] Fix SLAB corruption during rmmod
Date: Wed, 18 Mar 2009 14:32:24 +0100
Cc: linux-wireless@vger.kernel.org,
	Arnaud Patard <apatard@mandriva.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Dan Williams <dcbw@redhat.com>
References: <200903161925.41102.IvDoorn@gmail.com> <200903172256.35485.IvDoorn@gmail.com> <20090318130207.GA3527@tuxdriver.com>
In-Reply-To: <20090318130207.GA3527@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903181432.25098.IvDoorn@gmail.com> (sfid-20090318_143251_296689_296F0DC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 18 March 2009, John W. Linville wrote:
> On Tue, Mar 17, 2009 at 10:56:35PM +0100, Ivo van Doorn wrote:
> > On Tuesday 17 March 2009, John W. Linville wrote:
> > > On Mon, Mar 16, 2009 at 08:24:27PM +0100, Ivo van Doorn wrote:
> > > > At rmmod stage, the code path is the following one :
> > > >=20
> > > > rt2x00lib_remove_dev
> > > > =A0 -> =A0rt2x00lib_uninitialize()
> > > > =A0 =A0 =A0 =A0 -> rt2x00rfkill_unregister()
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_unregister()
> > > > =A0 =A0 =A0 =A0 -> rt2x00rfkill_free()
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_free()
> > > >=20
> > > > The problem is that rfkill_free should not be called after rfki=
ll_register
> > > > otherwise put_device(&rfkill->dev) will be called 2 times. This=
 patch
> > > > fixes this by only calling rt2x00rfkill_free() when rt2x00rfkil=
l_register()
> > > > hasn't been called or has failed.
> > > >=20
> > > > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > > > Tested-by: Arnaud Patard <apatard@mandriva.com>
> > > > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > > >=20
> > > > ---
> > > > John, this patch is for 2.6.29 and only 2.6.29 since rfkill sup=
port itself
> > > > was removed from later versions (replaced by input_polldev).
> > > > The patch is quite big to be merged in a late state of the rele=
ase cycle,
> > > > but since the SLAB corruption is a serious problem, I hope this=
 can get in regardless.
> > >=20
> > > Could you send me a version of this that applies on top of
> > > wireless-testing?
> >=20
> > Actually no, the code isn't present at all in wireless-testing.
> > As I said, after 2.6.29 the entire rfkill structure is removed from=
 rt2x00
> > and replaced by input_polldev.
>=20
> I guess I misunderstood.  So just to be clear, no remnant or shadow
> of this patch should live-on to 2.6.30?

Exactly. :)

> It's just that the merge conflicts created by this patch were awful.
> With 2.6.29's release presumably close, maybe this is a candidate
> for the stable tree?

That would be fine as well. :)
Should I resend it to -stable when 2.6.29 final is out?

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
