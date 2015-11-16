Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26525 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbKPP1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 10:27:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-kernel@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: Matching crc32 checksums from kernel and user space
References: <87lh9y1520.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 16 Nov 2015 17:27:21 +0200
In-Reply-To: <87lh9y1520.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 16 Nov 2015 14:50:47 +0200")
Message-ID: <87egfq0xt2.fsf@kamboji.qca.qualcomm.com> (sfid-20151116_162753_335185_B166F04D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Hi,
>
> I want ath10k to print a checksum for the firmware image and include
> that to the firmware crash dump file as well. Then I want to print the
> same checksum from user space scripts and verify it with the crash dump
> file.
>
> I thought that crc32 would be good enough for me but it wasn't that
> simple as I can't seem to getting matching checksums, at least not with
> the user space tools I found. For a test case I created a simple file:
>
> $ xxd /lib/firmware/ath10k/crc-test.bin 
> 00000000: 3132 3334 3536 3738 3930 0a              1234567890.
>
> In kernel I get these checksums:
>
> [  574.867724] crc32_le(0) 8916bc26
> [  574.867739] crc32_le(~0) 1d6ef235
> [  574.867743] crc32_be(0) b9346a4c
> [  574.867746] crc32_be(~0) 71467465
>
> And from python I got (value in parenthesis is the seed I used):
>
> binascii.crc32(00000000) 0xe2910dcaL
> binascii.crc32(ffffffff) 0x76e943d9L

Johannes Berg pointed out that this looks to be a sign issue, I just
need to invert the python value and then I get the same value:

>>> hex(~0x76e943d9 & 0xffffffff)
'0x8916bc26'

-- 
Kalle Valo
