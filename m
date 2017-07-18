Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:36211 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdGRKfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 06:35:07 -0400
Received: by mail-ua0-f169.google.com with SMTP id 35so18025545uax.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 03:35:07 -0700 (PDT)
From: Hante Meuleman <hante.meuleman@broadcom.com>
References: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
In-Reply-To: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
MIME-Version: 1.0
Date: Tue, 18 Jul 2017 12:35:05 +0200
Message-ID: <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com> (sfid-20170718_123512_339261_51330391)
Subject: RE: brcmfmac bus level addressing issues.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ian,

I've really no idea what you mean. Brcmf_pcie_select_core is redundant?
Care to try to boot a device without this function? Called all over the
place? Hell no, it is default pointing to PCIE2 and functions which need
to map the window to another core will do so, temporarily, but move it
back to PCIE2, at least that is the idea, may be you found a bug? We are
for sure not going to hide the selecting of the window in the read/write
routines, that would result in a giant amount of overhead. Currently PCIE
devices reach 1.5Gpbs, we need to go faster than that in the near future.
We don't want just change that to make it bit nicer..... Why do you need
to see the same in the SDIO and PCIE drivers? SDIO and PCIE differ in many
aspects. Sure some things can be improved in or the other, but they sure
don't need to look alike.

It may be ugly, but thusfar it has not caused bugs (and there won't be
large changes in the near future where it will cause bugs). The concept in
pcie bus part is simple. The main core to select is PCIE2 (once you have
booted and established initial communication with firmware) and every
routine which needs to access another core will change the window
temporarily and set it back once done. Please don't mess with this, it
works, it is clear and it is fast.

Regards,
Hante

-----Original Message-----
From: Ian Molton [mailto:ian@mnementh.co.uk]
Sent: Tuesday, July 18, 2017 11:45 AM
To: linux-wireless@vger.kernel.org
Cc: Arend Van Spriel; Franky Lin; Hante Meuleman
Subject: RFC: brcmfmac bus level addressing issues.

Hi folks,

Its come to my attention that there is a substantial disparity between the
PCIe and SDIO variants of the driver when it comes to handlign writes via
the backplane.

The SDIO bus code checks, upon every (32 bit) access, wether the backplane
window is in the right place, and only updates it if it has actually
changed.

The PCIe code sets the window *regardless* of wether its changed, on
*every single* write.

The SDIO code has no explicit selection of the window address based on the
core selected.

The PCIe code uses brcmf_pcie_select_core(), which, ultimately, appears to
be totally redundant, due to the above mentioned 32 bit access code
setting the window register regardless of its current value.

------------------------------------

Can we standardise how this is supposed to work? Its ugly, and its going
to cause bugs, ultimately. I suspect its probably the cause of the code I
mentioned in my recent patch titled "brcmfmac: HACK - stabilise the value
of ->sbwad in use for some xfer routines."

We really *dont* want to call brcmf_pcie_select_core() all over the place.
Its inefficient, traversing a list as it does, when all it does is return
a pointer that never actually changes, to the core structures that contain
addressing info.

I'd propose we do what I've done in my SDIO patch set - we call
brcmf_chip_get_core() *once* after the chip has been probed, and store the
pointer returned.

The window register setting can be hidden in the read32/write32 buscore
ops, and will never be incorrect from that point, and the code can simply
use a flat address space model. A single if() has got to be less costly
than writing the register on overy single read32/write32...

Anyhow, whatever we decide to do, can we do the same thing in both bus
drivers?

-Ian
