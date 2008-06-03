Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:37711 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYFCVTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 17:19:00 -0400
Received: by wr-out-0506.google.com with SMTP id c48so3479513wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 14:18:58 -0700 (PDT)
Subject: Re: [PATCH 01/11 v3] rt2x00: Calculate register offset during
	compile time
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200806032245.35830.IvDoorn@gmail.com>
References: <200806032024.52931.IvDoorn@gmail.com>
	 <200806032029.35662.IvDoorn@gmail.com>
	 <200806032205.17071.IvDoorn@gmail.com>
	 <200806032245.35830.IvDoorn@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 03 Jun 2008 14:18:56 -0700
Message-Id: <1212527937.6340.18.camel@brick> (sfid-20080603_231906_245214_9B0785A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-03 at 22:45 +0200, Ivo van Doorn wrote:
> By using __ffs() the register offsets were always calculated
> at run-time which all FIELD32/FIELD16 definitions were builtin
> constants. This means we can heavily optimize the register handling
> by allowing GCC to do all the work during compilation.
>=20
> Add some compile_ffs() macros to perform the calculation at
> compile time. After this each rt2x00 module size is reduced
> by ~2500 bytes. And the stack size of several functions is reduced
> as well which further limits the number of rt2x00 results in
> 'make checkstack'.
> +/*
> + * Macro's to find first set bit in a variable.
> + * These macro's behaves the same as the __ffs() function with
> + * the most important difference that this is done during
> + * compile-time rather then run-time.
> + */

#define const_ffs8(__x) ( \
	BUILD_BUG_ON(!__builtin_constant_p(__x));	\
	__builtin_choose_expr((__x) & 0x01, 0,		\
	=EF=BB=BF__builtin_choose_expr((__x) & 0x02, 1,		\
	=EF=BB=BF__builtin_choose_expr((__x) & 0x04, 2,		\
	=EF=BB=BF__builtin_choose_expr((__x) & 0x08, 3,		\
	=EF=BB=BF__builtin_choose_expr((__x) & 0x10, 4,		\
	=EF=BB=BF__builtin_choose_expr((__x) & 0x20, 5,		\
	=EF=BB=BF__builtin_choose_expr((__x) & 0x40, 6,		\
	=EF=BB=BF__builtin_choose_expr((__x) & 0x80, 7,		\
	8)))))))); )

#define const_ffs16(__x) ( \
	__builtin_choose_expr((__x) & 0xff,	\
 	const_ffs8(__x),			\
	const_ffs8((__x) >> 8) + 8); )

=EF=BB=BF
#define const_ffs32(__x) ( \
	__builtin_choose_expr((__x) & 0xffff,	\
	const_ffs16(__x),			\
	const_ffs16((__x) >> 16) + 16); )


Just a thought.

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
