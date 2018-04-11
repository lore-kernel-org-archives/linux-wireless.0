Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:39352 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752445AbeDKG6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 02:58:44 -0400
Subject: Re: [PATCH] wcn36xx: use READ_ONCE() to access desc->ctrl
To: Ramon Fried <ramon.fried@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        kvalo@codeaurora.org, Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20180410173558.32425-1-daniel@zonque.org>
 <CAODu4NpGnT_j5jWgCrNKFxetJSbgKKvp0LzNZdhZJB68s48JgQ@mail.gmail.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <2159d172-52a3-ebd5-4dac-4cb5f71a6474@zonque.org> (sfid-20180411_085848_316788_4479953D)
Date: Wed, 11 Apr 2018 08:58:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAODu4NpGnT_j5jWgCrNKFxetJSbgKKvp0LzNZdhZJB68s48JgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 10, 2018 08:17 PM, Ramon Fried wrote:
> On 10 April 2018 at 20:35, Daniel Mack <daniel@zonque.org> wrote:
>> When accessing shared memory to check for the stat of submitted
>> descriptors, make sure to use READ_ONCE(). This will guarantee the
>> compiler treats these memory locations as volatile and doesn't apply
>> any caching.
>
> The structure that is tested is not shared memory. It's accessed only
> by the apps processor.

Hmm? ctl->desc is of type struct wcn36xx_dxe_desc, which is packed and
shared with the firmware. The WCN36xx_DXE_CTRL_VLD bit in ctrl bitfield
is set by the firmware when a frame is valid, and before asserting the
RX interrupt. So the host CPU must treat it as volatile and expect it to
change.

Am I reading this wrong?


Thanks,
Daniel
