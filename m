Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:52231 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbZBVXUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 18:20:55 -0500
Message-ID: <49A1DDD2.7040706@gmail.com> (sfid-20090223_002117_204923_A4CF86C8)
Date: Mon, 23 Feb 2009 00:20:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com>
In-Reply-To: <49A1CA01.9030501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.2.2009 22:56, Jiri Slaby wrote:
> Well, maybe we should try to reproduce with jumbo packets sent to the
> ath5k receiver, since I think it (1) is not very much test-covered code
> (2) appears to be related.

According to the spec I have for older chip, there is not `done' flag 
set for descriptors which have `more' flag set. We handle this wrongly. 
Am I looking correctly, Nick, Luis, Bob?

I still don't see what could have caused this though.
