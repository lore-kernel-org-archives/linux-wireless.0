Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:58760 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118AbYE2NvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 09:51:22 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1533457nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 06:51:19 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: ffs() compile-time
Date: Thu, 29 May 2008 15:55:53 +0200
Cc: rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805291555.53673.IvDoorn@gmail.com> (sfid-20080529_155220_680692_BF6BE021)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In rt2x00 I define all registers through the FIELD32(__mask) defines,
which look like this:

struct rt2x00_field32 {
	u32 bit_offset;
	u32 bit_mask;
};

#define FIELD32(__mask)
({
	BUILD_BUG_ON(!(__mask) ||
		     !is_valid_mask(__mask) ||	
		     (__mask) != (u32)(__mask));
	(struct rt2x00_field32) {
		__ffs(__mask), (__mask)
	};
})

As you see everywhere where a define which contains FIELD32() will
make a call to __ffs(). However this is suboptimal since the __mask which
is passed to __ffs() is a constant during compile time.
So it would be very nice when I can make use of a compile-time version of __ffs()
to make GCC find the first bit during compile-time this would increase performance
and help reduce the module size of each rt2x00 driver.

However I am a bit lost at what a proper solution would be, GCC provides
__builtin_ffs() but would that perform the compile-time calculation or not.
Another solution would be creating a macro like:

#define _COMPILE_FFS4(x)\
({			\
	(x) & 0x1 ? 1 :	\
	(x) & 0x2 ? 2 :	\
	(x) & 0x4 ? 3 :	\
	(x) & 0x8 ? 4 :	\
	0;		\
})

And have _COMPILE_FFS8, _COMPILE_FFS16 and _COMPILE_FFS32 use above macro.
But I am kind of hesitant about that macro as well, because it just doesn't feel right. :S

Any advice is welcome. :)
Thanks,

Ivo
