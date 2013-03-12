Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57454 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3CLQP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 12:15:27 -0400
Message-ID: <513F5484.50000@qca.qualcomm.com> (sfid-20130312_171531_970333_6CA6408A)
Date: Tue, 12 Mar 2013 21:45:00 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2 5/5] ath6kl: Fix a debugfs crash for USB devices
References: <1361544646-9059-1-git-send-email-mohammed@qca.qualcomm.com> <CAD2nsn2sQhF2B-gAWpVoG7U4ijyS3TO=buhe0yiJk12T3g-kMA@mail.gmail.com> <876211m39n.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <876211m39n.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2013 01:08 PM, Kalle Valo wrote:
> Mohammed Shafi <shafi.wireless@gmail.com> writes:
>
>> On Fri, Feb 22, 2013 at 8:20 PM, Mohammed Shafi Shajakhan
>> <mohammed@qca.qualcomm.com> wrote:
>>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>>
>>> Credit distribution stats is currently implemented
>>> only for SDIO. This fixes a crash in debugfs for
>>> USB interface.
>>>
>>> BUG: unable to handle kernel NULL pointer dereference at   (null)
>>> IP: [<f91c2048>] read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
>>> *pde = b62bd067
>>> Oops: 0000 [#1] SMP
>>>
>>> EIP: 0060:[<f91c2048>] EFLAGS: 00210246 CPU: 0
>>> EIP is at read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
>>> EAX: 00000000 EBX: e6f7a9c0 ECX: e7b148b8 EDX: 00000000
>>> ESI: 000000c8 EDI: e7b14000 EBP: e6e09f64 ESP: e6e09f30
>>> DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>>> Process cat (pid: 4058, ti=e6e08000 task=e50cf230 task.ti=e6e08000)
>>> Stack:
>>> 00008000 00000000 e6e09f64 c1132d3c 00004e71 e50cf230 00008000 089e4000
>>> e7b148b8 00000000 e6f7a9c0 00008000 089e4000 e6e09f8c c11331fc e6e09f98
>>> 00000001 e6e09f7c f91c2010 e6e09fac e6f7a9c0 089e4877 089e4000 e6e09fac
>>>
>>>          Call Trace:
>>>          [<c1132d3c>] ? rw_verify_area+0x6c/0x120
>>>          [<c11331fc>] vfs_read+0x8c/0x160
>>>          [<f91c2010>] ? read_file_war_stats+0x130/0x130 [ath6kl_core]
>>>          [<c113330d>] sys_read+0x3d/0x70
>>>          [<c15755b4>] syscall_call+0x7/0xb
>>>          [<c1570000>] ? fill_powernow_table_pstate+0x127/0x127
>>>
>>> Cc: Ryan Hsu <ryanhsu@qca.qualcomm.com>
>>> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> [...]
>
>>> @@ -1752,8 +1752,10 @@ int ath6kl_debug_init_fs(struct ath6kl *ar)
>>>          debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
>>>                              &fops_tgt_stats);
>>>
>>> -       debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
>>> -                           &fops_credit_dist_stats);
>>> +       if (ar->hif_type != ATH6KL_HIF_TYPE_SDIO)
>>
>> made a mistake,
>> should be > +       if (ar->hif_type == ATH6KL_HIF_TYPE_SDIO)
>> will send another patch
>
> Oh, I missed as well. I rebased ath6kl-next branch and dropped patch 5
> (but kept patches 1-4). Please resend patch 5.
>

sure thanks!

-- 
thanks,
shafi
