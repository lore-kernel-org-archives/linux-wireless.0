Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f191.google.com ([209.85.211.191]:36578 "EHLO
	mail-yw0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZHLStH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:49:07 -0400
Received: by ywh29 with SMTP id 29so298328ywh.33
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 11:49:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A83064A.2080609@gmail.com>
References: <1250096290-11058-1-git-send-email-lrodriguez@atheros.com>
	<4A83064A.2080609@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 12 Aug 2009 11:48:45 -0700
Message-ID: <43e72e890908121148l2cde20a9xb2c045e03574ffaa@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath5k: fix requested allocated RX skb size
	for DMA
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 11:13 AM, Jiri Slaby<jirislaby@gmail.com> wrote:
> On 08/12/2009 06:58 PM, Luis R. Rodriguez wrote:
>> --- a/drivers/net/wireless/ath/ath5k/base.c
>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>> @@ -1157,17 +1157,18 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
>>        * fake physical layer header at the start.
>>        */
>>       skb = ath_rxbuf_alloc(&sc->common,
>> -                           sc->rxbufsize + sc->common.cachelsz - 1,
>
> What was the exact purpose of this? My guess is that we should map
> starting at a next cache line boundary and put this aligned address to
> the device instead?

I've heard two theories:

1) AR5210 *required* it otherwise bad we would get bad data
2) Performance considerations

I've tried checking internally but haven't found out yet the exact
answer and this seems purely historical. I poked Sam Leffler to see if
he recalls. But as we the 0x41 reset which I removed it seems to be
best to leave unless we can be 100% sure we can remove this.

  Luis
