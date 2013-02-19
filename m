Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:60037 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933124Ab3BSUBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 15:01:24 -0500
Date: Tue, 19 Feb 2013 21:01:31 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	openwrt-devel@lists.openwrt.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
Message-ID: <20130219200131.GL8730@medion.lan> (sfid-20130219_210134_024200_D9302B1F)
References: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net>
 <CACna6rwLgE+o2mcRTemLFAqzdsEoA9Xyx8GyEQTh5qbv1iZ04A@mail.gmail.com>
 <51228ACF.3060500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51228ACF.3060500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Larry Finger <Larry.Finger@lwfinger.net> [18.02.2013 21:17]:

> (14e4:4315) units. I think the firmware and DMA can handle it. After
> all, all the TX rings have 256 slots. There is, however, a question
> of the memory. TX only acquires the buffers when needed, but RX has
> to get them in advance, thus 256 slots there will waste a lot of
> memory.

I did some testing with 256 slots and the
"b43-workaround-rx-fifo-overflow.patch" on a very slow board,
an i'am sure, that 128 slots are not enough. kernel-log is here:

http://intercity-vpn.de/files/openwrt/b43test.dmesg.txt

this was a normal download (100mb @ 1 megabyte/s), but if you
do some udp-magic (netperf) you run soon into trouble.

thanks for your work!

bye, bastian / wireless.subsignal.org / weimarnetz e.V.
