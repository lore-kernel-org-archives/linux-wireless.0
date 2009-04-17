Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbZDQASi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 20:18:38 -0400
Date: Fri, 17 Apr 2009 00:18:07 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: stable@kernel.org, Arnaud Patard <apatard@mandriva.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [stable] [PATCH] rt2x00: Fix SLAB corruption during rmmod
Message-ID: <20090417001807.GA5020@hera.kernel.org> (sfid-20090417_021842_836825_5E397F0B)
References: <200904012118.12391.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200904012118.12391.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Ivo van Doorn (ivdoorn@gmail.com) wrote:
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

Who is the Author of this patch?  The Signed-off-by order suggests is
Gertjan.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
