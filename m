Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:51419 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZHLVID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 17:08:03 -0400
Received: by vws2 with SMTP id 2so291447vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 14:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908121148l2cde20a9xb2c045e03574ffaa@mail.gmail.com>
References: <1250096290-11058-1-git-send-email-lrodriguez@atheros.com>
	 <4A83064A.2080609@gmail.com>
	 <43e72e890908121148l2cde20a9xb2c045e03574ffaa@mail.gmail.com>
Date: Wed, 12 Aug 2009 17:08:03 -0400
Message-ID: <b6c5339f0908121408q4f3382e3rabd4def2de14c56c@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath5k: fix requested allocated RX skb size
	for DMA
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 2:48 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> On Wed, Aug 12, 2009 at 11:13 AM, Jiri Slaby<jirislaby@gmail.com> wrote:
>> What was the exact purpose of this? My guess is that we should map
>> starting at a next cache line boundary and put this aligned address to
>> the device instead?
>
> I've heard two theories:
>
> 1) AR5210 *required* it otherwise bad we would get bad data
> 2) Performance considerations

>From what I can tell Jiri has the right guess:

  // ?? nice pointer arithmetic... should use PTR_ALIGN here?
  off = ((unsigned long) skb->data) % sc->cachelsz;
  if (off != 0)
      skb_reserve(skb, sc->cachelsz);

in other words, when we allocate, round up to the next cache line
greater than IEEE80211_MAX_LEN, then add an extra cache_line-1
bytes so we can map starting from it.

dev_alloc_skb already does some padding and alignment, and it's
configurable on a per-arch basis (though looks like only powerpc
sets it to L1 cache size, everywhere else it's 32 bytes.)

I guess if someone is bored some benchmarking would be useful.

-- 
Bob Copeland %% www.bobcopeland.com
