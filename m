Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:65455 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932730Ab1EXWw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 18:52:26 -0400
Date: 24 May 2011 18:52:24 -0400
Message-ID: <20110524225224.32163.qmail@science.horizon.com> (sfid-20110525_005243_847188_B1CEB153)
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, arend@broadcom.com
Subject: Re: [RFC] lib: crc8: add new library module providing crc8 algorithm
Cc: error27@gmail.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux@horizon.com,
	linville@tuxdriver.com
In-Reply-To: <1306268601-10729-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> V3:
> - added function crc8_create().
> - crc8_create() takes polynomial and bit direction as parameters.

May I suggest that crc8_create is A Stupid Idea.  Since the bit order
(and polynomial) will always be compile-time constants, just let the
call sites call crc8_create_[lm]sb_first() directly.

That way there's no need for the enum, and specifying something
other than lsb_first and msb_first is a compile-time error rather than
a run-time one.

It might be nice to add some const declarations, and use size_t
for the buffer length:
u8 crc8(u8 const *table, u8 const *pdata, size_t nbytes, u8 crc)
or
u8 crc8(u8 const table[256], u8 const *pdata, size_t nbytes, u8 crc)


Style points you might consider, but I do not consider essential:

Personally, when a function parameter is a pointer to
a fixed-size array, I prefer to declare it as
	void crc8_create_lsb_first(u8 table[256], u8 poly)
for better documentation, but that's your choice.

The CRC8_GOOD_VALUE could be explained if you like.  "If a CRC is inverted
before transmission, the CRC computed over the while (message+crc)
is _table[x], when x is the bit pattern of the modification (almost
always 0xff)."

Thanks!
