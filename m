Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58502 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1BOOtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 09:49:35 -0500
Received: by bwz15 with SMTP id 15so506080bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 06:49:34 -0800 (PST)
Message-ID: <4D5A927A.7060208@gmail.com>
Date: Tue, 15 Feb 2011 15:49:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: me@bobcopeland.com
CC: =?UTF-8?B?0J3QuNC60L7Qu9Cw0Lkg0JvQtdC00L7QstGB0LrQuNGF?=
	<nledovskikh@gmail.com>, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, mickflemm@gmail.com
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
References: <AANLkTinqN4MjWz4y5D195f9J8vob42GsG9u39xX-RuJf@mail.gmail.com> <20110215144445.GA6066@hash.localnet>
In-Reply-To: <20110215144445.GA6066@hash.localnet>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 03:44 PM, me@bobcopeland.com wrote:
> On Tue, Feb 15, 2011 at 02:29:13PM +0000, Николай Ледовских wrote:
>> -    mem = ioremap_nocache(res->start, res->end - res->start + 1);
>> +    mem = res->start;
> 
> Won't this break iommu platforms?

And not only those. This is incorrect on _all_ platforms. You try to
dereference a physical address.

regards,
-- 
js
