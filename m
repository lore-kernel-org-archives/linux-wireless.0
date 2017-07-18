Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:33146 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdGRL1w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 07:27:52 -0400
Subject: Re: brcmfmac bus level addressing issues.
To: Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
References: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
 <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <5eb895bd-58cf-70fd-3c00-c8fed86aed79@mnementh.co.uk> (sfid-20170718_132755_514183_70A2C7C5)
Date: Tue, 18 Jul 2017 12:27:48 +0100
MIME-Version: 1.0
In-Reply-To: <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/07/17 11:35, Hante Meuleman wrote:
> Hi Ian,
> 
> I've really no idea what you mean.

You should look at the code...

> brcmf_pcie_select_core is redundant?

Essentially yes - there may be a couple of corner cases where the IO
accesses are not performed via brcmf_pcie_buscore_{read,write}32() - but
other than that, brcmf_pcie_buscore_prep_addr() sets the IO window
unconditionally on every access.

> Care to try to boot a device without this function?

I strongly suspect it would work. Perhaps try it? Give me a device and
I'll try it.

> Called all over the  place? Hell no, it is default pointing to PCIE2
> and functions which need to map the window to another core will do
> so, temporarily, but move it back to PCIE2, at least that is the
> idea, may be you found a bug?

brcmf_pcie_select_core() looks up the core structure from the core id.

it then sets BRCMF_PCIE_BAR0_WINDOW according to the core base address.

it actually goes to the length of reading it back and trying again if
its not set, even, which is at least a little bit horrifying.

------------

brcmf_pcie_buscore_{read,write}32() both call brcmf_pcie_buscore_prep_addr()

brcmf_pcie_buscore_prep_addr() *unconditionally* programs
BRCMF_PCIE_BAR0_WINDOW on *every single* IO access.

If you want inefficient - its right there.


The SDIO version of the code is actually considerably more efficient on
this point - it at least only programs the window register only when it
changes, not on every single IO access.

> We are
> for sure not going to hide the selecting of the window in the read/write
> routines, that would result in a giant amount of overhead.

Actually it would result in *considerably* less overhead than the
current code, that blindly sets the window on every access.

> Currently PCIE
> devices reach 1.5Gpbs, we need to go faster than that in the near future.

I dont need a lesson on writing efficient code, thanks.

> We don't want just change that to make it bit nicer..... Why do you need
> to see the same in the SDIO and PCIE drivers? SDIO and PCIE differ in many
> aspects. Sure some things can be improved in or the other, but they sure
> don't need to look alike.

I dont "need" to see the same in both drivers. Not where it isnt
appropriate.

but every part of the drivers that can share code without noticeably
impacting performance *should* do so. You should be justifying to me why
the code has to be different, not the other way around. Are you
sreiously arguing that sharing common code is a bad idea?

> It may be ugly, but thusfar it has not caused bugs

Oh, I bet you it has... try reading the SDIO version (note the reliance
on the dangling ->sbwad pointer) and tell me again that this hasnt
caused bugs.

Right now, the bulk of the driver code is sat on top of at least two bus
drivers with differing IO models, and is working via good luck alone.

> The concept in pcie bus part is simple.

And differs completely from the SDIO part.

> The main core to select is PCIE2 (once you have
> booted and established initial communication with firmware) and every
> routine which needs to access another core will change the window
> temporarily and set it back once done. Please don't mess with this, it
> works, it is clear and it is fast.

If is anything but fast. changing the window involves traversiong the
list of cores. Every. Single. Time. It doesnt *have* to - but thats what
brcmf_chip_get_core() does, and brcmf_pcie_select_core() calls it.
