Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:38907 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752665AbeA2WIF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 17:08:05 -0500
Received: by mail-io0-f193.google.com with SMTP id d13so9304674iog.5
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jan 2018 14:08:05 -0800 (PST)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id r13sm4705887ioa.4.2018.01.29.14.08.03
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jan 2018 14:08:03 -0800 (PST)
Received: by mail-io0-f175.google.com with SMTP id d13so9304603iog.5
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jan 2018 14:08:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <25201a91958e4b408b14c4125433b305@SC-EXCH02.marvell.com>
References: <1516633497-6584-3-git-send-email-gbhat@marvell.com>
 <20180125071202.0F39560A60@smtp.codeaurora.org> <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
 <20180125183355.rpmajajr5exxcybb@ban.mtv.corp.google.com> <25201a91958e4b408b14c4125433b305@SC-EXCH02.marvell.com>
From: Brian Norris <briannorris@chromium.org>
Date: Mon, 29 Jan 2018 14:08:02 -0800
Message-ID: <CA+ASDXPkrVgsRH--ETzMNXRQeu-akGn8hZVYT=YpG+5ZpggMTQ@mail.gmail.com> (sfid-20180129_230820_329580_732EFED2)
Subject: Re: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX stall
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Jan 28, 2018 at 11:19 PM, Ganapathi Bhat <gbhat@marvell.com> wrote:
>> From: Ganapathi Bhat
>> > From: Brian Norris [mailto:briannorris@chromium.org]
>> > On Thu, Jan 25, 2018 at 09:59:04AM +0000, Ganapathi Bhat wrote:
>> > > > I can't find any commit with id c7dbdcb2a4e1, is it correct?
>> > > Correct. Actually the commit id c7dbdcb2a4e1 is the PATCH [1/2] sent
>> > > in this
>> > series.
>> >
>> > What? Why would you introduce a bug and only fix it in the next patch?
>> With the first patch the original issue took considerably longer time to
>> recreate. Also it followed a different path to get recreated(shared in commit
>> message).
>> > Does that mean you should just combine the two?
>> Let us know if that is fine to merge them. We can modify the commit
>> message accordingly.
>> > Or reverse the order, if patch 2 doesn't cause problems on its own?
>> Patch 2 has a dependency on patch 1.
> One correction. There is no commit dependency between patch 1 and 2(they can be applied in any order). But the result would be same. We need both fixes. Let us know if we can combine them.

I haven't closely looked at patch 2 yet. My only statement was that it
makes no sense to have 2 commits, with the second one labeled as
"Fixing" the first one. From your descriptions, it sounds like patch 2
should actually come first, but I'm not really sure. I only looked far
enough to say that I didn't like patch 1 as-is :)

Brian
