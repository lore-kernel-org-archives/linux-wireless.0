Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52942 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3HSNUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 09:20:40 -0400
Received: by mail-wi0-f173.google.com with SMTP id en1so1833006wid.6
        for <linux-wireless@vger.kernel.org>; Mon, 19 Aug 2013 06:20:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376917878-25094-4-git-send-email-juhosg@openwrt.org>
References: <1376917878-25094-1-git-send-email-juhosg@openwrt.org>
	<1376917878-25094-4-git-send-email-juhosg@openwrt.org>
Date: Mon, 19 Aug 2013 15:20:39 +0200
Message-ID: <CAGXE3d-q3-HNtdp5jq94nCcLzCW1-oO+HTt+=yOFEE+fL8kbtA@mail.gmail.com> (sfid-20130819_152043_750655_7F8CCB04)
Subject: Re: [PATCH v2 3/6] rt2x00: rt2800: serialize shared memory access
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor,

On Mon, Aug 19, 2013 at 3:11 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The shared memory of the rt2800 devices is accessible
> through the register offset range between 0x4000 and
> 0x8000. The size of this range is 16KB only and on
> devices which have more than 16KB of shared memory either
> the low or the high part of the memory is accessible at a
> time.
>

> Serialize all accesses to the shared memory by a mutex,
> in order to avoid concurrent use of that.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---

[...]


> @@ -993,8 +1001,11 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>         }
>
>         beacon_base = HW_BEACON_BASE(entry->entry_idx);
> +
> +       rt2800_shared_mem_lock(rt2x00dev);
>         rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>                                    entry->skb->len + padding_len);
> +       rt2800_shared_mem_unlock(rt2x00dev);
>
>         /*
>          * Enable beaconing again.

Beacons on PCI devices are updated from pre_tbtt or beacon_done tasklet.
Looks like this will fail for pci then ...

Helmut
