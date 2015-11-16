Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27410 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbbKPMvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 07:51:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-kernel@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Matching crc32 checksums from kernel and user space
Date: Mon, 16 Nov 2015 14:50:47 +0200
Message-ID: <87lh9y1520.fsf@kamboji.qca.qualcomm.com> (sfid-20151116_135122_378410_B1751208)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want ath10k to print a checksum for the firmware image and include
that to the firmware crash dump file as well. Then I want to print the
same checksum from user space scripts and verify it with the crash dump
file.

I thought that crc32 would be good enough for me but it wasn't that
simple as I can't seem to getting matching checksums, at least not with
the user space tools I found. For a test case I created a simple file:

$ xxd /lib/firmware/ath10k/crc-test.bin 
00000000: 3132 3334 3536 3738 3930 0a              1234567890.

In kernel I get these checksums:

[  574.867724] crc32_le(0) 8916bc26
[  574.867739] crc32_le(~0) 1d6ef235
[  574.867743] crc32_be(0) b9346a4c
[  574.867746] crc32_be(~0) 71467465

And from python I got (value in parenthesis is the seed I used):

binascii.crc32(00000000) 0xe2910dcaL
binascii.crc32(ffffffff) 0x76e943d9L
binascii.crc32(edb88320) 0x8256622aL
binascii.crc32(82f63b78) 0xc291ff04L
binascii.crc32(04c11db7) 0x6d877563L
binascii.crc32(104c11db7) 0x6d877563L
binascii.crc32(edb88320) 0x8256622aL
binascii.crc32(82608edb) 0x7b5e5884L

Or with crc32 tool from libarchive-zip-perl:

$ crc32 /lib/firmware/ath10k/crc-test.bin 
e2910dca

So libarchive-zip-perl and python match, but the kernel checksums are
totally different.

I tried md5 the same file and I get the matching id
7c12772809c1c0c3deda6103b10fdfa0 both with md5sum tool in user space and
crypto_shash_update() in kernel. But md5sum is really overkill for me. I
just want to verify that the firmware image is not corrupted or
otherwise broken, the checksum does not need to be secure in any way.
And preferably the checksum would be short enough to make it easy to
print in logs etc.

Any ideas how to match kernel crc32 implementation with user space? Or
am I doing something wrong?

Here's the kernel code I used for testing:

  printk("crc32_le(0) %08x\n", crc32_le(0, fw->data, fw->size));
  printk("crc32_le(~0) %08x\n", crc32_le(~0, fw->data, fw->size));
  printk("crc32_be(0) %08x\n", crc32_be(0, fw->data, fw->size));
  printk("crc32_be(~0) %08x\n", crc32_be(~0, fw->data, fw->size));

-- 
Kalle Valo
