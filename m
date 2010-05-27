Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36173 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0E0DKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 23:10:55 -0400
Received: by pvg3 with SMTP id 3so1429636pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 20:10:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274926013-31968-1-git-send-email-vasanth@atheros.com>
References: <1274926013-31968-1-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 20:10:35 -0700
Message-ID: <AANLkTikgmkLklDfZUcHo4tQDqaXQcaaxt-HpPsoZmKU7@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix bug in the way "bf_tx_aborted" of struct
	ath_buf is used
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Felix Fietkau <Felix.Fietkau@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 7:06 PM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> This bug was introduced by the following commit
>
>        Author: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>        Date:   Thu Apr 15 17:38:46 2010 -0400
>
>        ath9k: Remove ATH9K_TX_SW_ABORTED and introduce a bool for this purpose
>
> Wrong buffer is checked for bf_tx_aborted field in ath_tx_num_badfrms(),
> this may result in a rate scaling with wrong feedback (number
> of unacked frames in this case). It is the last one in the chain
> of buffers for an aggregate frame that should be checked.
>
> Also it misses the initialization of this field in the buffer,
> this may lead to a situation where we stop the sw retransmission
> of failed subframes associated to this buffer.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---

FWIW, for those who want to test this, I've applied this patch into
the compat-wireless linux-next-pending/ directory.  I've also kicked
out a new linux-next based compat-wireless tarball with the
pending+crap patches applied and fixed today's new compile issue
introduced by:

    Author: Alexey Dobriyan <adobriyan@gmail.com>
    Date:   Mon May 24 14:33:03 2010 -0700

        kernel-wide: replace USHORT_MAX, SHORT_MAX and SHORT_MIN with
USHRT_MAX, SHRT_MAX and SHRT_MIN

        - C99 knows about USHRT_MAX/SHRT_MAX/SHRT_MIN, not
          USHORT_MAX/SHORT_MAX/SHORT_MIN.

        - Make SHRT_MIN of type s16, not int, for consistency.

        [akpm@linux-foundation.org: fix drivers/dma/timb_dma.c]
        [akpm@linux-foundation.org: fix security/keys/keyring.c]
        Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
        Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
        Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This fix required a simple patch on compat.git.

The "pc" compat-wireless tarball for today then is:

http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2010-05-26-pc.tar.bz2
sha1sum: 62937a3bec62cc564731b30295b44994504355cf

I've compile and load tested ath9k against 2.6.31-20-generic

  Luis
