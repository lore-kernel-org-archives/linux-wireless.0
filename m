Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:50486 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdGRJp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 05:45:28 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Subject: RFC: brcmfmac bus level addressing issues.
Message-ID: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk> (sfid-20170718_114532_889895_E7108656)
Date: Tue, 18 Jul 2017 10:45:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

Its come to my attention that there is a substantial disparity between
the PCIe and SDIO variants of the driver when it comes to handlign
writes via the backplane.

The SDIO bus code checks, upon every (32 bit) access, wether the
backplane window is in the right place, and only updates it if it has
actually changed.

The PCIe code sets the window *regardless* of wether its changed, on
*every single* write.

The SDIO code has no explicit selection of the window address based on
the core selected.

The PCIe code uses brcmf_pcie_select_core(), which, ultimately, appears
to be totally redundant, due to the above mentioned 32 bit access code
setting the window register regardless of its current value.

------------------------------------

Can we standardise how this is supposed to work? Its ugly, and its going
to cause bugs, ultimately. I suspect its probably the cause of the code
I mentioned in my recent patch titled "brcmfmac: HACK - stabilise the
value of ->sbwad in use for some xfer routines."

We really *dont* want to call brcmf_pcie_select_core() all over the
place. Its inefficient, traversing a list as it does, when all it does
is return a pointer that never actually changes, to the core structures
that contain addressing info.

I'd propose we do what I've done in my SDIO patch set - we call
brcmf_chip_get_core() *once* after the chip has been probed, and store
the pointer returned.

The window register setting can be hidden in the read32/write32 buscore
ops, and will never be incorrect from that point, and the code can
simply use a flat address space model. A single if() has got to be less
costly than writing the register on overy single read32/write32...

Anyhow, whatever we decide to do, can we do the same thing in both bus
drivers?

-Ian
