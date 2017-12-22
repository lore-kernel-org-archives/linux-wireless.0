Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34369 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdLVG2r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:28:47 -0500
Received: by mail-oi0-f41.google.com with SMTP id u193so18346681oie.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:28:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f5b539a5-5365-7a1d-101d-591b5face78a@gmail.com>
References: <f5b539a5-5365-7a1d-101d-591b5face78a@gmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 21 Dec 2017 22:28:46 -0800
Message-ID: <CAKxU2N_t2asjvfEmTtER-x6MBnUrWhxGZR9c-Nk0AfOG-woOKA@mail.gmail.com> (sfid-20171222_072851_191906_94749102)
Subject: Re: ath9k dropping connections
To: =?UTF-8?Q?Fl=C3=A1vio_Silveira?= <flavioguiraldo@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 21, 2017 at 4:12 PM, Fl=C3=A1vio Silveira
<flavioguiraldo@gmail.com> wrote:
> Good evening,
>
>   I have a wireless router running LEDE Reboot (SNAPSHOT, r5445-04127f0fe=
c),
> with kernel 4.9.65 and I'm seeing connections being dropped without any
> error in dmesg. To fix I have to restart wifi by issuing "wifi down; wifi
> up"
>
>   It was previously running OpenWrt Barrier Breaker and was presenting th=
e
> same issue, except it would give me an error similar to this one: "ath:
> phy0: Failed to stop TX DMA, queues=3D0x005!"
>
>From a quick glance at the code, it used to be implemented as ath_err.
It now seems to be implemented as ath_dbg. In other words, if you turn
on debugging, you should see it.
>   After doing some research it seems this error is related to environment
> interference and it was fixed in later kernel versions, the reason I gave
> LEDE a try. It makes sense, because this router worked wonderfully for at
> least a year before giving this issue.
>
>   The reason I am sending this e-mail is to receive suggestions on how ca=
n I
> debug it properly, because, as pointed above, dmesg shows no errors.
>
> Regards,
>   Flavio Silveira
