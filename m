Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34034 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbeDLBtl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 21:49:41 -0400
Received: by mail-qk0-f193.google.com with SMTP id g7so4372994qkm.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2018 18:49:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2159d172-52a3-ebd5-4dac-4cb5f71a6474@zonque.org>
References: <20180410173558.32425-1-daniel@zonque.org> <CAODu4NpGnT_j5jWgCrNKFxetJSbgKKvp0LzNZdhZJB68s48JgQ@mail.gmail.com>
 <2159d172-52a3-ebd5-4dac-4cb5f71a6474@zonque.org>
From: Ramon Fried <ramon.fried@linaro.org>
Date: Thu, 12 Apr 2018 04:49:40 +0300
Message-ID: <CAODu4NriCXRQz5e3KNRNF6PMvN8GWggR2af-Oot0npBpM2UEPQ@mail.gmail.com> (sfid-20180412_034945_409719_798C44C6)
Subject: Re: [PATCH] wcn36xx: use READ_ONCE() to access desc->ctrl
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        kvalo@codeaurora.org, Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2018 at 09:58, Daniel Mack <daniel@zonque.org> wrote:
> On Tuesday, April 10, 2018 08:17 PM, Ramon Fried wrote:
>> On 10 April 2018 at 20:35, Daniel Mack <daniel@zonque.org> wrote:
>>> When accessing shared memory to check for the stat of submitted
>>> descriptors, make sure to use READ_ONCE(). This will guarantee the
>>> compiler treats these memory locations as volatile and doesn't apply
>>> any caching.
>>
>> The structure that is tested is not shared memory. It's accessed only
>> by the apps processor.
>
> Hmm? ctl->desc is of type struct wcn36xx_dxe_desc, which is packed and
> shared with the firmware. The WCN36xx_DXE_CTRL_VLD bit in ctrl bitfield
> is set by the firmware when a frame is valid, and before asserting the
> RX interrupt. So the host CPU must treat it as volatile and expect it to
> change.
>
> Am I reading this wrong?
>
No, you're right. I missed that.
>
> Thanks,
> Daniel
