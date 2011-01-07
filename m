Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48615 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1AGCYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:24:52 -0500
Received: by wwi17 with SMTP id 17so41975wwi.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:24:51 -0800 (PST)
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
In-Reply-To: <AANLkTi=+F_O1_2c07zLEGVDSAkuA2_MwghwRQK9pHMN7@mail.gmail.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
	 <201101070205.00886.chunkeey@googlemail.com>
	 <1294363427.2704.23.camel@edumazet-laptop>
	 <AANLkTinQ42y9Tu=Ugb92-R+56BP4U+cDBzd4tQQCES1W@mail.gmail.com>
	 <1294366072.2704.32.camel@edumazet-laptop>
	 <AANLkTi=+F_O1_2c07zLEGVDSAkuA2_MwghwRQK9pHMN7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 03:24:40 +0100
Message-ID: <1294367080.2704.46.camel@edumazet-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le jeudi 06 janvier 2011 à 18:13 -0800, Luis R. Rodriguez a écrit :
> On Thu, Jan 6, 2011 at 6:07 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

> The only way to accept your patch is to use a debugfs option to
> disable it, we need AMSDU support enabled by default.
> 

I dont care of my patch ;)

There is a reason I felt it was not appropriate.

> > If the hardware needs 8192 bytes (or 16384) buffers to perform its
> > operation, it should not give them back to linux, because there is no
> > guarantee it can allocate fresh ones for the next frames.
> 
> Last I looked at this the issue was not the upper used by the driver
> but an issue of a roundoff by the kernel that ended up on *some*
> machines going a higher order. Not all machines use the higher order.
> I wondered at one point if using ksize() might help here too but
> again, this is a new API. Not sure how to fix it for older kernels.

common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN +
                              ah->caps.rx_status_len,
                              min(common->cachelsz, (u16)64));

Given IEEE80211_MAX_MPDU_LEN is more than 3840, and skb shinfo adds more
than 256 bytes, I can assert rx_bufsize is greater than 4096 : order-1
allocations at minimum.
ksize() wont help you.

Many net drivers perform a copy (r8169.c comes to mind, because of a
hardware flaw).



