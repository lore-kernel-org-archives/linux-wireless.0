Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:41968 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbeDJSLK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 14:11:10 -0400
Received: by mail-qt0-f175.google.com with SMTP id d3so14310574qth.8
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 11:11:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180410174245.1116-1-daniel@zonque.org>
References: <20180410174245.1116-1-daniel@zonque.org>
From: Ramon Fried <ramon.fried@linaro.org>
Date: Tue, 10 Apr 2018 21:11:08 +0300
Message-ID: <CAODu4Nqj3VTnz999_t9w1krDsUJua0YeMSXq48O2WfkL-KN=hw@mail.gmail.com> (sfid-20180410_201113_802083_18B562A4)
Subject: Re: [PATCH 0/1] RFC: memory coherency and data races on TX path
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        kvalo@codeaurora.org, Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2018 at 20:42, Daniel Mack <daniel@zonque.org> wrote:
> I found something that I believe might be an issue, and I have an
> idea on how to correct this, but unfortunately, this doesn't solve
> the issues I occasionally see with this driver. I'd still like to
> share it, because I might be totally mistaken in my understanding.
>
Thanks for sharing you idea. Are you aware of the recent patch I sent
that Loic Poulain
wrote that fixes a race issue in access to wcn36xx_dxe_tx_frame()  ?
Kalle just recently applied it to ath-next, I don't think it's
available yet upstream.
The patch was fixing something similar, perhaps it will solve the
issue you're experiencing.

> With no firmware code or documentation at hand, it's not exactly clear
> which assumption the firmware makes, but obviously, the driver and the
> firmware share memory to exchange descriptors that either contain
> control information or payload. The driver puts control descriptors
> and payload descriptors in a ring buffer in an interleaved fashion.
>
> When the driver wants to send an skb, it looks for a currently unused
> control descriptor, and then fills it, together with its directly
> chained payload descriptor. The descriptors are both marked valid and
> then the firmware is instructed to start processing the ringbuffer.
> In case the firmware is idle when wcn36xx_dxe_tx_frame() is entered,
> this is all fine. However, when sending many packets in a short time
> frame, there are cases when the firmware is still processing the ring
> buffer (iow, ch->reg_ctrl & WCN36xx_DXE_CH_CTRL_EN != 0), and in this
> case, writes to the shared memory area depict a data race. The local
> spinlock of course doesn't help to prevent that. OTOH, it should be
> completely fine to modify the descriptors while firmware is still
> reading them, as the firmware should only pay attention to such that
> are marked valid.
>
> There's a problem with the latter presumption however which looks like
> this in the driver code:
>
>         desc->fr_len = ctl->skb->len;
>         /* set dxe descriptor to VALID */
>         desc->ctrl = ch->ctrl_skb;
>
The firmware won't start reading the descriptors until it receives an
interrupt from driver.
which in turn happen later in the function using: wcn36xx_dxe_write_register()
so I don't think reordering in this case make any problem.

> The CPU may very well reorder the two writes, even though the memory is
> allocated as coherent DMA. When that happens, the firmware may see a
> wrong length for a valid descriptor. A simple memory write barrier would
> suffice to solve this, but then again, there are two descriptors
> involved.
>
> My attempt to fix that restructures the code a bit and makes the
> payload descriptor valid first and then the control descriptor, both
> strongly ordered through memory fences. This however assumes that the
> firmware will ignore valid payload descriptors unless they have a
> valid control descriptor preceding them, but that's really just
> guessing.
>
> Does that make sense? As I said, I can't really say this improves
> anything, sadly, so I might be mistaken entirely. But I'll leave this
> here for further discussion. Ideally, somebody with access to the
> firmware sources could give an assessment whether this is an issue at
> all or not.
When I'm not sure regarding some implementation I consult with the
downstream pronto driver.
https://github.com/sultanqasim/qcom_wlan_prima

Did you look there if they actually placed wmb() ?

>
>
> Thanks,
> Daniel
>
>
> Daniel Mack (1):
>   wcn36xx: fix buffer commit logic on TX path
>
>  drivers/net/wireless/ath/wcn36xx/dxe.c | 75 +++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 37 deletions(-)
>
> --
> 2.14.3
>
