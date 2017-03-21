Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47098 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755420AbdCUMPF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 08:15:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatja@google.com>
Subject: Re: [4/4] mwifiex: pcie: de-duplicate buffer allocation code
References: <20170311013924.73348-5-briannorris@chromium.org>
        <20170320170835.5ED1C609C6@smtp.codeaurora.org>
        <20170320200550.GA12143@google.com>
Date: Tue, 21 Mar 2017 14:14:05 +0200
In-Reply-To: <20170320200550.GA12143@google.com> (Brian Norris's message of
        "Mon, 20 Mar 2017 13:05:51 -0700")
Message-ID: <874lym7roy.fsf@kamboji.qca.qualcomm.com> (sfid-20170321_131531_747735_72EC1378)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> On Mon, Mar 20, 2017 at 05:08:35PM +0000, Kalle Valo wrote:
>> Brian Norris <briannorris@chromium.org> wrote:
>> > This code was duplicated as part of the PCIe FLR code added to this
>> > driver. Let's de-duplicate it to:
>> > 
>> >  * make things easier to read (mwifiex_pcie_free_buffers() now has a
>> >    corresponding mwifiex_pcie_alloc_buffers())
>> >  * reduce likelihood of bugs
>> >  * make error logging equally verbose
>> >  * save lines of code!
>> > 
>> > Also drop some of the commentary that isn't really needed.
>> > 
>> > Signed-off-by: Brian Norris <briannorris@chromium.org>
>> 
>> Failed to apply:
>> 
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/marvell/mwifiex/pcie.c).
>> error: could not build fake ancestor
>> Applying: mwifiex: pcie: de-duplicate buffer allocation code
>> Patch failed at 0001 mwifiex: pcie: de-duplicate buffer allocation code
>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>> 
>> Patch set to Changes Requested.
>
> This applies fine to your wireless-drivers/master branch for me, where
> patches 1-3 were applied. Are you applying this to
> wireless-drivers-next? It's quite understandable that patch 4 wouldn't
> apply there, as you've stripped out the previous patches...

I (wrongly) understood that patches 1-3 are for 4.11 and patch 4 is for
4.12, don't remember anymore how I got that impression. But I don't
think a cleanup patch like this is justified for 4.11 so I'm not
comfortable applying this to wireless-drivers (which should only contain
fixes to important bugs or regressions).

What I could do is to wait for the patches 1-3 trickle down to w-d-next
and then apply this patch. It usually takes few weeks, but with bad luck
it might happen only after the merge window. Would that work?

-- 
Kalle Valo
