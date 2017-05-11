Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35328 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdEKEDL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 00:03:11 -0400
Received: by mail-io0-f195.google.com with SMTP id o12so2034220iod.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 May 2017 21:03:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bmr0vyhe.fsf@kamboji.qca.qualcomm.com>
References: <20170501214327.5621-1-adrian@freebsd.org> <CAHjFwoAr6Tjh=Zpr_JhEp_-g_0XJ+LDUagsfJh=vqseqzBC1Pw@mail.gmail.com>
 <87bmr0vyhe.fsf@kamboji.qca.qualcomm.com>
From: Su Kang Yin <paradyse@gmail.com>
Date: Thu, 11 May 2017 12:02:40 +0800
Message-ID: <CAHjFwoDexNAqCFhpwShbTVHuQbP+ZbzDw8dHjq-ohO5jfuus6w@mail.gmail.com> (sfid-20170511_060323_567063_AF2BB4CE)
Subject: Re: [PATCH] [ath10k] go back to using dma_alloc_coherent() for
 firmware scratch memory.
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2017 at 11:55, Kalle Valo wrote:
> Su Kang Yin writes:
>
>> Without this patch QCA9888 is not working. Also I have to update
>> board2.bin from Kalle's git repo.
>
> More details would be good to know, as the behaviour seems to vary quite
> a lot. What platform are you using, x86, some ARM board or what? And
> what kernel exactly?

Kernel 4.9.25 on X86 Intel Atom

Panic message is something like that:

Workqueue: ath10k_aux_wq ath10k_wmi_event_service_ready_work [ath10k_core]
task: ffff880036433a00 ti: ffff880036440000 task.ti: ffff880036440000
RIP: 0010:[<ffffffff8124592a>]  [<ffffffff8124592a>] new_slab+0x39a/0x410
RSP: 0018:ffff880036443b58  EFLAGS: 00010092
RAX: 0000000000000006 RBX: 00000000024082c4 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffff88021e30dd08 RDI: ffff88021e30dd08
RBP: ffff880036443b90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000372 R12: ffff88021dc01200
R13: ffff88021dc00cc0 R14: ffff88021dc01200 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88021e300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3e65c1c730 CR3: 0000000001e06000 CR4: 00000000001406e0
Stack:
  ffffffff8127a4fc ffff0a01ffffff10 00000000024082c4 ffff88021dc01200
  ffff88021dc00cc0 ffff88021dc01200 0000000000000001 ffff880036443c58
  ffffffff81247ac6 ffff88021e31b360 ffff880036433a00 ffff880036433a00
Call Trace:
  [<ffffffff8127a4fc>] ? __d_lookup+0x9c/0x160
  [<ffffffff81247ac6>] ___slab_alloc+0x396/0x4a0
  [<ffffffffa0f8e14d>] ?
ath10k_wmi_event_service_ready_work+0x5ad/0x800 [ath10k_core]
  [<ffffffff811f5279>] ? alloc_kmem_pages+0x9/0x10
  [<ffffffff8120f203>] ? kmalloc_order+0x13/0x40
  [<ffffffffa0f8e14d>] ?
ath10k_wmi_event_service_ready_work+0x5ad/0x800 [ath10k_core]

-- Yin
