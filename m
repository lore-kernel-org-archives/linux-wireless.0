Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49646 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbbE1LqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 07:46:24 -0400
Message-ID: <5567000E.6070401@broadcom.com> (sfid-20150528_134707_904246_C4DC13CF)
Date: Thu, 28 May 2015 13:46:22 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [for-4.1] brcmfmac: avoid null pointer access whenbrcmf_msgbuf_get_pktid()
 fails
References: <20150528084642.220B4140749@smtp.codeaurora.org> <87pp5lxedq.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87pp5lxedq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/15 11:03, Kalle Valo wrote:
> Kalle Valo<kvalo@codeaurora.org>  writes:
>
>>> The function brcmf_msgbuf_get_pktid() may return a NULL pointer so
>>> the callers should check the return pointer before accessing it to
>>> avoid the crash below (see [1]):
>>>
>>> brcmfmac: brcmf_msgbuf_get_pktid: Invalid packet id 273 (not in use)
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
>>> IP: [<ffffffff8145b225>] skb_pull+0x5/0x50
>>> PGD 0
>>> Oops: 0000 [#1] PREEMPT SMP
>>> Modules linked in: pci_stub vboxpci(O) vboxnetflt(O) vboxnetadp(O) vboxdrv(O)
>>>   snd_hda_codec_hdmi bnep mousedev hid_generic ushwmon msr ext4 crc16 mbcache
>>>   jbd2 sd_mod uas usb_storage ahci libahci libata scsi_mod xhci_pci xhci_hcd
>>>   usbcore usb_common
>>> CPU: 0 PID: 1661 Comm: irq/61-brcmf_pc Tainted: G O    4.0.1-MacbookPro-ARCH #1
>>> Hardware name: Apple Inc. MacBookPro12,1/Mac-E43C1C25D4880AD6,
>>>   BIOS MBP121.88Z.0167.B02.1503241251 03/24/2015
>>> task: ffff880264203cc0 ti: ffff88025ffe4000 task.ti: ffff88025ffe4000
>>> RIP: 0010:[<ffffffff8145b225>]  [<ffffffff8145b225>] skb_pull+0x5/0x50
>>> RSP: 0018:ffff88025ffe7d40  EFLAGS: 00010202
>>> RAX: 0000000000000000 RBX: ffff88008a33c000 RCX: 0000000000000044
>>> RDX: 0000000000000000 RSI: 000000000000004a RDI: 0000000000000000
>>> RBP: ffff88025ffe7da8 R08: 0000000000000096 R09: 000000000000004a
>>> R10: 0000000000000000 R11: 000000000000048e R12: ffff88025ff14f00
>>> R13: 0000000000000000 R14: ffff880263b48200 R15: ffff88008a33c000
>>> FS:  0000000000000000(0000) GS:ffff88026ec00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 0000000000000080 CR3: 000000000180b000 CR4: 00000000003407f0
>>> Stack:
>>>   ffffffffa06aed74 ffff88025ffe7dc8 ffff880263b48270 ffff880263b48278
>>>   05ea88020000004a 0002ffff81014635 000000001720b2f6 ffff88026ec116c0
>>>   ffff880263b48200 0000000000010000 ffff880263b4ae00 ffff880264203cc0
>>> Call Trace:
>>>   [<ffffffffa06aed74>] ? brcmf_msgbuf_process_rx+0x404/0x480 [brcmfmac]
>>>   [<ffffffff810cea60>] ? irq_finalize_oneshot.part.30+0xf0/0xf0
>>>   [<ffffffffa06afb55>] brcmf_proto_msgbuf_rx_trigger+0x35/0xf0 [brcmfmac]
>>>   [<ffffffffa06baf2a>] brcmf_pcie_isr_thread_v2+0x8a/0x130 [brcmfmac]
>>>   [<ffffffff810cea80>] irq_thread_fn+0x20/0x50
>>>   [<ffffffff810ceddf>] irq_thread+0x13f/0x170
>>>   [<ffffffff810cebf0>] ? wake_threads_waitq+0x30/0x30
>>>   [<ffffffff810ceca0>] ? irq_thread_dtor+0xb0/0xb0
>>>   [<ffffffff81092a08>] kthread+0xd8/0xf0
>>>   [<ffffffff81092930>] ? kthread_create_on_node+0x1c0/0x1c0
>>>   [<ffffffff8156d898>] ret_from_fork+0x58/0x90
>>>   [<ffffffff81092930>] ? kthread_create_on_node+0x1c0/0x1c0
>>> Code: 01 83 e2 f7 88 50 01 48 83 c4 08 5b 5d f3 c3 0f 1f 80 00 00 00 00 83 e2
>>>   f7 88 50 01 c3 66 0f 1f 84 00 00 00 00 00 0f 1f
>>> RIP  [<ffffffff8145b225>] skb_pull+0x5/0x50
>>>   RSP<ffff88025ffe7d40>
>>> CR2: 0000000000000080
>>> ---[ end trace b074c0f90e7c997d ]---
>>>
>>> [1] http://mid.gmane.org/20150430193259.GA5630@googlemail.com
>>>
>>> Cc:<stable@vger.kernel.org>  # v3.18, v3.19, v4.0, v4.1
>>> Reported-by: Michael Hornung<mhornung.linux@gmail.com>
>>> Reviewed-by: Hante Meuleman<meuleman@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>
>> Thanks, applied to wireless-drivers.git.
>
> Oh, I forgot to mention that I'm not sure if this will make it into 4.1.
> But let's at least try.

Thanks, Kalle

It was a reported issue crashing the kernel so figured it would be 4.1 
material, but indeed I should have sent it earlier. We'll see.

Regards,
Arend

