Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51146 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbcL1MN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 07:13:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Peter Xu <peterx@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Intel Wireless 7260 failed to work
References: <20161227091706.GA20895@pxdev.xzpeter.org>
        <871swtkvdc.fsf@purkki.adurom.net>
        <20161228035959.GB3924@pxdev.xzpeter.org>
        <1482910035.8602.3.camel@coelho.fi>
Date: Wed, 28 Dec 2016 14:13:53 +0200
In-Reply-To: <1482910035.8602.3.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 28 Dec 2016 09:27:15 +0200")
Message-ID: <87eg0smeta.fsf@kamboji.qca.qualcomm.com> (sfid-20161228_131420_841650_3577FF70)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Wed, 2016-12-28 at 11:59 +0800, Peter Xu wrote:
>> On Tue, Dec 27, 2016 at 09:46:55PM +0200, Kalle Valo wrote:
>> > Peter Xu <peterx@redhat.com> writes:
>> > 
>> > > Looks like latest Linux master (4.10-rc1, 7ce7d89f) cannot work well
>> > > with my wireless card, which is:
>> > > 
>> > >   Intel Corporation Wireless 7260 (rev bb)
>> > > 
>> > > Boot message shows that no suitable firmware found:
>> > > 
>> > >     # journalctl -kp3
>> > >     Dec 27 16:38:00 kernel: Error parsing PCC subspaces from PCCT
>> > >     Dec 27 16:38:00 kernel: mmc0: Unknown controller version (3). You may experience problems.
>> > >     Dec 27 16:38:02 kernel: DMAR: DRHD: handling fault status reg 2
>> > >     Dec 27 16:38:02 kernel: DMAR: [DMA Write] Request device [00:02.0] fault addr 7200000000 [fault reason 05] PTE Write a
>> > >     Dec 27 16:38:03 kernel: tpm tpm0: A TPM error (6) occurred attempting to read a pcr value
>> > >     Dec 27 16:38:04 kernel: iwlwifi 0000:03:00.0: no suitable firmware found!
>> > > 
>> > > Linux stable/master (Linux 4.8-rc8, 08895a8b6b) works for me. And no
>> > > further tests have been done yet.
>> > > 
>> > > Is this a known issue? Please let me know if anyone wants more info or
>> > > logs, since this error triggers easily (everytime I boot).
>> > 
>> > The error message isn't really telling much to the user (hint hint) but
>> > I suspect this is by design:
>> > 
>> > "iwlwifi: remove support for fw older than -17 and -22
>
> Right, we only maintain support for a certain number of firmware
> versions.  The FW APIs change with time and we don't want to keep all
> legacy code supporting old firmwares in the driver forever.
>
> I agree that "no suitable firmware found!" is a bit scarce.  I'll see
> if we can improve that with something: "no suitable firmware found! You
> need iwlwifi-7260-17.ucode (<link to git>)".

Yeah, something like that would be much more helpful for the user.

-- 
Kalle Valo
