Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36638 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752205AbdGYOus (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 10:50:48 -0400
MIME-Version: 1.0
In-Reply-To: <87mv7sisr3.fsf@codeaurora.org>
References: <20170710144425.2238584-1-arnd@arndb.de> <20170710144425.2238584-2-arnd@arndb.de>
 <87mv7sisr3.fsf@codeaurora.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 25 Jul 2017 16:50:47 +0200
Message-ID: <CAK8P3a2jHkrE57jYWuXOkyUSeFxy0jdT-pnL4GXP7z0bhHiTKQ@mail.gmail.com> (sfid-20170725_165148_595677_51E425C8)
Subject: Re: [RFC 2/2] wl3501_cs: reduce stack size for KASAN
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 25, 2017 at 2:52 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>
>> Inlining functions with local variables can lead to excessive stack usage
>> with KASAN after a previous patch that modifies the outsb/insb helpers
>> on x86.
>>
>> drivers/net/wireless/wl3501_cs.c: In function 'wl3501_rx_interrupt':
>> drivers/net/wireless/wl3501_cs.c:1103:1: error: the frame size of 2232 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
>>
>> Marking the two callers of insb/outb 'noinline' prevents the compiler
>> from adding up the stack usage for each of the local variables passed
>> into those, reducing the maximum stack frame size to 800 bytes with
>> KASAN again.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Arnd, based on the discussion I'm dropping. Please let me know if I
> should take this still.

Thanks, that's good. The problem has become unreproducible and
I assume it's gone for good with the new x86 fix. In the unlikely
case some form of the problem comes back in another randconfig,
I'll post a new patch.

       Arnd
