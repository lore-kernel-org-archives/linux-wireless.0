Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbcFPQHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:07:33 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: use s8 instead of char
References: <20160615210318.4130648-1-arnd@arndb.de>
	<wrfjbn32taxw.fsf@redhat.com> <5245411.kmNEkqpVVS@wuerfel>
	<063D6719AE5E284EB5DD2968C1650D6D5F4DA915@AcuExch.aculab.com>
Date: Thu, 16 Jun 2016 12:07:31 -0400
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D5F4DA915@AcuExch.aculab.com>
	(David Laight's message of "Thu, 16 Jun 2016 16:02:38 +0000")
Message-ID: <wrfjvb19qfr0.fsf@redhat.com> (sfid-20160616_180756_014659_51C34A94)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Laight <David.Laight@ACULAB.COM> writes:
> From: Arnd Bergmann
>> On Wednesday, June 15, 2016 5:10:51 PM CEST Jes Sorensen wrote:
>> >
>> > Arnd,
>> >
>> > rtlwifi and rtl8xxxu are two distinct drivers managed by different
>> > people. I'd be really nice if you could split this into a per driver
>> > patch.
>> >
>> > That said, the use of char in rtl8xxxu is all as a flag indicator, so I
>> > don't think the s/char/s8/ conversion is justified. I used char rather
>> > than ugly bool to reduce the size of the struct.
>> 
>> Makes sense, I'll resend without that change. If anything, the flag
>> should become u8, not s8 anyway.
>
> Does bool:8 work ?

Maybe, but bool is such an ugly datatype, so I'd rather use the other
ones.

Jes
