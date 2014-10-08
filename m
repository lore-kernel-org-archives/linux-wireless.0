Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58053 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbaJHAIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 20:08:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <21556.32962.247661.143073@gargle.gargle.HOWL> (sfid-20141008_020858_961081_71A2113E)
Date: Wed, 8 Oct 2014 05:39:38 +0530
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH v2 3/6] ath9k: Fix sequence number assignment
In-Reply-To: <20141007185005.GK25590@tuxdriver.com>
References: <1412657081-3202-1-git-send-email-sujith@msujith.org>
	<1412657081-3202-4-git-send-email-sujith@msujith.org>
	<20141007185005.GK25590@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Hmmm...am I missing something?
> 
>   CC      drivers/net/wireless/ath/ath9k/tx99.o
> In file included from include/linux/byteorder/little_endian.h:4:0,
>                  from ./arch/x86/include/uapi/asm/byteorder.h:4,
>                  from include/asm-generic/bitops/le.h:5,
>                  from ./arch/x86/include/asm/bitops.h:506,
>                  from include/linux/bitops.h:33,
>                  from include/linux/kernel.h:10,
>                  from include/linux/skbuff.h:17,
>                  from include/linux/if_ether.h:23,
>                  from include/linux/etherdevice.h:25,
>                  from drivers/net/wireless/ath/ath9k/ath9k.h:20,
>                  from drivers/net/wireless/ath/ath9k/tx99.c:17:
> drivers/net/wireless/ath/ath9k/tx99.c: In function ‘ath9k_build_tx99_skb’:
> drivers/net/wireless/ath/ath9k/tx99.c:74:37: error: ‘struct ath_tx’ has no member named ‘seq_no’
>   hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
>                                      ^
> include/uapi/linux/byteorder/little_endian.h:34:51: note: in definition of macro ‘__cpu_to_le16’
>  #define __cpu_to_le16(x) ((__force __le16)(__u16)(x))
>                                                    ^
> drivers/net/wireless/ath/ath9k/tx99.c:74:19: note: in expansion of macro ‘cpu_to_le16’
>   hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
>                    ^
> make[3]: *** [drivers/net/wireless/ath/ath9k/tx99.o] Error 1

This is my mistake. I did not test with CONFIG_ATH9K_TX99 enabled, sorry.
I'll send an updated series.

Sujith
