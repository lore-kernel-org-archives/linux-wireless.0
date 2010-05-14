Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:49806 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0ENQEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 12:04:55 -0400
Received: by pxi5 with SMTP id 5so1408479pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 09:04:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100514074833.10333.81592.stgit@tt-desk>
References: <20100514074833.10333.81592.stgit@tt-desk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 14 May 2010 09:04:34 -0700
Message-ID: <AANLkTik2XPwhtUkDo7gfJTVI401HG6qU_mYvGmKfEbG5@mail.gmail.com>
Subject: Re: [PATCH] ath5k: consistently use rx_bufsize for RX DMA
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	bob@bobcopeland.com, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 14, 2010 at 12:50 AM, Bruno Randolf <br1@einfach.org> wrote:
> We should use the same buffer size we set up for DMA also in the hardware
> descriptor. Previously we used common->rx_bufsize for setting up the DMA
> mapping, but skb_tailroom(skb) for the size we tell to the hardware in the
> descriptor itself. The problem is that skb_tailroom(skb) can give us a larger
> value than the size we set up for DMA before: In my case rx_bufsize is 2528,
> and we allocated an skb of 2559 bytes length, including padding for cache
> alignment, but sbk_tailroom() was 2592. Just consistently use rx_bufsize for
> all RX DMA memory sizes.
>
> Also check the return value of setup function.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Cc: stable?

Is that other bug reproducible, can the user test this to cure it?

  Luis
