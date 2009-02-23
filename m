Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:51618 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZBWWW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 17:22:56 -0500
Message-ID: <49A321BA.2040500@gmail.com> (sfid-20090223_232303_127309_9B4045D5)
Date: Mon, 23 Feb 2009 23:22:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com>
In-Reply-To: <20090223152724.M82409@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23.2.2009 16:35, Bob Copeland wrote:
> As I understand it, yes, we don't do the right thing when the more flag
> is set.  We're supposed to keep processing packets until we get one with
> the done flag, and then all of that is supposed to be merged into a single
> packet.  Other flags such as the rx rate are only valid on the final
> packet.

What I don't understand is how we can proceed further, if we should 
never get done flag set according to the specs for the buffer which has 
more flag set. We should hit (unlikely(ret == -EINPROGRESS)) test everytime.

> So I am not sure if the jumbo packets are causing bad things to happen,
> or if they are an indication that something bad has already happened.

I don't know, it was just an idea. I tried to lower rxbufsize to 1000 
and see no problems so far (except unsupported jumbo warnings and packet 
loss indeed).
