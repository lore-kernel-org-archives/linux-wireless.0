Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:2891 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYCCJhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 04:37:20 -0500
Received: by wf-out-1314.google.com with SMTP id 28so6755214wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 01:37:19 -0800 (PST)
Message-ID: <a32f33a40803030137k116fadbfk1e5e571e94cf222a@mail.gmail.com> (sfid-20080303_093725_353799_C0F66513)
Date: Mon, 3 Mar 2008 10:37:19 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Cc: "Franz Apeltauer" <franz.apeltauer@gmx.at>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1204504331.3917.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47CB3B5E.4020701@gmx.at> <1204504331.3917.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  >    CC [M]
>  > .../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware=
=2Eo
>  > .../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware=
=2Ec:116:
>  > Fehler: Redefinition von =BBrt2x00lib_load_firmware=AB
>  > =3D Error: redefiniton of  =BBrt2x00lib_load_firmware=AB
>  >
>
> > When I tried to "export CONFIG_CRC_ITU_T=3Dy" before "make",
>  > rt2x00firmware.c compiled fine. (Probably this is not a good idea.=
 I
>  > just wanted to see, if it compiles then.)
>
>  That's odd because the latest config.mk should check for CRC_ITU_T
>  before... Ivo could there be a problem with rt2x00 when crc-itu-t is=
n't
>  available?

Yes, but only for rt61 and rt73. The crc-itu-t is used for firmware
crc validation.
(Note that rt2x00firmware.o should only be compiled when rt61 and rt73 =
are
being compiled).

There currently is also a dependency on crc-ccitt, but that is for the
upcoming rt2800 drivers (Yes, I could do the same as the legacy driver
and use crc-itu-t, but I dislike the idea of bit-reverting each firmwar=
e word
before pushing it through the crc algorithm.).

>  > In /usr/src/linux-headers-2.6.22-14/include/linux/slab.h I found:
>  >     struct kmem_cache *kmem_cache_create(const char *, size_t, siz=
e_t,
>  >               unsigned long,
>  >               void (*)(void *, struct kmem_cache *, unsigned long)=
,
>  >               void (*)(void *, struct kmem_cache *, unsigned long)=
);
>  > i.e. the old, 6-parameter version.
>  >
>  > So, IMHO the #define kmem_cache_create in
>  > - compat-wireless-2.6/include/net/compat.h, line 120 and
>  > - compat-wireless-2.6/compat/compat.h, line 120
>  > should be moved 2 lines downwards into the block named
>  > /* Compat work for 2.6.22 and 2.6.23 */
>  > Then it compiles fine.
>
>  Ok, indeed, it should be moved then, I was working on .21 when I not=
iced
>  that needed to be done.
>
>  johannes
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
