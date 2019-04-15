Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC19DC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A4F20656
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfDOJSR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:18:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:52350 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfDOJSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 05:18:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69A23B008;
        Mon, 15 Apr 2019 09:18:14 +0000 (UTC)
Date:   Mon, 15 Apr 2019 11:18:12 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Alastair D'Silva <alastair@d-silva.org>
Cc:     'Alastair D'Silva' <alastair@au1.ibm.com>,
        'Jani Nikula' <jani.nikula@linux.intel.com>,
        'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>,
        'Rodrigo Vivi' <rodrigo.vivi@intel.com>,
        'David Airlie' <airlied@linux.ie>,
        'Daniel Vetter' <daniel@ffwll.ch>,
        'Karsten Keil' <isdn@linux-pingi.de>,
        'Jassi Brar' <jassisinghbrar@gmail.com>,
        'Tom Lendacky' <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jose Abreu' <Jose.Abreu@synopsys.com>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Stanislaw Gruszka' <sgruszka@redhat.com>,
        'Benson Leung' <bleung@chromium.org>,
        'Enric Balletbo i Serra' <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        'Alexander Viro' <viro@zeniv.linux.org.uk>,
        'Sergey Senozhatsky' <sergey.senozhatsky@gmail.com>,
        'Steven Rostedt' <rostedt@goodmis.org>,
        'Andrew Morton' <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler
 bytes
Message-ID: <20190415091812.s4e5zlwldbe62ego@pathway.suse.cz>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-3-alastair@au1.ibm.com>
 <20190412140353.mgvksn3yk6n65hbk@pathway.suse.cz>
 <093101d4f187$612f0f20$238d2d60$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <093101d4f187$612f0f20$238d2d60$@d-silva.org>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat 2019-04-13 09:28:03, Alastair D'Silva wrote:
> > -----Original Message-----
> > From: Petr Mladek <pmladek@suse.com>
> > Sent: Saturday, 13 April 2019 12:04 AM
> > To: Alastair D'Silva <alastair@au1.ibm.com>
> > Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
> Joonas
> > Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> > <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel Vetter
> > <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi Brar
> > <jassisinghbrar@gmail.com>; Tom Lendacky <thomas.lendacky@amd.com>;
> > David S. Miller <davem@davemloft.net>; Jose Abreu
> > <Jose.Abreu@synopsys.com>; Kalle Valo <kvalo@codeaurora.org>;
> > Stanislaw Gruszka <sgruszka@redhat.com>; Benson Leung
> > <bleung@chromium.org>; Enric Balletbo i Serra
> > <enric.balletbo@collabora.com>; James E.J. Bottomley
> > <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> > <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> > <sergey.senozhatsky@gmail.com>; Steven Rostedt <rostedt@goodmis.org>;
> > Andrew Morton <akpm@linux-foundation.org>; intel-
> > gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org;
> > ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> > scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> > devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> > Subject: Re: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of
> filler
> > bytes
> > 
> > On Wed 2019-04-10 13:17:18, Alastair D'Silva wrote:
> > > From: Alastair D'Silva <alastair@d-silva.org>
> > >
> > > Some buffers may only be partially filled with useful data, while the
> > > rest is padded (typically with 0x00 or 0xff).
> > >
> > > This patch introduces flags which allow lines of padding bytes to be
> > > suppressed, making the output easier to interpret:
> > > HEXDUMP_SUPPRESS_0X00, HEXDUMP_SUPPRESS_0XFF
> > >
> > > The first and last lines are not suppressed by default, so the
> > > function always outputs something. This behaviour can be further
> > > controlled with the HEXDUMP_SUPPRESS_FIRST &
> > HEXDUMP_SUPPRESS_LAST flags.
> > >
> > > An inline wrapper function is provided for backwards compatibility
> > > with existing code, which maintains the original behaviour.
> > >
> > 
> > > diff --git a/lib/hexdump.c b/lib/hexdump.c index
> > > b8a164814744..2f3bafb55a44 100644
> > > --- a/lib/hexdump.c
> > > +++ b/lib/hexdump.c
> > > +void print_hex_dump_ext(const char *level, const char *prefix_str,
> > > +			int prefix_type, int rowsize, int groupsize,
> > > +			const void *buf, size_t len, u64 flags)
> > >  {
> > >  	const u8 *ptr = buf;
> > > -	int i, linelen, remaining = len;
> > > +	int i, remaining = len;
> > >  	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
> > > +	bool first_line = true;
> > >
> > >  	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
> > >  		rowsize = 16;
> > >
> > >  	for (i = 0; i < len; i += rowsize) {
> > > -		linelen = min(remaining, rowsize);
> > > +		bool skip = false;
> > > +		int linelen = min(remaining, rowsize);
> > > +
> > >  		remaining -= rowsize;
> > >
> > > +		if (flags & HEXDUMP_SUPPRESS_0X00)
> > > +			skip = buf_is_all(ptr + i, linelen, 0x00);
> > > +
> > > +		if (!skip && (flags & HEXDUMP_SUPPRESS_0XFF))
> > > +			skip = buf_is_all(ptr + i, linelen, 0xff);
> > > +
> > > +		if (first_line && !(flags & HEXDUMP_SUPPRESS_FIRST))
> > > +			skip = false;
> > > +
> > > +		if (remaining <= 0 && !(flags & HEXDUMP_SUPPRESS_LAST))
> > > +			skip = false;
> > > +
> > > +		if (skip)
> > > +			continue;
> > 
> > IMHO, quietly skipping lines could cause a lot of confusion, espcially
> when the address is not printed.
> >
> It's up to the caller to decide how they want it displayed.

I wonder who would want to quietly skip some data values.
Are you using it yourself? Could you please provide an
example?

I do not see why we would need to complicate the API and code
by this.

The behavior proposed by Tvrtko Ursulin makes much more
sense. I mean
https://lkml.kernel.org/r/929244ed-cc7f-b0f3-b5ac-50e798e83188@linux.intel.com


> > I wonder how it would look like when we print something like:
> > 
> >     --- skipped XX lines full of 0x00 ---
> 
> This could be added as a later enhancement, with a new flag (eg.
> HEXDUMP_SUPPRESS_VERBOSE).

Who will add this later? Frankly, this looks like a half baked
feature that it good enough for you. If you want it upstream,
it must behave reasonably and it must be worth it.

Best Regards,
Petr
