Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdGYMwF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 08:52:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] wl3501_cs: reduce stack size for KASAN
References: <20170710144425.2238584-1-arnd@arndb.de>
        <20170710144425.2238584-2-arnd@arndb.de>
Date: Tue, 25 Jul 2017 15:52:00 +0300
In-Reply-To: <20170710144425.2238584-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 10 Jul 2017 16:44:25 +0200")
Message-ID: <87mv7sisr3.fsf@codeaurora.org> (sfid-20170725_145233_913653_9AF0F2E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> Inlining functions with local variables can lead to excessive stack usage
> with KASAN after a previous patch that modifies the outsb/insb helpers
> on x86.
>
> drivers/net/wireless/wl3501_cs.c: In function 'wl3501_rx_interrupt':
> drivers/net/wireless/wl3501_cs.c:1103:1: error: the frame size of 2232 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
>
> Marking the two callers of insb/outb 'noinline' prevents the compiler
> from adding up the stack usage for each of the local variables passed
> into those, reducing the maximum stack frame size to 800 bytes with
> KASAN again.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Arnd, based on the discussion I'm dropping. Please let me know if I
should take this still.

-- 
Kalle Valo
