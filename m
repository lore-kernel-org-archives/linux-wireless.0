Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50709 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1DRPCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 11:02:49 -0400
Received: by qyk7 with SMTP id 7so1099757qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 08:02:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104181648.43967.helmut.schaa@googlemail.com>
References: <201104181526.01722.IvDoorn@gmail.com>
	<BANLkTi=37Qv6tf5FH4VP=FrrFU=V7UhbNQ@mail.gmail.com>
	<BANLkTimOsO1RSO-+n97a0WiQR__f_sgcUQ@mail.gmail.com>
	<201104181648.43967.helmut.schaa@googlemail.com>
Date: Mon, 18 Apr 2011 17:02:48 +0200
Message-ID: <BANLkTimE0i-8x-RSM4bhvZcV+3Bg6gDWjw@mail.gmail.com>
Subject: Re: [PATCH 21/23] rt2x00: Optimize register access in rt2800usb
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 kwietnia 2011 16:48 użytkownik Helmut Schaa
<helmut.schaa@googlemail.com> napisał:
> Hi,
>
> Am Montag, 18. April 2011 schrieb Ivo Van Doorn:
>> > Wouldn't this be better to create two pointers in struct rt2x00_dev.
>> > One for writing function and one for reading function? Am I right
>> > thinking calling functions by pointers is quite fast? Or is this still
>> > noticeably slower than using proper functions directly?
>>
>> We already have the pointer inside struct rt2x00_dev which references
>> the register access functions for rt2800pci/usb. These pointers are used
>> by rt2800lib to access the common registers. What this patch does, is
>> optimize the case where we exactly know which function we need, because
>> we are in the actual driver.
>>
>> As for the performance, I'll let Helmut comment on that as he created patch 20,
>> which introduced this change to rt2800pci. :)
>
> Sure, I was comparing some assembly in the rt2800pci hotpaths (on a 380Mhz
> MIPS CPU btw). A register read/write on PCI is just a readl or writel,
> nothing more but using the indirect wrappers we get something like this
> (This is x86_64 as I didn't want to cross compile right now). For example
> the register read + write in rt2800pci_enable_interrupt (which is called
> in every tasklet invocation, which can happen for every rx'ed frame and
> every tx'ed frame).
>
> movq    8(%rbx), %rax   # rt2x00dev_1(D)->ops, rt2x00dev_1(D)->ops
> leaq    -36(%rbp), %rdx #, tmp82
> movq    %rbx, %rdi      # rt2x00dev,
> movq    72(%rax), %rax  # D.47612_27->drv, D.47612_27->drv
> movl    $516, %esi      #,
> call    *(%rax) # rt2800ops_29->register_read
> movb    %r14b, %cl      #,
> movq    8(%rbx), %rax   # rt2x00dev_1(D)->ops, rt2x00dev_1(D)->ops
> movq    %rbx, %rdi      # rt2x00dev,
> movq    72(%rax), %rax  # D.47619_31->drv, D.47619_31->drv
> movl    $516, %esi      #,
> movl    $1, %edx        #, reg.119
> sall    %cl, %edx       #, reg.119
> andl    %r13d, %edx     # irq_field$bit_mask, reg.119
> notl    %r13d   # tmp89
> andl    -36(%rbp), %r13d        # reg, tmp89
> orl     %r13d, %edx     # tmp89, reg.119
> movl    %edx, -36(%rbp) # reg.119, reg
> call    *16(%rax)       # rt2800ops_33->register_write
>
> Also, this will trigger rt2x00pci_register_read
>
> pushq   %rbp    #
> mov     %esi, %esi      # offset, addr.27
> movq    %rsp, %rbp      #,
> addq    1056(%rdi), %rsi        # rt2x00dev_1(D)->csr.base, addr.27
> movl    %eax, (%rdx)    # ret,* value
>
> And rt2x00pci_register_write:
>
> pushq   %rbp    #
> mov     %esi, %esi      # offset, addr.26
> movq    %rsp, %rbp      #,
> addq    1056(%rdi), %rsi        # rt2x00dev_1(D)->csr.base, addr.26
> movl    %edx,(%rsi)        # value,* addr.26
>
> And here the same when using rt2x00pci_register_read/write directly:
>
> movq    1056(%rbx), %rax        # rt2x00dev_1(D)->csr.base, rt2x00dev_1(D)->csr.base
> movl    516(%rax),%eax     #, reg.119
> movl    %r13d, %edx     # irq_field$bit_mask, tmp80
> movb    %r14b, %cl      #,
> notl    %edx    # tmp80
> andl    %edx, %eax      # tmp80, reg.119
> movl    $1, %edx        #, tmp85
> sall    %cl, %edx       #, tmp85
> andl    %r13d, %edx     # irq_field$bit_mask, tmp85
> orl     %edx, %eax      # tmp85, reg.119
> movq    1056(%rbx), %rdx        # rt2x00dev_1(D)->csr.base, rt2x00dev_1(D)->csr.base
> movl    %eax,516(%rdx)     # reg.119,
>
> As you can see we save more then just one indirect function call:
>
> 17 movs -> 7 movs
> 2 calls -> 0 calls
> 1 add -> 0 adds
>
> This happens because the compiler is able to apply a number of optimizations
> that are only possible by inlining rt2x00pci_register_read/write. When using
> the indirect function call the compiler is not able to inline them.
>
> So, I first thought about using direct calls only in the interrupt handler
> and the RX/TX hotpaths but since using rt2800_register_read and
> rt2x00pci_register_read in different locations in rt2800pci would be even
> more confusing I just replaced every rt2800_register_read with
> rt2x00pci_register_read in rt2800pci.
>
> One way to keep the abstraction and still improve the register_read/write
> operations would be to introduce a inlined rt2800pci_register_read/write
> which directly calls rt2x00pci_register_read/write and provide that via
> rt2800_ops to rt2800lib. That way all calls in rt2800pci can directly
> inline rt2x00_register_read/write while rt2800lib will still use indirect
> calls to do the same.
>
> However, I didn't see any need for this.

Huh, thanks a lot for great explanation :)

-- 
Rafał
