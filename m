Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:34294 "EHLO
	mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbcHMDoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 23:44:12 -0400
Received: by mail-ua0-f182.google.com with SMTP id k90so6675332uak.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2016 20:44:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160812.202613.197744153887748230.davem@davemloft.net>
References: <1471047330-8153-1-git-send-email-pgynther@google.com> <20160812.202613.197744153887748230.davem@davemloft.net>
From: Petri Gynther <pgynther@google.com>
Date: Fri, 12 Aug 2016 20:44:10 -0700
Message-ID: <CAGXr9JEvGDFU2rsWf4N6uM1JTE0W7eBT+7+6Jj-zqEydxyvrWA@mail.gmail.com> (sfid-20160813_054416_033624_C4A8D7AA)
Subject: Re: [PATCH] Modify is_zero_ether_addr() to handle byte-aligned addresses
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2016 at 8:26 PM, David Miller <davem@davemloft.net> wrote:
> From: Petri Gynther <pgynther@google.com>
> Date: Fri, 12 Aug 2016 17:15:30 -0700
>
>> Root cause:
>> mwifiex driver calls is_zero_ether_addr() against byte-aligned address:
>
> MAC addresses really must be 16-bit aligned to be used with any of the
> ethernet address manipulation and test interfaces.
>
> Therefore this driver should do whatever it takes to avoid passing
> a byte-aligned MAC address anywhere.
>
> We _SHOULD NOT_ add support for byte aligned addresses to these
> interfaces, nor add routines which by-name can handle them.
>

ether_addr_equal_unaligned() exists.

commit 73eaef87e98a96fe8b8a586f916b2721bf512efa
Author: Joe Perches <joe@perches.com>
Date:   Fri Dec 6 14:21:01 2013 -0800

    etherdevice: Add ether_addr_equal_unaligned

    Add a generic routine to test if possibly unaligned
    to u16 Ethernet addresses are equal.

    If CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set,
    this uses the slightly faster generic routine
    ether_addr_equal, otherwise this uses memcmp.

    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

> Fix this driver instead of polluting out common interfaces
> unnecessarily.
>

Amitkumar -- is this fixable in mwifiex driver and firmware? It looks
like your firmware expects u8 specific_bssid[ETH_ALEN] at byte offset
1, per struct mwifiex_scan_cmd_config definition.

I'll let Marvell take it from here.

> Thanks.
