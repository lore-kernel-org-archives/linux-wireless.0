Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55677 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab3BSJ5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 04:57:55 -0500
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com>
References: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net>
	<20130219.005206.397289032011003833.davem@davemloft.net>
	<AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com>
Date: Tue, 19 Feb 2013 10:57:54 +0100
Message-ID: <CACna6rz9qRFT_YXJN961=LqzQmhaTPbq+_2UG_LoV7hVgQ7gDA@mail.gmail.com> (sfid-20130219_105804_859424_0EACD5E9)
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, bittorf@bluebottle.com,
	stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/2/19 David Laight <David.Laight@aculab.com>:
>> > Bastian Bittorf reported that some of the silent freezes on a Linksys WRT54G
>> > were due to overflow of the RX DMA ring buffer, which was created with 64
>> > slots. That finding reminded me that I was seeing similar crashed on a netbook,
>> > which also has a relatively slow processor. After increasing the number of
>> > slots to 128, runs on the netbook that previously failed now worked; however,
>> > I found that 109 slots had been used in one test. For that reason, the number
>> > of slots is being increased to 256.
>
> Surely the driver should work even if all the RX buffers get filled?
> Increasing the number of buffers is just hiding the issue.
> A burst of 300 back to back small packets probably fills the 256 slots.
>
> I realise that dropping frames isn't ideal, and that small numbers
> of buffers can make it impossible to receive long fragmented IP
> messages. but increasing the number of buffers doesn't seem to
> be the best fix for a 'silent freeze'.
>
> It might be that the driver would be more robust if it only ever
> put rx buffers into all but one of the ring slots.

That's what I said ;) I have this on my TODO, but I need to resolve my
issues with ethernet first.

-- 
Rafał
