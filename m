Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:39298 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751841AbeDKGw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 02:52:29 -0400
Subject: Re: [PATCH 0/1] RFC: memory coherency and data races on TX path
To: Ramon Fried <ramon.fried@linaro.org>
Cc: wcn36xx@lists.infradead.org, Ramon Fried <rfried@codeaurora.org>,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20180410174245.1116-1-daniel@zonque.org>
 <CAODu4Nqj3VTnz999_t9w1krDsUJua0YeMSXq48O2WfkL-KN=hw@mail.gmail.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <7a33cb9e-d34f-433f-45f1-79d66c437fcb@zonque.org> (sfid-20180411_085233_232062_3A9DBCBD)
Date: Wed, 11 Apr 2018 08:52:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAODu4Nqj3VTnz999_t9w1krDsUJua0YeMSXq48O2WfkL-KN=hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ramon,

On Tuesday, April 10, 2018 08:11 PM, Ramon Fried wrote:
> On 10 April 2018 at 20:42, Daniel Mack <daniel@zonque.org> wrote:
>> I found something that I believe might be an issue, and I have an
>> idea on how to correct this, but unfortunately, this doesn't solve
>> the issues I occasionally see with this driver. I'd still like to
>> share it, because I might be totally mistaken in my understanding.
>
> Thanks for sharing you idea. Are you aware of the recent patch I sent
> that Loic Poulain
> wrote that fixes a race issue in access to wcn36xx_dxe_tx_frame()  ?
> Kalle just recently applied it to ath-next, I don't think it's
> available yet upstream.

Yes, my patch builds upon yours.

> The patch was fixing something similar, perhaps it will solve the
> issue you're experiencing.

I'm not even sure what kind of effect I'm hunting, so it's hard to tell.
Your patch definitely addresses a data race too though.

>> There's a problem with the latter presumption however which looks like
>> this in the driver code:
>>
>>         desc->fr_len = ctl->skb->len;
>>         /* set dxe descriptor to VALID */
>>         desc->ctrl = ch->ctrl_skb;
>
> The firmware won't start reading the descriptors until it receives an
> interrupt from driver.
> which in turn happen later in the function using: wcn36xx_dxe_write_register()
> so I don't think reordering in this case make any problem.

I understand, but as I said, there's definitely the problem that the
channel is already running when wcn36xx_dxe_tx_frame() is entered. Try
adding this at the beginning of the the function and then run iperf:

	int reg;
	wcn36xx_dxe_read_register(wcn, ch->reg_ctrl, &reg);
	WARN_ON(reg & WCN36xx_DXE_CH_CTRL_EN);

I fail to see how the firmware would determine which descriptors to look
at without any type of synchronization mechanism.

>> Does that make sense? As I said, I can't really say this improves
>> anything, sadly, so I might be mistaken entirely. But I'll leave this
>> here for further discussion. Ideally, somebody with access to the
>> firmware sources could give an assessment whether this is an issue at
>> all or not.
>
> When I'm not sure regarding some implementation I consult with the
> downstream pronto driver.
> https://github.com/sultanqasim/qcom_wlan_prima
> 
> Did you look there if they actually placed wmb() ?

Yes, I've read some of that as well. They use wmb() before writing to
and rmb() after reading firmware registers. The equivalent upstream is
wcn36xx_dxe_[read,write}_register(), and they use writel() and readl()
which have the same barriers on arm64. So that's fine.

What's interesting though is that the downstream drivers sets the VLD
bit of the first descriptor of the chain *after* they set all the
others. There are also some confusing comments about that (/* First
frame not set VAL bit, why ??? */). Can you make sense of that?


Thanks,
Daniel
