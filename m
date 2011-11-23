Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64590 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KWIus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 03:50:48 -0500
Received: by vcbfk14 with SMTP id fk14so38719vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 00:50:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111123080506.GB9833@redhat.com>
References: <20111116100915.GA2191@redhat.com>
	<20111122214940.GH8452@tuxdriver.com>
	<20111123080506.GB9833@redhat.com>
Date: Wed, 23 Nov 2011 09:50:47 +0100
Message-ID: <CAOZOX0VMHfkWWxHEez4zRyLX9-JaJ=Fuf-ftNOPoug61RisgwQ@mail.gmail.com> (sfid-20111123_095051_917251_377FE581)
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	RA-Eddy Tsai <Eddy_Tsai@ralinktech.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Nov 23, 2011 at 9:05 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Nov 22, 2011 at 04:49:40PM -0500, John W. Linville wrote:
>> On Wed, Nov 16, 2011 at 11:09:17AM +0100, Stanislaw Gruszka wrote:
>> > Some devices may generate spurious interrupts, we have to handle them
>> > otherwise interrupt line will be disabled with below message and driver
>> > will not work:
>> >
>> > [ 2052.114334] irq 17: nobody cared (try booting with the "irqpoll" option)
>> > [ 2052.114339] Pid: 0, comm: swapper Tainted: P           2.6.35.6-48.fc14.x86_64 #1
>> > [ 2052.114341] Call Trace:
>> > [ 2052.114342]  <IRQ>  [<ffffffff810a6e2b>] __report_bad_irq.clone.1+0x3d/0x8b
>> > [ 2052.114349]  [<ffffffff810a6f93>] note_interrupt+0x11a/0x17f
>> > [ 2052.114352]  [<ffffffff810a7a73>] handle_fasteoi_irq+0xa8/0xce
>> > [ 2052.114355]  [<ffffffff8100c2ea>] handle_irq+0x88/0x90
>> > [ 2052.114357]  [<ffffffff8146f034>] do_IRQ+0x5c/0xb4
>> > [ 2052.114360]  [<ffffffff81469593>] ret_from_intr+0x0/0x11
>> > [ 2052.114361]  <EOI>  [<ffffffff8102b7f9>] ? native_safe_halt+0xb/0xd
>> > [ 2052.114366]  [<ffffffff81010f03>] ? need_resched+0x23/0x2d
>> > [ 2052.114367]  [<ffffffff8101102a>] default_idle+0x34/0x4f
>> > [ 2052.114370]  [<ffffffff81008325>] cpu_idle+0xaa/0xcc
>> > [ 2052.114373]  [<ffffffff81461f2a>] start_secondary+0x24d/0x28e
>> > [ 2052.114374] handlers:
>> > [ 2052.114375] [<ffffffff81332944>] (usb_hcd_irq+0x0/0x7c)
>> > [ 2052.114378] [<ffffffffa00697da>] (rt2800pci_interrupt+0x0/0x18d [rt2800pci])
>> > [ 2052.114384] Disabling IRQ #17
>> >
>> > Resolve:
>> > https://bugzilla.redhat.com/show_bug.cgi?id=658451
>> >
>> > Reported-and-tested-by: Amir Hedayaty <hedayaty@gmail.com>
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>>
>> I trust that you saw the comments in the other thread.  I have reverted
>> this patch and the related rt2x00 one.
> I responded there.
>
>> Perhaps there is some way to convince the hardware not to generate
>> spurious interrupts?
>
> Ivo, Gertjan, Helmut, is there a possibility that I can get hardware
> documentation or any other support from Ralink, that could help to
> solve this (and possible other issues)?

In the rt2x00 project we do have the early draft of the Specsheet for
the first 2800pci devices. However this falls in the category of specsheets
which is not yet publically published by Ralink, and hence we can't
distribute it further.

I've added Eddy Tsai to the recipientlist for this mail, he is the Ralink
developer, and he might have a better idea on this issue.

Eddy, we have an issue with rt2860 devices which are generating
spurious interrupts,
however how can we determine in our IRQ handler if the rt2860 generated the
interrupt and not another device on the same IRQ line?
In the driver released by Ralink the CSR is checked to see if any interrupt bit
is set, and if nothing is set IRQ_HANDLED is returned. However this means
we can return IRQ_HANDLED when the interrupt was triggered by another device
as well.
Is there a way to prevent rt2860 from firing spurious interrupts, or
is there a better
way to detect if rt2860 fired the interrupt?

Thanks,

Ivo
