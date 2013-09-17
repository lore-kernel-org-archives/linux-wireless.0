Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:55345 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3IQTLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 15:11:47 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so2350154bkh.26
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 12:11:46 -0700 (PDT)
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 17 Sep 2013 21:11:25 +0200
Message-ID: <CAG-2HqUUbmcEoYqV+qi8SWZXzSLd22WUO88Gry6Mc1GQJy-Ocg@mail.gmail.com> (sfid-20130917_211204_831299_292158BE)
Subject: [REGRESSION]: bcma: fix handling of big addrl
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The above commit causes a regression for me.

Booting with initcall_debug shows that bcma_modinit never returns:

calling  bcma_modinit+0x0/0x33 [bcma] @ 210
bcma-pci-bridge 0000:02:00.0: enabling device (0000 -> 0002)
bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08

Which means that (obviously) my wireless nic doesnot work (doe not
show up in "ip addr"). Moreover, the kernel hangs during reboot and
I'm forced to do a hard-reboot.

Reverting the offending commit on top of 3.12-rc1 fixes the problem.

Cheers,

Tom
