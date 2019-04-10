Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AF7C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 09:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9755220820
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 09:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="Tbvv2b8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfDJJxY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 05:53:24 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:44470 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729273AbfDJJxX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 05:53:23 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id BA1FF2F28FBB;
        Wed, 10 Apr 2019 05:53:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1554889998;
        bh=HpSR4lU2fda1pmePQlDBV7zLl/nIo9BrQvOkc9aRnWQ=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=Tbvv2b8u9cg1pCHqI1CX7UizfhZiKPJTiQMQ0AUA1F3aa7YUWQiLGo6VoyBYVznqP
         DFupL4pxymYD2M0wwe6SvE+dQ6V+B7MHLptm0oD8R4GqAHQ4eRZcTH0eZQKgAX3fpt
         zqbvZOp6iVQZAqrPV3YZIHGZZYdyEAaUPofNJqyVrAZ1Cg1mgppDnCj7hzJ7Op5PvB
         /9W75atdmUo45Z/+Ft1fIpa8ws37RpK7FgmBgtFAAJyLfw2UP9JRCReE3g1DtDiE52
         rXdd/MBBdcpcvcyqb8IT/pkZ/gYbKS207/rMQnL9jwxQx/48U7golJBxN4h0SbGpVl
         cTUI9Z7yUdKG6d3kgm2KIiEwYT4qru08YYAqfgGD9fVcX+wcYn+uNLsK8uLASNLjvV
         ZnP/BMZXnhUcf9mtZL+HXCAvZUDqjeE8eK+XVB+J+5VQSnME03DNx0tdTu66Zgm4k/
         y5/XNJkP1TCWynxqCWWUWik3ntSpLhGakIUEzbzPymTLwv1//xMFZldX/Dn+GQz2Vs
         dDnj1CaVFVoIVXIk8NufEFaeqOHFcBiwoDAzU/u9z5czQLeXOPKV3QKgOvzCXptAf4
         smQB5UkrW2KjUffkI2YcMUgoOWbSWNybMUzKnJvjDfZEyDlvTU3X60zfrq9xM4mc0/
         nn4hTMgkVyJJQfN6Nr43knvE=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3A9r0EN096809
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 10 Apr 2019 19:53:01 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'David Laight'" <David.Laight@ACULAB.COM>,
        "'Alastair D'Silva'" <alastair@au1.ibm.com>
Cc:     "'Jani Nikula'" <jani.nikula@linux.intel.com>,
        "'Joonas Lahtinen'" <joonas.lahtinen@linux.intel.com>,
        "'Rodrigo Vivi'" <rodrigo.vivi@intel.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Daniel Vetter'" <daniel@ffwll.ch>,
        "'Karsten Keil'" <isdn@linux-pingi.de>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        "'Tom Lendacky'" <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jose Abreu'" <Jose.Abreu@synopsys.com>,
        "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'Stanislaw Gruszka'" <sgruszka@redhat.com>,
        "'Benson Leung'" <bleung@chromium.org>,
        "'Enric Balletbo i Serra'" <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Petr Mladek'" <pmladek@suse.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-5-alastair@au1.ibm.com> <1cd09186c67b4fa4bceb84faf835ff10@AcuMS.aculab.com>
In-Reply-To: <1cd09186c67b4fa4bceb84faf835ff10@AcuMS.aculab.com>
Subject: RE: [PATCH 4/4] lib/hexdump.c: Allow multiple groups to be separated by lines '|'
Date:   Wed, 10 Apr 2019 19:52:58 +1000
Message-ID: <051301d4ef83$34d2c710$9e785530$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1AGYm3aUAX9F7fqjkUMc8A==
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Wed, 10 Apr 2019 19:53:12 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: David Laight <David.Laight@ACULAB.COM>
> Sent: Wednesday, 10 April 2019 6:45 PM
> To: 'Alastair D'Silva' <alastair@au1.ibm.com>; alastair@d-silva.org
> Cc: Jani Nikula <jani.nikula@linux.intel.com>; Joonas Lahtinen
> <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi =
<rodrigo.vivi@intel.com>;
> David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; =
Karsten Keil
> <isdn@linux-pingi.de>; Jassi Brar <jassisinghbrar@gmail.com>; Tom =
Lendacky
> <thomas.lendacky@amd.com>; David S. Miller <davem@davemloft.net>;
> Jose Abreu <Jose.Abreu@synopsys.com>; Kalle Valo
> <kvalo@codeaurora.org>; Stanislaw Gruszka <sgruszka@redhat.com>;
> Benson Leung <bleung@chromium.org>; Enric Balletbo i Serra
> <enric.balletbo@collabora.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> <viro@zeniv.linux.org.uk>; Petr Mladek <pmladek@suse.com>; Sergey
> Senozhatsky <sergey.senozhatsky@gmail.com>; Steven Rostedt
> <rostedt@goodmis.org>; Andrew Morton <akpm@linux-foundation.org>;
> intel-gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; =
linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: RE: [PATCH 4/4] lib/hexdump.c: Allow multiple groups to be
> separated by lines '|'
>=20
> From: Alastair D'Silva
> > Sent: 10 April 2019 04:17
> > With the wider display format, it can become hard to identify how =
many
> > bytes into the line you are looking at.
> >
> > The patch adds new flags to hex_dump_to_buffer() and
> print_hex_dump()
> > to print vertical lines to separate every N groups of bytes.
> >
> > eg.
> > buf:00000000: 454d414e 43415053|4e495f45 00584544
> NAMESPAC|E_INDEX.
> > buf:00000010: 00000000 00000002|00000000 00000000  ........|........
>=20
> Ugg, that is just horrid.
> It is enough to add an extra space if you really need the columns to =
be more
> easily counted.
>

I did consider that, but it would be a more invasive change, as the =
buffer length required would differ based on the flags.
=20
> I'm not even sure that is needed if you are printing 32bit words.
> OTOH 32bit words makes 64bit values really stupid on LE systems.
> Bytes with extra spaces every 4 bytes is the format I prefer even for =
long
> lines.
>=20
> Oh, and if you are using hexdump() a lot you want a version that never =
uses
> snprintf().
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
> MK1 1PT, UK Registration No: 1397386 (Wales)
>=20
>=20
> ---
> This email has been checked for viruses by AVG.
> https://www.avg.com


