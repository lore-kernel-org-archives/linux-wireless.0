Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56686 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3CRMK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 08:10:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH v3] ath6kl: Fix a debugfs crash for USB devices
References: <1363105983-10527-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Mon, 18 Mar 2013 14:10:54 +0200
In-Reply-To: <1363105983-10527-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 12 Mar 2013 22:03:03
	+0530")
Message-ID: <874ng89acx.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_131103_995024_570C325B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> Credit distribution stats is currently implemented
> only for SDIO. This fixes a crash in debugfs for
> USB interface.
>
> BUG: unable to handle kernel NULL pointer dereference at   (null)
> IP: [<f91c2048>] read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
> *pde = b62bd067
> Oops: 0000 [#1] SMP
>
> EIP: 0060:[<f91c2048>] EFLAGS: 00210246 CPU: 0
> EIP is at read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
> EAX: 00000000 EBX: e6f7a9c0 ECX: e7b148b8 EDX: 00000000
> ESI: 000000c8 EDI: e7b14000 EBP: e6e09f64 ESP: e6e09f30
> DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process cat (pid: 4058, ti=e6e08000 task=e50cf230 task.ti=e6e08000)
> Stack:
> 00008000 00000000 e6e09f64 c1132d3c 00004e71 e50cf230 00008000 089e4000
> e7b148b8 00000000 e6f7a9c0 00008000 089e4000 e6e09f8c c11331fc e6e09f98
> 00000001 e6e09f7c f91c2010 e6e09fac e6f7a9c0 089e4877 089e4000 e6e09fac
>
> 	Call Trace:
> 	[<c1132d3c>] ? rw_verify_area+0x6c/0x120
> 	[<c11331fc>] vfs_read+0x8c/0x160
> 	[<f91c2010>] ? read_file_war_stats+0x130/0x130 [ath6kl_core]
> 	[<c113330d>] sys_read+0x3d/0x70
> 	[<c15755b4>] syscall_call+0x7/0xb
> 	[<c1570000>] ? fill_powernow_table_pstate+0x127/0x127
>
> Cc: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
