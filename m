Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:39948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYFCWDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 18:03:13 -0400
Received: by ug-out-1314.google.com with SMTP id h2so184312ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 15:03:11 -0700 (PDT)
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 01/11 v3] rt2x00: Calculate register offset during compile time
Date: Wed, 4 Jun 2008 00:10:46 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032245.35830.IvDoorn@gmail.com> <1212527937.6340.18.camel@brick>
In-Reply-To: <1212527937.6340.18.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806040010.46530.IvDoorn@gmail.com> (sfid-20080604_000319_617052_C2C60E52)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 June 2008, Harvey Harrison wrote:
> On Tue, 2008-06-03 at 22:45 +0200, Ivo van Doorn wrote:
> > By using __ffs() the register offsets were always calculated
> > at run-time which all FIELD32/FIELD16 definitions were builtin
> > constants. This means we can heavily optimize the register handling
> > by allowing GCC to do all the work during compilation.
> >=20
> > Add some compile_ffs() macros to perform the calculation at
> > compile time. After this each rt2x00 module size is reduced
> > by ~2500 bytes. And the stack size of several functions is reduced
> > as well which further limits the number of rt2x00 results in
> > 'make checkstack'.
> > +/*
> > + * Macro's to find first set bit in a variable.
> > + * These macro's behaves the same as the __ffs() function with
> > + * the most important difference that this is done during
> > + * compile-time rather then run-time.
> > + */
>=20
> #define const_ffs8(__x) ( \
> 	BUILD_BUG_ON(!__builtin_constant_p(__x));	\
> 	__builtin_choose_expr((__x) & 0x01, 0,		\
> 	=EF=BB=BF__builtin_choose_expr((__x) & 0x02, 1,		\
> 	=EF=BB=BF__builtin_choose_expr((__x) & 0x04, 2,		\
> 	=EF=BB=BF__builtin_choose_expr((__x) & 0x08, 3,		\
> 	=EF=BB=BF__builtin_choose_expr((__x) & 0x10, 4,		\
> 	=EF=BB=BF__builtin_choose_expr((__x) & 0x20, 5,		\
> 	=EF=BB=BF__builtin_choose_expr((__x) & 0x40, 6,		\
> 	=EF=BB=BF__builtin_choose_expr((__x) & 0x80, 7,		\
> 	8)))))))); )
>=20
> #define const_ffs16(__x) ( \
> 	__builtin_choose_expr((__x) & 0xff,	\
>  	const_ffs8(__x),			\
> 	const_ffs8((__x) >> 8) + 8); )
>=20
> =EF=BB=BF
> #define const_ffs32(__x) ( \
> 	__builtin_choose_expr((__x) & 0xffff,	\
> 	const_ffs16(__x),			\
> 	const_ffs16((__x) >> 16) + 16); )
>=20
>=20
> Just a thought.

Thanks for the tipe, that does sound a lot cleaner then the ? : stateme=
nts,
I did a quick compilation check and it doesn't seem to have any influen=
ce.
I'll move the __builtin_choose_expr into rt2x00.git for testing and mov=
e
that patch upstream to wireless-2.6 later.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
