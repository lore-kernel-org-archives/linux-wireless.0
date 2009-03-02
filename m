Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:49274 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZCBReV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 12:34:21 -0500
MIME-Version: 1.0
In-Reply-To: <20090226170338.GA1745@silver.sucs.org>
References: <49A1CA01.9030501@gmail.com>
	 <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com>
	 <49A326A4.8090103@gmail.com>
	 <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com>
	 <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com>
	 <20090225140139.GA18694@silver.sucs.org>
	 <20090226135938.GA12182@hash.localnet>
	 <20090226170338.GA1745@silver.sucs.org>
Date: Mon, 2 Mar 2009 12:34:18 -0500
Message-ID: <b6c5339f0903020934k11319f04w8df361e8234db8f9@mail.gmail.com> (sfid-20090302_183427_239180_AD3D43D1)
Subject: Re: [ath5k-devel] [TIP] BUG kmalloc-4096: Poison overwritten
	(ath5k_rx_skb_alloc)
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 12:03 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Thu, Feb 26, 2009 at 08:59:39AM -0500, Bob Copeland wrote:
>> On Wed, Feb 25, 2009 at 02:01:39PM +0000, Sitsofe Wheeler wrote:
>> > It has been days since the original BUG occurred and further it
>> > originally had happened in a -tip kernel with kmemcheck compiled into
>> > it. I had been utterly unable to reproduce the error on any network with
>> > a stock 2.6.29-rc6 kernel. Not even the original -tip kernel produced
>> > the error again...
>
> Note that I was able to reproduce it again : )

So, I took this config and tried a few things without success:

 - turned on failslab fault injection
 - added various mdelay()s to try to widen theoretical race conditions
 - generated traffic with iperf and 'iwlist wlan0 scan' (as root in a loop)

At this point, I think ftrace is the way to go.  I guess a good start
would be the functions in:

grep 'ath5k' available_filter_functions | \
    egrep -v '(debug)|(eeprom)|(hw)|(intr)'

-- 
Bob Copeland %% www.bobcopeland.com
