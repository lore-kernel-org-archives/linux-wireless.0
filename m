Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server1.vittgam.net ([213.239.197.142]:43668 "EHLO
        mail.vittgam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbcJNJtx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 05:49:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Date: Fri, 14 Oct 2016 11:49:40 +0200
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        <ath9k-devel@venema.h4ckr.net>, <stable@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Move generic entries below specific ones in
 =?UTF-8?Q?ath=5Fpci=5Fid=5Ftable=2E?=
In-Reply-To: <877f9dehn0.fsf@kamboji.qca.qualcomm.com>
References: <ath9k-patch-20161003@vittgam.net>
 <87k2dop15n.fsf@kamboji.qca.qualcomm.com>
 <cd3ff141b0ba69399a377a96a9ae75fb@vittgam.net>
 <87eg3lg07d.fsf@kamboji.qca.qualcomm.com>
 <6ae887d799b201d78b4474ab9bbf6917@vittgam.net>
 <877f9dehn0.fsf@kamboji.qca.qualcomm.com>
Message-ID: <8d77a285e16cdd9f3b79c9e8d8800d72@vittgam.net> (sfid-20161014_114958_345241_6B885DC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 12/10/2016 17:01:08 CEST, Valo, Kalle wrote:
> "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net> writes:
>
>>>> So, after seeing that the rest of the file is sorted this way (generic
>>>> section after the specific ones), I concluded that the 0x002A sorting
>>>> was wrong in the first place, and so is 0x0029. Then I sent this patch
>>>> to fix this.
>>>
>>> I can't see how changing the order in ath_pci_id_table[] would make any
>>> difference in functionality, but I might be missing something.
>>
>> It does: I've looked through the relevant code, and found that PCI device
>> matching from that table is done sequentially in pci_match_id() from
>> drivers/pci/pci-driver.c.
>>
>> So if a generic PCI_VDEVICE entry (that has both subvendor and subdevice IDs
>> set to PCI_ANY_ID) is put before a more specific one (PCI_DEVICE_SUB), then
>> the generic PCI_VDEVICE entry will match first and will be used.
>
> Ah, now it makes sense. Thanks for patiently explaining this to me :)

You're welcome :)

> So to tell the full story I'll change the commit log to something like
> below. Does it look ok to you?

Yes; but I'd change "So" to "This turned out to be wrong", and add a note
about changing the order for 0x002A too:

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

This turned out to be wrong: if a generic PCI_VDEVICE entry (that has
both subvendor and subdevice IDs set to PCI_ANY_ID) is put before a more
specific one (PCI_DEVICE_SUB), then the generic PCI_VDEVICE entry will
match first and will be used.

With this patch, 0x0029/0x2096 has finally got active_high LED on 4.7.6.

While I'm at it, let's fix 0x002A too by also moving its generic definition
below its specific ones.

Fixes: 0f9edcdd88a9 ("ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.")
Cc: <stable@vger.kernel.org> #4.7+
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
[kvalo@qca.qualcomm.com: improve the commit log based on email discussions]
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
----------------------------------------------------------------------

Cheers,
Vittorio
