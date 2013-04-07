Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59726 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934442Ab3DGWeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:34:36 -0400
Message-ID: <5161F476.5090304@openwrt.org> (sfid-20130408_003440_241006_CFF394D1)
Date: Mon, 08 Apr 2013 00:34:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 5/7] ath9k: fix handling of broken descriptors
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org> <1365372253-32782-2-git-send-email-nbd@openwrt.org> <1365372253-32782-3-git-send-email-nbd@openwrt.org> <1365372253-32782-4-git-send-email-nbd@openwrt.org> <1365372253-32782-5-git-send-email-nbd@openwrt.org> <CAJ-Vmo=6W_C0d_wEeT8UM1+1LXOsi5xHGj=KdKF7E5BNdtLbgQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=6W_C0d_wEeT8UM1+1LXOsi5xHGj=KdKF7E5BNdtLbgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-08 12:24 AM, Adrian Chadd wrote:
> Hm!
> 
> On 7 April 2013 15:04, Felix Fietkau <nbd@openwrt.org> wrote:
>> As the comment in ath_get_next_rx_buf indicates, if a descriptor with
>> the done bit set follows one with the done bit cleared, both descriptors
>> should be discarded, however the driver is not doing that yet.
>>
>> To fix this, use the rs->rs_more flag as an indicator that the following
>> frame should be discarded. This also helps with the split buffer case:
>> if the first part of the frame is discarded, the following parts need to
>> be discarded as well, since they contain no valid header or usable data.
> 
> Have you seen this happen?
> 
> I've added code to this in FreeBSD (based on the reference driver and
> ath9k doing it) and I've never, ever seen it trigger.
> 
> I went digging through the EV database and I found a bug (long since
> fixed) where the code was adjusting the skb size and then pushing it
> back onto the RX queue with an incorrect size. If it allocated a 2kiB
> SKU and then reset the size to 4KiB, hilarity would ensue.
> 
> This is why I'm asking. If it happens in the real world, fine. :-)
I didn't see the done bit related corruption, but I fixed the code so
that I could reuse it for the patch after it (which is based on real
world observations).

- Felix
