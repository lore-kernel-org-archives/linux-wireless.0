Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrg3.ecu.edu.au ([139.230.225.75]:60185 "EHLO
	mailrg3.ecu.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1BJMIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 07:08:52 -0500
From: Sushil DUTT <s.dutt@ecu.edu.au>
To: "'Felix Fietkau'" <nbd@openwrt.org>,
	"greearb@candelatech.com" <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 10 Feb 2011 20:02:27 +0800
Subject: RE: [PATCH 2/2] mac80211: Set up tx-queue-mapping in
 subif_start_xmit.
Message-ID: <32CC77D56B9C2944A88AF25AB2E087F84481E8ACCB@XCHG-MS2.ads.ecu.edu.au>
References: <1297299951-25604-1-git-send-email-greearb@candelatech.com>
 <1297299951-25604-2-git-send-email-greearb@candelatech.com>
 <23538c71c3504e4885f42f007d03016f@SINPRD0102HT006.apcprd01.prod.exchangelabs.com>
In-Reply-To: <23538c71c3504e4885f42f007d03016f@SINPRD0102HT006.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

I can also see some mismatch in ath9k hardware queue and mac80211 queue definition.

I am not very much expert on openwrt as I just started working with openwrt couple of months back but I can trace that data is sent to ath9k hw queue(q= skb_get_queue_mapping()) which is equal to mac80211 queue. Now problem is that mac80211 & ath9k queue priorities are reverse e.g. mac80211_q=0(AC_VO) is highest priority and ath9k hardware queue_0 is init as AC_BE(i.e. lowest priority).

Your help is appreciated.

Kind Regards,
Sushil

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Felix Fietkau
Sent: Thursday, 10 February 2011 9:15 AM
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Set up tx-queue-mapping in subif_start_xmit.

On 2011-02-10 2:05 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Otherwise, ath9k gets confused about which queue to use
> and spews a warning like this when driving traffic with
> pktgen.
>
> WARNING: at drivers/net/wireless/ath/ath9k/xmit.c:1748 ath_tx_start+0x4a2/0x662 [ath9k]()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 nfs lockd bluetooth cryptd aes_i586 aes_generic veth 8021q garp stp l]
> Pid: 1729, comm: kpktgend_0 Tainted: G        W   2.6.38-rc4-wl+ #21
> Call Trace:
>  [<c043091b>] ? warn_slowpath_common+0x65/0x7a
>  [<fabe784e>] ? ath_tx_start+0x4a2/0x662 [ath9k]
>  [<c043093f>] ? warn_slowpath_null+0xf/0x13
>  [<fabe784e>] ? ath_tx_start+0x4a2/0x662 [ath9k]
>  [<fabe14d0>] ? ath9k_tx+0x14f/0x183 [ath9k]
>  [<fab9026d>] ? __ieee80211_tx+0x10c/0x18c [mac80211]
>  [<fab90397>] ? ieee80211_tx+0xaa/0x188 [mac80211]
>  [<fab905f3>] ? ieee80211_xmit+0x17e/0x186 [mac80211]
>  [<fab8ecc0>] ? ieee80211_skb_resize+0x8e/0xd2 [mac80211]
>  [<fab9148b>] ? ieee80211_subif_start_xmit+0x643/0x65c [mac80211]
>  [<c0440000>] ? rescuer_thread+0x25/0x1c8
>  [<f92cd354>] ? pktgen_thread_worker+0x114c/0x1b44 [pktgen]
>  [<fab90e48>] ? ieee80211_subif_start_xmit+0x0/0x65c [mac80211]
>  [<c042d612>] ? default_wake_function+0xb/0xd
>  [<c04254c7>] ? __wake_up_common+0x34/0x5c
>  [<c0443a29>] ? autoremove_wake_function+0x0/0x2f
>  [<f92cc208>] ? pktgen_thread_worker+0x0/0x1b44 [pktgen]
>  [<c044371a>] ? kthread+0x62/0x67
>  [<c04436b8>] ? kthread+0x0/0x67
>  [<c04035f6>] ? kernel_thread_helper+0x6/0x10
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> NOTE:  This needs review by someone who actually understands this code.
>
> :100644 100644 17ef4f4... 95eb4fa... M        net/mac80211/tx.c
>  net/mac80211/tx.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 17ef4f4..95eb4fa 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -2028,6 +2028,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>       } else
>               memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
>
> +     skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
I think this is wrong - it's up to the network stack to set up the queue
mapping. The bug you're looking for is probably in pktgen - I think
there was a similar issue in the bridge code at some point, which was
also fixed.

- Felix
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

This e-mail is confidential. If you are not the intended recipient you must not disclose or use the information contained within. If you have received it in error please return it to the sender via reply e-mail and delete any record of it from your system. The information contained within is not the opinion of Edith Cowan University in general and the University accepts no liability for the accuracy of the information provided.

CRICOS IPC 00279B
