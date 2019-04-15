Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767C2C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BECF2064A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="EwBjsqWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfDOKd5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:33:57 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:47088 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfDOKd4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:33:56 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 9D7572F28FBB;
        Mon, 15 Apr 2019 06:33:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555324435;
        bh=72lI9NwZgSFecdEJvPmdYhwBylZIqtjY6AZr2qW5LC0=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=EwBjsqWxQozr5w1lJlRrUp2D5MRPGXh/T7co5sbf+E8hadFRpBw6vctj7pgbDMQ0M
         vUkuSsXv0DkMzT99YmDYW279lCLac6pr6k+Ejl6Q/CrCo4W91mAYd4ufx7RRFh3pVZ
         kKAnFFgnJhJIJTZEqYrF1NBbZGsvt7r7riP9TapDFwB8maC+Vhhu5SWqdsxS8UU6y2
         hZivCh9IgHt0isApMS04xSX+cpkT8LpS463Ac81akd1qYRvtshPkQPjNbTPFG20qf+
         TELCtZhznvd1eryR3rWbUFdmQTVRaRcb4vNE2nL9ye+oP3m8xu4KxvuMLz8vzAkSDU
         TME2DgDraD0lbxfl/Vl/J8Sw7bWKQKznrFmg4ZsbQ3sg7rqHRGoxUcXg0jzrUAvjBw
         lA2XiiLQloaWnez0NnYYVBqpGWXJsIORe7f/UxlcGuVH+1nO0dVfjwXCPENX0X7YUs
         zg/nOXEC1OhkYKtaTdQp9WWyblKAyheYc2g8jiNHxH/LRvugedjqzJuyTFpIBCsz2H
         QkZFa7LezzA7paw7xtNyd49a1YmEbphLgnjQqt1dk5E1TJHmQzk1pkG05xV6qSX/jD
         L+xFIxw7v6i936nx9qbqc8WOnQIjC8g9T5xtUJ57hoMJn+hfYJ3s+TE5U5uN8OOFyx
         AoXGXh0QT4oyWmYonJgxfYkE=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3FAXnup038604
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Apr 2019 20:33:49 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'Petr Mladek'" <pmladek@suse.com>
Cc:     "'Alastair D'Silva'" <alastair@au1.ibm.com>,
        "'Jani Nikula'" <jani.nikula@linux.intel.com>,
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
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-3-alastair@au1.ibm.com> <20190412140353.mgvksn3yk6n65hbk@pathway.suse.cz> <093101d4f187$612f0f20$238d2d60$@d-silva.org> <20190415091812.s4e5zlwldbe62ego@pathway.suse.cz>
In-Reply-To: <20190415091812.s4e5zlwldbe62ego@pathway.suse.cz>
Subject: RE: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler bytes
Date:   Mon, 15 Apr 2019 20:33:47 +1000
Message-ID: <0db001d4f376$b598af80$20ca0e80$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1AIaTVgFAud+bokCJYEOIgJRBvYio2YlwMA=
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 15 Apr 2019 20:33:49 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > > On Wed 2019-04-10 13:17:18, Alastair D'Silva wrote:
> > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > >
> > > > Some buffers may only be partially filled with useful data, while
> > > > the rest is padded (typically with 0x00 or 0xff).
> > > >
> > > > This patch introduces flags which allow lines of padding bytes to
> > > > be suppressed, making the output easier to interpret:
> > > > HEXDUMP_SUPPRESS_0X00, HEXDUMP_SUPPRESS_0XFF
> > > >
> > > > The first and last lines are not suppressed by default, so the
> > > > function always outputs something. This behaviour can be further
> > > > controlled with the HEXDUMP_SUPPRESS_FIRST &
> > > HEXDUMP_SUPPRESS_LAST flags.
> > > >
> > > > An inline wrapper function is provided for backwards compatibility
> > > > with existing code, which maintains the original behaviour.
> > > >
> > >
> > > > diff --git a/lib/hexdump.c b/lib/hexdump.c index
> > > > b8a164814744..2f3bafb55a44 100644
> > > > --- a/lib/hexdump.c
> > > > +++ b/lib/hexdump.c
> > > > +void print_hex_dump_ext(const char *level, const char *prefix_str,
> > > > +			int prefix_type, int rowsize, int groupsize,
> > > > +			const void *buf, size_t len, u64 flags)
> > > >  {
> > > >  	const u8 *ptr = buf;
> > > > -	int i, linelen, remaining = len;
> > > > +	int i, remaining = len;
> > > >  	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
> > > > +	bool first_line = true;
> > > >
> > > >  	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
> > > >  		rowsize = 16;
> > > >
> > > >  	for (i = 0; i < len; i += rowsize) {
> > > > -		linelen = min(remaining, rowsize);
> > > > +		bool skip = false;
> > > > +		int linelen = min(remaining, rowsize);
> > > > +
> > > >  		remaining -= rowsize;
> > > >
> > > > +		if (flags & HEXDUMP_SUPPRESS_0X00)
> > > > +			skip = buf_is_all(ptr + i, linelen, 0x00);
> > > > +
> > > > +		if (!skip && (flags & HEXDUMP_SUPPRESS_0XFF))
> > > > +			skip = buf_is_all(ptr + i, linelen, 0xff);
> > > > +
> > > > +		if (first_line && !(flags & HEXDUMP_SUPPRESS_FIRST))
> > > > +			skip = false;
> > > > +
> > > > +		if (remaining <= 0 && !(flags &
HEXDUMP_SUPPRESS_LAST))
> > > > +			skip = false;
> > > > +
> > > > +		if (skip)
> > > > +			continue;
> > >
> > > IMHO, quietly skipping lines could cause a lot of confusion,
> > > espcially
> > when the address is not printed.
> > >
> > It's up to the caller to decide how they want it displayed.
> 
> I wonder who would want to quietly skip some data values.
> Are you using it yourself? Could you please provide an example?

Yes, but I don't have the content with me at the moment, so I can't share
it. I'm dumping persistent memory labels, which are 64kB long, but only the
first few hundred bytes are populated.
 
> I do not see why we would need to complicate the API and code by this.
> 
> The behavior proposed by Tvrtko Ursulin makes much more sense. I mean
> https://lkml.kernel.org/r/929244ed-cc7f-b0f3-b5ac-
> 50e798e83188@linux.intel.com

I agree that is better, I'll add that to V2.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece



