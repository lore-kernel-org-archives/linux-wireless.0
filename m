Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:17131 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYIVJoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 05:44:12 -0400
Received: by wr-out-0506.google.com with SMTP id 69so478680wri.5
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 02:44:11 -0700 (PDT)
Message-ID: <43e72e890809220244r638c4beh315701f361d27dd3@mail.gmail.com> (sfid-20080922_114420_483769_89764C2B)
Date: Mon, 22 Sep 2008 02:44:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Senthil Balasubramanian" <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: Fix IRQ nobody cared issue with ath9k
Cc: linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>,
	"Steven Noonan" <steven@uplinklabs.net>,
	"Jouni Malinen" <jouni.malinen@atheros.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20080922085239.GA6379@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080922085239.GA6379@senthil-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 1:52 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> IRQs should be disabled before calling free_irq. Also flush pending
> IRQs. Pasted the kernel log message for reference.
>
> kernel: irq 17: nobody cared (try booting with the "irqpoll" option)
> kernel:  [<c0252d2c>] __report_bad_irq+0x2e/0x6f
> kernel:  [<c0252f22>] note_interrupt+0x1b5/0x207
> kernel:  [<c025258b>] ? handle_IRQ_event+0x21/0x48
> kernel:  [<c02534cb>] handle_fasteoi_irq+0x8e/0xad
> kernel:  [<c0205650>] do_IRQ+0x6c/0x84
> kernel:  [<c020425f>] common_interrupt+0x23/0x28
> kernel:  [<c034f6f6>] ? acpi_idle_enter_simple+0x198/0x205
> kernel:  [<c044686c>] ? menu_select+0x5c/0x78
> kernel:  [<c0445a95>] cpuidle_idle_call+0x59/0x89
> kernel:  [<c02029d7>] cpu_idle+0xae/0xcf
> kernel:  [<c0543102>] rest_init+0x4e/0x50
> kernel:  =======================
> kernel: handlers:
> kernel: [<f88fdd26>] (ath_isr+0x0/0x13a [ath9k])
> kernel: Disabling IRQ #17
>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> Tested-by: Steven Noonan <steven@uplinklabs.net>

This is 2.6.27 material, if you don't want interrupts disabled there as well.

 Luis
