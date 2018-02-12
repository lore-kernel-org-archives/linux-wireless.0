Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46326 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbeBLPIO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 10:08:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: James Hogan <jhogan@kernel.org>
Cc: Adric Blake <promarbler14@gmail.com>, m@bues.ch,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: B43 driver no longer works in Linux 4.15 (bisected)
References: <CAE1jjefE1qjgcHMik36Na0OYoFON+kCi5cEDSq=y11HdsyPn0Q@mail.gmail.com>
        <20180205183324.GD8479@saruman>
Date: Mon, 12 Feb 2018 17:08:10 +0200
In-Reply-To: <20180205183324.GD8479@saruman> (James Hogan's message of "Mon, 5
        Feb 2018 18:33:25 +0000")
Message-ID: <87sha68cv9.fsf@kamboji.qca.qualcomm.com> (sfid-20180212_160857_718390_6921A4CF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Hogan <jhogan@kernel.org> writes:

> Hi Adric,
>
> On Mon, Feb 05, 2018 at 01:23:31PM -0500, Adric Blake wrote:
>> In the time between Linux 4.15-rc8 and -rc9, my wireless driver, b43,
>> would no longer load automatically. When I modprobe the b43 (and ssb)
>> modules, the device still didn't appear in NetworkManager. Comparing
>> the kernel logs between working (4.14.16-lts) and nonworking (4.15)
>> kernels reveals that there is zero output from the ssb module, and no
>> devices recognized by the b43 driver:
>
> ...
>
>> I had my suspicions at this point, but I had a lull and decided to
>> bisect it anyways.
>> I bisected to this "first bad commit:"
>> 
>> commit 58eae1416b804d900014d84feadda7195007cc30
>> Author: James Hogan <jhogan@kernel.org>
>> Date:   Mon Jan 15 21:17:14 2018 +0000
>> 
>>     ssb: Disable PCI host for PCI_DRIVERS_GENERIC
>
> Yes, really sorry about that and thanks for going to the effort of
> bisecting. There is a patch here:
> https://patchwork.kernel.org/patch/10185397/
>
> which is applied to linux-next as commit
> a9e6d44ddeccd3522670e641f1ed9b068e746ff7, and is tagged for stable,
> though I've just noticed the stable email address is incorrect... I'll
> make sure it gets applied to the 4.15 stable branch though as soon as
> I notice its merged.

The commit is now in v4.16-rc1.

-- 
Kalle Valo
