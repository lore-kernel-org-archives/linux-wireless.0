Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1720C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 23:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 615492077C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 23:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="BPuvw68s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfDLX2P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 19:28:15 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:52634 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfDLX2P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 19:28:15 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 4F9FF2F28FBD;
        Fri, 12 Apr 2019 19:28:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555111690;
        bh=VgWLlyshljl98K0ypGNqKx0d62WSBvCH8NIxBzaHhak=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=BPuvw68smjn1JByoFoL8q1LPc54llaJtgGfFbJlZcDiDi5y77sKOyI1/8/W5DFNPa
         /Nv2fqVkweHd40344J2PYYo2BW8hxo+AqNhmZT9PB/VNWHASY4bSfQX9Z9L4WX0PEY
         v6JGqh15sI9uHBZPKC0Zmpb60hAdNikpE5T0W4KIoSbMJXwM1NE9Hw/9JZbBgsk1+y
         fovHMb6tCbRfb0D2xD65rk/sMRiFMUNcWfugTsHLjlnwx2rh+xPnw+sTXKZ7FLG6u1
         rUvTrGjEHh93EMZSBGmeDnaY0BNLga7Th43VqM33UtCDaC1g3Sd+UmgiUVv9jqAHer
         0MWmU947eNNkD1CnZ5ANluJDOo050loocjm6JJo97JV1REpgQRL9x2gdEMYRO/ZBHS
         MSU97doZ1eW/60HsKAaIkVY0iP45YA0enfSksvPeCtQM6GVpViR8ErBvi67emFbv69
         LUYOTGDKZmZtx0bO7je8fU6BQs+DwYTkdvPq3Nde2GHNeDdrHoW37HK6/AY+iYbPWA
         4q0Vp7R8xnfTEqP4W+sUIjBvdc1hejUkIWdzhxwtFrV4X+qMZ7fiCaS+6OO2ZohoWa
         EeGFuKFmOyK4LxYCv6vy2Ui3jd/GU4tqaVMECK5jwRhRAWRRXRmfyTFxhfPPkewQBL
         hw4q16R8L+HqOnFuyE21WxxQ=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3CNS3k6018835
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 13 Apr 2019 09:28:04 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'Petr Mladek'" <pmladek@suse.com>,
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
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-3-alastair@au1.ibm.com> <20190412140353.mgvksn3yk6n65hbk@pathway.suse.cz>
In-Reply-To: <20190412140353.mgvksn3yk6n65hbk@pathway.suse.cz>
Subject: RE: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler bytes
Date:   Sat, 13 Apr 2019 09:28:03 +1000
Message-ID: <093101d4f187$612f0f20$238d2d60$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1AIaTVgFAud+bomjhfstAA==
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Sat, 13 Apr 2019 09:28:05 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Saturday, 13 April 2019 12:04 AM
> To: Alastair D'Silva <alastair@au1.ibm.com>
> Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
Joonas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel Vetter
> <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi Brar
> <jassisinghbrar@gmail.com>; Tom Lendacky <thomas.lendacky@amd.com>;
> David S. Miller <davem@davemloft.net>; Jose Abreu
> <Jose.Abreu@synopsys.com>; Kalle Valo <kvalo@codeaurora.org>;
> Stanislaw Gruszka <sgruszka@redhat.com>; Benson Leung
> <bleung@chromium.org>; Enric Balletbo i Serra
> <enric.balletbo@collabora.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com>; Steven Rostedt <rostedt@goodmis.org>;
> Andrew Morton <akpm@linux-foundation.org>; intel-
> gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of
filler
> bytes
> 
> On Wed 2019-04-10 13:17:18, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> >
> > Some buffers may only be partially filled with useful data, while the
> > rest is padded (typically with 0x00 or 0xff).
> >
> > This patch introduces flags which allow lines of padding bytes to be
> > suppressed, making the output easier to interpret:
> > HEXDUMP_SUPPRESS_0X00, HEXDUMP_SUPPRESS_0XFF
> >
> > The first and last lines are not suppressed by default, so the
> > function always outputs something. This behaviour can be further
> > controlled with the HEXDUMP_SUPPRESS_FIRST &
> HEXDUMP_SUPPRESS_LAST flags.
> >
> > An inline wrapper function is provided for backwards compatibility
> > with existing code, which maintains the original behaviour.
> >
> 
> > diff --git a/lib/hexdump.c b/lib/hexdump.c index
> > b8a164814744..2f3bafb55a44 100644
> > --- a/lib/hexdump.c
> > +++ b/lib/hexdump.c
> > +void print_hex_dump_ext(const char *level, const char *prefix_str,
> > +			int prefix_type, int rowsize, int groupsize,
> > +			const void *buf, size_t len, u64 flags)
> >  {
> >  	const u8 *ptr = buf;
> > -	int i, linelen, remaining = len;
> > +	int i, remaining = len;
> >  	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
> > +	bool first_line = true;
> >
> >  	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
> >  		rowsize = 16;
> >
> >  	for (i = 0; i < len; i += rowsize) {
> > -		linelen = min(remaining, rowsize);
> > +		bool skip = false;
> > +		int linelen = min(remaining, rowsize);
> > +
> >  		remaining -= rowsize;
> >
> > +		if (flags & HEXDUMP_SUPPRESS_0X00)
> > +			skip = buf_is_all(ptr + i, linelen, 0x00);
> > +
> > +		if (!skip && (flags & HEXDUMP_SUPPRESS_0XFF))
> > +			skip = buf_is_all(ptr + i, linelen, 0xff);
> > +
> > +		if (first_line && !(flags & HEXDUMP_SUPPRESS_FIRST))
> > +			skip = false;
> > +
> > +		if (remaining <= 0 && !(flags & HEXDUMP_SUPPRESS_LAST))
> > +			skip = false;
> > +
> > +		if (skip)
> > +			continue;
> 
> IMHO, quietly skipping lines could cause a lot of confusion, espcially
when
> the address is not printed.
>
It's up to the caller to decide how they want it displayed.

> I wonder how it would look like when we print something like:
> 
>     --- skipped XX lines full of 0x00 ---

This could be added as a later enhancement, with a new flag (eg.
HEXDUMP_SUPPRESS_VERBOSE).

> 
> Then we might even remove the SUPPRESS_FIRST, SUPPRESS_LAST and the
> ambiguous QUIET flags.
> 
> > +
> > +		first_line = false;
> 
> This should be above the if (skip).
> 
> > +
> >  		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> > -				   linebuf, sizeof(linebuf), ascii);
> > +				   linebuf, sizeof(linebuf),
> > +				   flags & HEXDUMP_ASCII);
> >
> >  		switch (prefix_type) {
> >  		case DUMP_PREFIX_ADDRESS:
> > @@ -272,7 +316,7 @@ void print_hex_dump(const char *level, const char
> *prefix_str, int prefix_type,
> >  		}
> >  	}
> >  }
> > -EXPORT_SYMBOL(print_hex_dump);
> > +EXPORT_SYMBOL(print_hex_dump_ext);
> 
> We should still export even the original function that is still used
everywhere.

It's replaced with an inline wrapper function, there's no need to export it.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece



