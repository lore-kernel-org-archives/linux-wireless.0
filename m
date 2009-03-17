Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41021 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZCQVPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:15:50 -0400
Date: Tue, 17 Mar 2009 17:13:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Arnaud Patard <apatard@mandriva.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v2] Fix SLAB corruption during rmmod
Message-ID: <20090317211345.GI6737@tuxdriver.com> (sfid-20090317_221553_331440_437F16FA)
References: <200903161925.41102.IvDoorn@gmail.com> <200903162024.27870.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200903162024.27870.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 08:24:27PM +0100, Ivo van Doorn wrote:
> At rmmod stage, the code path is the following one :
>=20
> rt2x00lib_remove_dev
> =A0 -> =A0rt2x00lib_uninitialize()
> =A0 =A0 =A0 =A0 -> rt2x00rfkill_unregister()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_unregister()
> =A0 =A0 =A0 =A0 -> rt2x00rfkill_free()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0-> rfkill_free()
>=20
> The problem is that rfkill_free should not be called after rfkill_reg=
ister
> otherwise put_device(&rfkill->dev) will be called 2 times. This patch
> fixes this by only calling rt2x00rfkill_free() when rt2x00rfkill_regi=
ster()
> hasn't been called or has failed.
>=20
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Tested-by: Arnaud Patard <apatard@mandriva.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>=20
> ---
> John, this patch is for 2.6.29 and only 2.6.29 since rfkill support i=
tself
> was removed from later versions (replaced by input_polldev).
> The patch is quite big to be merged in a late state of the release cy=
cle,
> but since the SLAB corruption is a serious problem, I hope this can g=
et in regardless.

Could you send me a version of this that applies on top of
wireless-testing?

Also, is there a bug report somewhere that describes this issue
this addresses?

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
