Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36737 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3BGHzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 02:55:23 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so6022033wib.7
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 23:55:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <F4F751F96C54D346898D4C77E196E3DB0A4C5E25@telegweb.telechips.com>
References: <F4F751F96C54D346898D4C77E196E3DB0A4C5E25@telegweb.telechips.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Feb 2013 13:25:02 +0530
Message-ID: <CABPxzY+WY3xO_BVP9YkpM1pV=3kZvBvXQh5scb75P-BqbGcZGQ@mail.gmail.com> (sfid-20130207_085529_929616_153339FE)
Subject: Re: Question: how can i applay IP/TCP/UDP checksum offload H/W Engine
 to our softmac driver on mac80211 ?
To: =?UTF-8?B?6riw7IOB7JuQIChTVyBLaSk=?= <oprsystem@telechips.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 7, 2013 at 12:11 PM, 기상원 (SW Ki) <oprsystem@telechips.com> wrote:
> hello everyone.
>
> i would like to use our hardware TCP/IP Checksum logic on the mac80211 driver.
> but, i can see the IP Checksum in Tx skb_buffer on mac80211 tx handler after "g_ieee80211_hw->netdev_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM;"
>
> you can find the IP checksum value that is 0x26, 0x42.
> [   40.970000]  queue_skb: IP protocol: 0x00000008
> 0xC042382E: 88 01 00 00 00 50 43 21 22 2B 00 01 02 03 04 05  .....PC!"+......
> 0xC042392E: 00 19 B9 79 2D 7E 90 00 00 00 AA AA 03 00 00 00  ...y-~..........
> 0xC0423A2E: 08 00 45 00 00 54 00 00 40 00 40 01 [26 42] 0A 00  ..E..T..@.@.&B..
> 0xC0423B2E: 00 04 0A 00 00 64 08 00 CB C5 CB 02 00 01 F0 33  .....d.........3
> 0xC0423C2E: 71 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00  q...............
> 0xC0423D2E: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 0xC0423E2E: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 0xC0423F2E: 00 00 00 00 00 00
>
> how can I remove the IP checksum field calculation by software generation on mac80211 stack?
>
> thanks & best regards
> Sangwon, Ki
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


The TCP/IP checksum is calcualted by linux network stack. It does the
below check and decides to go for checksum or not.
skb->ip_summed= CHECKSUM_UNNECESSARY will disable the checksum
calculation by linux stack.

Your HW can appends its own checksum. Good detailed info on
http://www.mail-archive.com/netdev@vger.kernel.org/msg17044.html


==============
static inline int skb_csum_unnecessary(const struct sk_buff *skb)
{
        return skb->ip_summed & CHECKSUM_UNNECESSARY;
}
