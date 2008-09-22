Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:21071 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYIVH0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 03:26:05 -0400
Received: by ey-out-2122.google.com with SMTP id 6so377075eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 00:26:02 -0700 (PDT)
Message-ID: <f488382f0809220026u9afa355g1ff2cc7a3fe88333@mail.gmail.com> (sfid-20080922_092609_763055_5AC23A2D)
Date: Mon, 22 Sep 2008 00:26:02 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080922065453.GD19580@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
	 <1221944338.3023.8.camel@johannes.berg>
	 <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com>
	 <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com>
	 <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com>
	 <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com>
	 <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com>
	 <20080922065453.GD19580@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 21, 2008 at 11:54 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sat, Sep 20, 2008 at 06:48:05PM -0700, Steven Noonan wrote:
>>
>> OK, here's the time index at which it b0rked:
>>
>> 18:28:42          sum   1155.00
>> 18:28:43          sum   1339.00
>> 18:28:44          sum  18355.00
>> 18:28:45          sum  17845.45
>>
>> And the entire log of the minute 18:28 is here:
>> http://www.uplinklabs.net/~tycho/linux/18.28.00-59.log.gz
>>
>> It looks pretty crazy.
>
> Thanks, I'll take a look when I get a chance (remember aggretion
> is in the queue too) unless someone beats me to it.
>

You may want to take a quick look at it now. I certainly don't mean
you should push aggregation aside, but the log looks kind of screwy at
18:28:43 (look at line 4972 to see what I mean). It looks as though it
did printk()s from multiple threads with no locking mechanism. It's
possible I will need to re-capture the error, and I'd like to know if
this log will help or not.

- Steven
