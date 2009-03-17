Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:8308 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZCQV4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:56:40 -0400
Received: by ey-out-2122.google.com with SMTP id 4so58846eyf.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 14:56:37 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] Fix SLAB corruption during rmmod
Date: Tue, 17 Mar 2009 22:56:35 +0100
Cc: linux-wireless@vger.kernel.org,
	Arnaud Patard <apatard@mandriva.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Dan Williams <dcbw@redhat.com>
References: <200903161925.41102.IvDoorn@gmail.com> <200903162024.27870.IvDoorn@gmail.com> <20090317211345.GI6737@tuxdriver.com>
In-Reply-To: <20090317211345.GI6737@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903172256.35485.IvDoorn@gmail.com> (sfid-20090317_225643_436656_769A4CEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 March 2009, John W. Linville wrote:
> On Mon, Mar 16, 2009 at 08:24:27PM +0100, Ivo van Doorn wrote:
> > At rmmod stage, the code path is the following one :
> >=20
> > rt2x00lib_remove_dev
> > =A0 -> =A0rt2x00lib_uninitialize()
> > =A0 =A0 =A0 =A0 -> rt2x00rfkill_unregister()
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_unregister()
> > =A0 =A0 =A0 =A0 -> rt2x00rfkill_free()
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_free()
> >=20
> > The problem is that rfkill_free should not be called after rfkill_r=
egister
> > otherwise put_device(&rfkill->dev) will be called 2 times. This pat=
ch
> > fixes this by only calling rt2x00rfkill_free() when rt2x00rfkill_re=
gister()
> > hasn't been called or has failed.
> >=20
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > Tested-by: Arnaud Patard <apatard@mandriva.com>
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> >=20
> > ---
> > John, this patch is for 2.6.29 and only 2.6.29 since rfkill support=
 itself
> > was removed from later versions (replaced by input_polldev).
> > The patch is quite big to be merged in a late state of the release =
cycle,
> > but since the SLAB corruption is a serious problem, I hope this can=
 get in regardless.
>=20
> Could you send me a version of this that applies on top of
> wireless-testing?

Actually no, the code isn't present at all in wireless-testing.
As I said, after 2.6.29 the entire rfkill structure is removed from rt2=
x00
and replaced by input_polldev.

> Also, is there a bug report somewhere that describes this issue
> this addresses?

I got the report on the rt2400-devel mailinglist, GertJan provided the =
patch
through that mailinglist as well, here is the reference to the mails fr=
om the archive:

https://sourceforge.net/mailarchive/forum.php?thread_name=3Dm3iqmwjaor.=
fsf%40anduin.mandriva.com&forum_name=3Drt2400-devel

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
