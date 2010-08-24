Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60746 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0HXTpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 15:45:09 -0400
Received: by vws3 with SMTP id 3so805052vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Aug 2010 12:45:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=i_7oMX4nTiWwcjGezv8vG92gX_8UV1tv_KdYL@mail.gmail.com>
References: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com>
	<AANLkTi=i_7oMX4nTiWwcjGezv8vG92gX_8UV1tv_KdYL@mail.gmail.com>
Date: Tue, 24 Aug 2010 21:45:08 +0200
Message-ID: <AANLkTi=oVwssd-YvVCqujm2MNqPGF4t6FUAXGu9Wei5=@mail.gmail.com>
Subject: Re: ath9k: freeze when putting interface up
From: =?ISO-8859-1?Q?Bj=F8rnar_Hansen?= <tilbjornar@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Satagopan Kanthadai <Satagopan.Kanthadai@atheros.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi


> What chipset do you have? You can find this from dmesg after loading ath9k.
>

The chipset is AR9285 Rev: 2.

I recompiled my kernel with atheros debugging support. Here is the
output from after bringing up wlan0:

Aug 24 21:13:16 localhost kernel: [  323.948242] ath: Starting driver
with initial channel: 2412 MHz
Aug 24 21:13:16 localhost kernel: [  323.949260] ath: FULL-SLEEP -> AWAKE
Aug 24 21:13:16 localhost kernel: [  323.955212] ath: PDADC (0,   0):
a280 00000000
Aug 24 21:13:16 localhost kernel: [  323.955216] ath: PDADC: Chain 0 |
PDADC   0 Value   0 | PDADC   1 Value   0 | PDADC   2 Value   0 |
PDADC   3 Value   0 |
Aug 24 21:13:16 localhost kernel: [  323.955223] ath: PDADC (0,   0):
a284 02000000
Aug 24 21:13:16 localhost kernel: [  323.955227] ath: PDADC: Chain 0 |
PDADC   4 Value   0 | PDADC   5 Value   0 | PDADC   6 Value   0 |
PDADC   7 Value   2 |
Aug 24 21:13:16 localhost kernel: [  323.955234] ath: PDADC (0,   0):
a288 0a080604
Aug 24 21:13:16 localhost kernel: [  323.955237] ath: PDADC: Chain 0 |
PDADC   8 Value   4 | PDADC   9 Value   6 | PDADC  10 Value   8 |
PDADC  11 Value  10 |
Aug 24 21:13:16 localhost kernel: [  323.955244] ath: PDADC (0,   0):
a28c 12100e0c
Aug 24 21:13:16 localhost kernel: [  323.955247] ath: PDADC: Chain 0 |
PDADC  12 Value  12 | PDADC  13 Value  14 | PDADC  14 Value  16 |
PDADC  15 Value  18 |
Aug 24 21:13:16 localhost kernel: [  323.955254] ath: PDADC (0,   0):
a290 1a181614
Aug 24 21:13:16 localhost kernel: [  323.955257] ath: PDADC: Chain 0 |
PDAAug 24 21:18:29 localhost kernel: [    0.000000] Initializing
cgroup subsys cpuset

As you see, logging was interrupted in the middle of a line.

Sometimes I can bring the interface up and down multiple times before freezing.


-Bjørnar
