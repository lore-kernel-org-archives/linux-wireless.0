Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32868 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750744AbcL1H1Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 02:27:25 -0500
Message-ID: <1482910035.8602.3.camel@coelho.fi> (sfid-20161228_082749_758370_778F06C8)
From: Luca Coelho <luca@coelho.fi>
To: Peter Xu <peterx@redhat.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Date: Wed, 28 Dec 2016 09:27:15 +0200
In-Reply-To: <20161228035959.GB3924@pxdev.xzpeter.org>
References: <20161227091706.GA20895@pxdev.xzpeter.org>
         <871swtkvdc.fsf@purkki.adurom.net>
         <20161228035959.GB3924@pxdev.xzpeter.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Intel Wireless 7260 failed to work
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-12-28 at 11:59 +0800, Peter Xu wrote:
> On Tue, Dec 27, 2016 at 09:46:55PM +0200, Kalle Valo wrote:
> > Peter Xu <peterx@redhat.com> writes:
> > 
> > > Looks like latest Linux master (4.10-rc1, 7ce7d89f) cannot work well
> > > with my wireless card, which is:
> > > 
> > >   Intel Corporation Wireless 7260 (rev bb)
> > > 
> > > Boot message shows that no suitable firmware found:
> > > 
> > >     # journalctl -kp3
> > >     Dec 27 16:38:00 kernel: Error parsing PCC subspaces from PCCT
> > >     Dec 27 16:38:00 kernel: mmc0: Unknown controller version (3). You may experience problems.
> > >     Dec 27 16:38:02 kernel: DMAR: DRHD: handling fault status reg 2
> > >     Dec 27 16:38:02 kernel: DMAR: [DMA Write] Request device [00:02.0] fault addr 7200000000 [fault reason 05] PTE Write a
> > >     Dec 27 16:38:03 kernel: tpm tpm0: A TPM error (6) occurred attempting to read a pcr value
> > >     Dec 27 16:38:04 kernel: iwlwifi 0000:03:00.0: no suitable firmware found!
> > > 
> > > Linux stable/master (Linux 4.8-rc8, 08895a8b6b) works for me. And no
> > > further tests have been done yet.
> > > 
> > > Is this a known issue? Please let me know if anyone wants more info or
> > > logs, since this error triggers easily (everytime I boot).
> > 
> > The error message isn't really telling much to the user (hint hint) but
> > I suspect this is by design:
> > 
> > "iwlwifi: remove support for fw older than -17 and -22

Right, we only maintain support for a certain number of firmware
versions.  The FW APIs change with time and we don't want to keep all
legacy code supporting old firmwares in the driver forever.

I agree that "no suitable firmware found!" is a bit scarce.  I'll see
if we can improve that with something: "no suitable firmware found! You
need iwlwifi-7260-17.ucode (<link to git>)".


> > FW versions older than -17 for 3160 and 7260 and older than -22 for
> > newer NICs are not supported anymore.  Don't load these versions
> > and remove code that handles them."
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4b87e5af638b6056bd6c20b0954d09a5a58633be
> > 
> > Adding luca.
> 
> Thanks for the triage.
> 
> Larry's link for -17 firmware solved my issue. Though I still don't
> know whether it is too aggresive if we just remove the support for -16
> (which is the one I was using with the old 4.6 kernel, btw I am using
> Fedora 24, which is relatively new as well).

I don't think we are very aggressive, we have been supporting -17 since
v4.3:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5865f3658ba37c54e346b0fdee08a1c7a152681b

And we have published the firmware about half a year ago:

http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/iwlwifi-7260-17.ucode?id=f2cf4d67e8eced29c8a473d3a27057aa2df57c42

I understand your concern, but if you want to be on the bleeding-edge
kernel, you should be on the bleeding-edge linux-firmware as well. ;)

But as I said, I'll try to improve the error message, as that should
make it easier to figure out.

--
Cheers,
Luca.
