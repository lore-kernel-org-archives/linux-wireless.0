Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f163.google.com ([209.85.217.163]:63225 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbZBWXIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 18:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <49A326A4.8090103@gmail.com>
References: <20090222111807.GB5538@silver.sucs.org>
	 <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org>
	 <20090222144742.GA6078@nowhere>
	 <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com>
	 <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com>
	 <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com>
Date: Tue, 24 Feb 2009 01:08:03 +0200
Message-ID: <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> (sfid-20090224_000811_700976_82E3C86C)
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/24 Jiri Slaby <jirislaby@gmail.com>:
> On 23.2.2009 23:22, Jiri Slaby wrote:
>>
>> We should hit (unlikely(ret == -EINPROGRESS)) test
>> everytime.
>
> I get on a AR2413
> XX 000 128c0054 cb980203
> XX 001 00000000 00000000
> XX 000 128c0054 cfb80003
> XX 001 00000000 00000000
> XX 000 00001420 00000001
> ath5k phy5: unsupported jumbo
> XX 001 126c001c 80600003
> XX 002 00000000 00000000
> XX 000 127d8079 44ca0003
> XX 001 00000000 00000000
> XX 000 128d8079 54cc0003
> (count, status_0, status_1)
> so it means, it sets done flag even for more flag descs and thus we handle
> it well in this particular case.
>

We have to ignore done flag when more flag is set, done flag is only
valid when more flag is cleared according to docs.

Also check out Sam's version here ->
http://svn.freebsd.org/viewvc/base/projects/ath_hal/ar5212/ar5212_recv.c?revision=185406&view=markup

He does an extra check...

	/*
	 * Given the use of a self-linked tail be very sure that the hw is
	 * done with this descriptor; the hw may have done this descriptor
	 * once and picked it up again...make sure the hw has moved on.
	 */
	if ((ands->ds_rxstatus1&AR_Done) == 0 && OS_REG_READ(ah, AR_RXDP) == pa)
		return HAL_EINPROGRESS;



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
