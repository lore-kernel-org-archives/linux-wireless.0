Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:48092 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbZBWWnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 17:43:53 -0500
Message-ID: <49A326A4.8090103@gmail.com> (sfid-20090223_234357_254340_93D75DB5)
Date: Mon, 23 Feb 2009 23:43:48 +0100
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
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com>
In-Reply-To: <49A321BA.2040500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23.2.2009 23:22, Jiri Slaby wrote:
> We should hit (unlikely(ret == -EINPROGRESS)) test
> everytime.

I get on a AR2413
XX 000 128c0054 cb980203
XX 001 00000000 00000000
XX 000 128c0054 cfb80003
XX 001 00000000 00000000
XX 000 00001420 00000001
ath5k phy5: unsupported jumbo
XX 001 126c001c 80600003
XX 002 00000000 00000000
XX 000 127d8079 44ca0003
XX 001 00000000 00000000
XX 000 128d8079 54cc0003
(count, status_0, status_1)
so it means, it sets done flag even for more flag descs and thus we 
handle it well in this particular case.
