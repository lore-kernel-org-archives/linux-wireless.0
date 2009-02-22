Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:57417 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZBVMrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 07:47:23 -0500
Message-ID: <49A14956.7080500@gmail.com> (sfid-20090222_134728_627413_60F2407D)
Date: Sun, 22 Feb 2009 13:47:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org>
In-Reply-To: <20090222122036.GC5538@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.2.2009 13:20, Sitsofe Wheeler wrote:
> On Sun, Feb 22, 2009 at 01:01:21PM +0100, Jiri Slaby wrote:
>> The unsupported jumbo message might be a clue. When we jump to the n=
ext:
>> label, the buffer is at the end of the list in software, while in
>> hardware it isn't. In theory, we might hit the bug with rx buffers
>> exhaustion, because the test (bf_last =3D=3D bf) doesn't work as exp=
ected then.
>
> This seems to be happening somewhat regularly now - I've got a small
> collections of the warnings (I'll include them below in case they are
> any help):
[...]
> [11207.741042]   Object 0xd7060000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [11207.741071]   Object 0xd7060010:  80 00 00 00 ff ff ff ff ff ff 00=
 30 ab 1a 32 3f ....=FF=FF=FF=FF=FF=FF.0=AB.2?

All of them are almost the same scenario, the last one was data not=20
beacon, but it's irrelevant. And previously I was wrong, we move the=20
buffer to the end even on hardware side. Thanks so far, I personally se=
e=20
no reason for this to happen yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
