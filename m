Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36584 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbbHSORr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 10:17:47 -0400
Message-ID: <1439993864.6610.11.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150819_161752_502639_DF450CC7)
Subject: Re: [RFC v2 1/3] iwlwifi: mvm: add real TSO implementation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, ido@wizery.com,
	netdev@vger.kernel.org
Date: Wed, 19 Aug 2015 07:17:44 -0700
In-Reply-To: <1439989181-4444-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439989181-4444-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-19 at 15:59 +0300, Emmanuel Grumbach wrote:
> The segmentation is done completely in software. The
> driver creates several MPDUs out of a single large send.
> Each MPDU is a newly allocated SKB.
> A page is allocated to create the headers that need to be
> duplicated (SNAP / IP / TCP). The WiFi header is in the
> header of the newly created SKBs.
> 
> type=feature
> 
> Change-Id: I238ffa79cacc5bbdacdfbf3e9673c8d4f02b462a
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/mvm/tx.c | 513 +++++++++++++++++++++++++++++++---
>  1 file changed, 481 insertions(+), 32 deletions(-)

Ouch dynamic allocations while doing xmit are certainly not needed.
Your driver should pre-allocated space for headers.

Drivers willing to implement tso have to use net/core/tso.c provided
helpers.

$ git grep -n tso_build_hdr
drivers/net/ethernet/cavium/thunder/nicvf_queues.c:1030:                tso_build_hdr(skb, hdr, &tso, data_left, total_len == 0);
drivers/net/ethernet/freescale/fec_main.c:729:          tso_build_hdr(skb, hdr, &tso, data_left, total_len == 0);
drivers/net/ethernet/marvell/mv643xx_eth.c:842:         tso_build_hdr(skb, hdr, &tso, data_left, total_len == 0);
drivers/net/ethernet/marvell/mvneta.c:1650:             tso_build_hdr(skb, hdr, &tso, data_left, total_len == 0);
include/net/tso.h:15:void tso_build_hdr(struct sk_buff *skb, char *hdr, struct tso_t *tso,
net/core/tso.c:14:void tso_build_hdr(struct sk_buff *skb, char *hdr, struct tso_t *tso,
net/core/tso.c:37:EXPORT_SYMBOL(tso_build_hdr);


