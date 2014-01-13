Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56542 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaAMUAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:00:14 -0500
Date: Mon, 13 Jan 2014 14:49:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v2 0/3] wil6210 patches
Message-ID: <20140113194949.GF14400@tuxdriver.com> (sfid-20140113_210018_837475_0B7EBAFB)
References: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I already merged the v1 series.  Please submit any new patches on
top of what has already been merged...

On Sun, Jan 12, 2014 at 10:41:01AM +0200, Vladimir Kondratiev wrote:
> in the previour submission, bug was found by kbuild, see below.
> It is about incorrect #include, one I used do not work for the
> architectures lacking native prefetch().
> 
> Re-submitting all series.
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
> head:   1e2f9295f4c657500111514f92a3d3894d0e05b4
> commit: 1cbbcb08c786964a16773c39f2536f1923c73c58 [135/140] wil6210: prefetch head of packet
> config: make ARCH=microblaze allyesconfig
> 
> All error/warnings:
> 
>    drivers/net/wireless/ath/wil6210/txrx.c: In function 'wil_vring_reap_rx':
> >> drivers/net/wireless/ath/wil6210/txrx.c:381:2: error: implicit declaration of function 'prefetch' [-Werror=implicit-function-declaration]
>      prefetch(skb->data);
>      ^
>    cc1: some warnings being treated as errors
> 
> vim +/prefetch +381 drivers/net/wireless/ath/wil6210/txrx.c
> 
>    375                  wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
>    376                  kfree_skb(skb);
>    377                  return NULL;
>    378          }
>    379          skb_trim(skb, dmalen);
>    380  
>  > 381          prefetch(skb->data);
>    382  
>    383          wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
>    384                            skb->data, skb_headlen(skb), false);
> 
> Vladimir Kondratiev (3):
>   wil6210: interrupt moderation
>   wil6210: Fix IP version indication for Tx csum offload
>   wil6210: prefetch head of packet
> 
>  drivers/net/wireless/ath/wil6210/interrupt.c | 13 +++++++++++++
>  drivers/net/wireless/ath/wil6210/txrx.c      |  8 ++++++--
>  drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 
> -- 
> 1.8.3.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
