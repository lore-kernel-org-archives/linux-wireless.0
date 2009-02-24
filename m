Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:24411 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZBXVrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 16:47:09 -0500
Message-ID: <49A46AD4.3060007@gmail.com> (sfid-20090224_224715_368668_EEDBA657)
Date: Tue, 24 Feb 2009 22:47:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet>
In-Reply-To: <20090224135817.GB6019@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24.2.2009 14:58, Bob Copeland wrote:
> On Tue, Feb 24, 2009 at 01:08:03AM +0200, Nick Kossifidis wrote:
>> He does an extra check...
>>
>> 	/*
>> 	 * Given the use of a self-linked tail be very sure that the hw is
>> 	 * done with this descriptor; the hw may have done this descriptor
>> 	 * once and picked it up again...make sure the hw has moved on.
>> 	 */
>> 	if ((ands->ds_rxstatus1&AR_Done) == 0&&  OS_REG_READ(ah, AR_RXDP) == pa)
>> 		return HAL_EINPROGRESS;
>
> Sounds like we definitely need that.If the hw uses up all the dma buffers
> in one go, there's a good chance we can send the skb to mac80211 while
> the hardware is still using it.  I guess an easy way to test would be to
> set the max rx buffers to 3 or so and watch the fireworks.

I added a check for this in rx tasklet some time ago, because I hit it. 
So no fireworks really should happen ;).

And yes, we ought to use this much better test (I knew nothing about 
AR_RXDP reg) than mine.
