Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58742 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbZCBP7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 10:59:22 -0500
Date: Mon, 2 Mar 2009 17:58:47 +0200
From: Jouni Malinen <j@w1.fi>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Remove unused key xoring
Message-ID: <20090302155847.GA4891@jm.kir.nu> (sfid-20090302_165927_163592_A6E566BE)
References: <20090302130728.GB30293@jm.kir.nu> <b6c5339f0903020720x3b2b8ef8ldf726d99c32a5202@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b6c5339f0903020720x3b2b8ef8ldf726d99c32a5202@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 02, 2009 at 10:20:07AM -0500, Bob Copeland wrote:
> > - =C2=A0 =C2=A0 =C2=A0 key1 =3D (get_unaligned_le16(k->kv_val + 4) =
^ xorMask) & 0xffff;
> > - =C2=A0 =C2=A0 =C2=A0 key3 =3D (get_unaligned_le16(k->kv_val + 10)=
 ^ xorMask) & 0xffff;

> > + =C2=A0 =C2=A0 =C2=A0 key1 =3D get_unaligned_le16(k->kv_val + 4);
> > + =C2=A0 =C2=A0 =C2=A0 key3 =3D get_unaligned_le16(k->kv_val + 10) =
& 0xffff;

> key1 lost the mask but key3 kept it?

Heh.. Interesting editing bug that probably happened when I cleaned up
some of my pending patches. I don't think the '& 0xffff' part is really
needed here in either case.
=20
--=20
Jouni Malinen                                            PGP id EFC895F=
A
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
