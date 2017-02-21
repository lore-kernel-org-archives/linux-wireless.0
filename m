Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51636 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdBUJcy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 04:32:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jikos@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net
Subject: ath10k regression on XPS13
References: <alpine.LSU.2.20.1702201508280.24579@cbobk.fhfr.pm>
        <CA+55aFxLmgA7drrGfUJmCRPT-A74ROYf6GQHFGO5pzVjZ0dL7Q@mail.gmail.com>
Date: Tue, 21 Feb 2017 11:32:49 +0200
In-Reply-To: <CA+55aFxLmgA7drrGfUJmCRPT-A74ROYf6GQHFGO5pzVjZ0dL7Q@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 20 Feb 2017 18:48:19 -0800")
Message-ID: <87d1eb99dq.fsf_-_@purkki.adurom.net> (sfid-20170221_103259_209916_4A4A3CEC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Changing subject, adding Dave and relevant lists)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Feb 20, 2017 at 7:20 AM, Jiri Kosina <jikos@kernel.org> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
>>
>> to receive HID subsystem updates for 4.11:
>
> The touchpad on my XPS13 no longer works. It might not be this pull
> request, and I'll bisect the exact cause, but this pull seems the most
> likely culprit.
>
> Just an early heads-up,

While talking about XPS13 also a heads-up from me as we have a nasty
regression in ath10k on XPS13 with QCA6174 (though not sure if you have
QCA6174, recent models seem to have that) which completely breaks driver
initialisation an error:

"ath10k_pci 0000:3a:00.0: failed to fetch board data for
bus=pci,vendor=168c,device=003e,subsystem-vendor=1a56,subsystem-device=1535,variant=RV_0520
from ath10k/QCA6174/hw3.0/board-2.bin"

https://bugzilla.kernel.org/show_bug.cgi?id=185621#c9

This is caused by this commit which I believe Dave will be sending to
you soon:

f2593cb1b291 ath10k: Search SMBIOS for OEM board file extension

As a workaround I recommend updating ath10k/QCA6174/hw3.0/board-2.bin
from this link _before_ updating the kernel:

https://github.com/kvalo/ath10k-firmware/blob/8d15818b0f9c7b09f743538ac2d3e1409779f52a/QCA6174/hw3.0/board-2.bin

We are working on a fix so that ath10k continues to work with older
board-2.bin, but that might take a day or two still.

-- 
Kalle Valo
