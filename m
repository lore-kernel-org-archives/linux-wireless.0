Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56729 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3BRQSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 11:18:37 -0500
MIME-Version: 1.0
In-Reply-To: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 18 Feb 2013 17:18:34 +0100
Message-ID: <CACna6rwLgE+o2mcRTemLFAqzdsEoA9Xyx8GyEQTh5qbv1iZ04A@mail.gmail.com> (sfid-20130218_171841_471506_67D3228A)
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Bastian Bittorf <bittorf@bluebottle.com>,
	Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/2/18 Larry Finger <Larry.Finger@lwfinger.net>:
> Bastian Bittorf reported that some of the silent freezes on a Linksys WRT54G
> were due to overflow of the RX DMA ring buffer, which was created with 64
> slots. That finding reminded me that I was seeing similar crashed on a netbook,
> which also has a relatively slow processor. After increasing the number of
> slots to 128, runs on the netbook that previously failed now worked; however,
> I found that 109 slots had been used in one test. For that reason, the number
> of slots is being increased to 256.

So probably ideal solution is to use 128 *and* fix the driver's
failing on overflow ;)

Did you try it on some old device? Just for sure firmware&DMA will
handle it correctly.

-- 
Rafał
