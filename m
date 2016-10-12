Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2653 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755496AbcJLPBP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 11:01:15 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Move generic entries below specific ones in
 ath_pci_id_table.
Date: Wed, 12 Oct 2016 15:01:08 +0000
Message-ID: <877f9dehn0.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_170217_343401_BE455866)
References: <ath9k-patch-20161003@vittgam.net>
        <87k2dop15n.fsf@kamboji.qca.qualcomm.com>
        <cd3ff141b0ba69399a377a96a9ae75fb@vittgam.net>
        <87eg3lg07d.fsf@kamboji.qca.qualcomm.com>
        <6ae887d799b201d78b4474ab9bbf6917@vittgam.net>
In-Reply-To: <6ae887d799b201d78b4474ab9bbf6917@vittgam.net> (Vittorio
        Gambaletta's message of "Wed, 12 Oct 2016 16:13:38 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net> writes:

>>> So, after seeing that the rest of the file is sorted this way (generic
>>> section after the specific ones), I concluded that the 0x002A sorting
>>> was wrong in the first place, and so is 0x0029. Then I sent this patch
>>> to fix this.
>>
>> I can't see how changing the order in ath_pci_id_table[] would make any
>> difference in functionality, but I might be missing something.
>
> It does: I've looked through the relevant code, and found that PCI device
> matching from that table is done sequentially in pci_match_id() from
> drivers/pci/pci-driver.c.
>
> So if a generic PCI_VDEVICE entry (that has both subvendor and subdevice =
IDs
> set to PCI_ANY_ID) is put before a more specific one (PCI_DEVICE_SUB), th=
en
> the generic PCI_VDEVICE entry will match first and will be used.

Ah, now it makes sense. Thanks for patiently explaining this to me :)

So to tell the full story I'll change the commit log to something like
below. Does it look ok to you?

----------------------------------------------------------------------
ath9k: Really fix LED polarity for some Mini PCI AR9220 MB92 cards.

The active_high LED of my Wistron DNMA-92 is still being recognized as
active_low on 4.7.6 mainline. When I was preparing my former commit
0f9edcdd88a9 ("ath9k: Fix LED polarity for some Mini PCI AR9220 MB92
cards.") to fix that I must have somehow messed up with testing, because
I tested the final version of that patch before sending it, and it was
apparently working; but now it is not working on 4.7.6 mainline.

I initially added the PCI_DEVICE_SUB section for 0x0029/0x2096 above the
PCI_VDEVICE section for 0x0029; but then I moved the former below the
latter after seeing how 0x002A sections were sorted in the file.

So if a generic PCI_VDEVICE entry (that has both subvendor and subdevice
IDs set to PCI_ANY_ID) is put before a more specific one
(PCI_DEVICE_SUB), then the generic PCI_VDEVICE entry will match first
and will be used.

With this patch, 0x0029/0x2096 has finally got active_high LED on 4.7.6.

Fixes: 0f9edcdd88a9 ("ath9k: Fix LED polarity for some Mini PCI AR9220 MB92=
 cards.")
Cc: <stable@vger.kernel.org> #4.7+
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
[kvalo@qca.qualcomm.com: improve the commit log based on email discussions]
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
----------------------------------------------------------------------

--=20
Kalle Valo=
