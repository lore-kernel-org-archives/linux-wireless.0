Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38820 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1GFSq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 14:46:57 -0400
Date: Wed, 6 Jul 2011 14:37:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 3.0] ssb: fix init regression of hostmode PCI core
Message-ID: <20110706183742.GB2553@tuxdriver.com> (sfid-20110706_204701_255554_1D15DAA5)
References: <1309879532-8704-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1309879532-8704-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 05, 2011 at 05:25:32PM +0200, Rafał Miłecki wrote:
> Our workarounds seem to be clientmode PCI specific. Using SPROM
> workaround on SoC resulted in Oops:
> 
> Data bus error, epc == 8017ed58, ra == 80225838
>  Oops[#1]:
>  Cpu 0
>  $ 0   : 00000000 10008000 b8000000 00000001
>  $ 4   : 80293b5c 00000caa ffffffff 00000000
>  $ 8   : 0000000a 00000003 00000001 696d6d20
>  $12   : ffffffff 00000000 00000000 ffffffff
>  $16   : 802d0140 b8004800 802c0000 00000000
>  $20   : 00000000 802c0000 00000000 802d04d4
>  $24   : 00000018 80151a00
>  $28   : 81816000 81817df8 8029bda0 80225838
>  Hi    : 00000000
>  Lo    : 00000000
>  epc   : 8017ed58 ssb_ssb_read16+0x48/0x60
>    Not tainted
>  ra    : 80225838 ssb_pcicore_init+0x54/0x3b4
> 
> Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Hauke: could you give it a try?
> 
> John: this regression was introduced in 3.0

Hauke, I'd like to see your reply before I merge this.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
