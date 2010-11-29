Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45903 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0K2US2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 15:18:28 -0500
Received: by vws3 with SMTP id 3so71918vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 12:18:28 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101129192628.GC8199@tuxdriver.com>
References: <1290630782-11095-1-git-send-email-kilroyd@googlemail.com>
	<20101129192628.GC8199@tuxdriver.com>
Date: Mon, 29 Nov 2010 21:18:27 +0100
Message-ID: <AANLkTincC1ETrH=562Ftc5_z-Tdv+fTd4O_HbGZkOccC@mail.gmail.com>
Subject: Re: [PATCH] orinoco: abort scan on interface down
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Kilroy <kilroyd@gmail.com>, linux-wireless@vger.kernel.org,
	comes@naic.edu, David Kilroy <kilroyd@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 8:26 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Nov 24, 2010 at 08:33:02PM +0000, David Kilroy wrote:
>> This fixes the problem causing the following trace:
>>
>> ------------[ cut here ]------------
>> WARNING: at linux-2.6.34/net/wireless/core.c:633 wdev_cleanup_work+0xb7/0xe0 [cfg80211]()
>> Hardware name: Latitude C840
>> Pid: 707, comm: cfg80211 Not tainted 2.6.34.7-0.5-desktop #1
>> Call Trace:
>>  [<c02065c3>] try_stack_unwind+0x173/0x190
>>  [<c02051cf>] dump_trace+0x3f/0xe0
>>  [<c020662b>] show_trace_log_lvl+0x4b/0x60
>>  [<c0206658>] show_trace+0x18/0x20
>>  [<c064e0b3>] dump_stack+0x6d/0x72
>>  [<c02443ae>] warn_slowpath_common+0x6e/0xb0
>>  [<c0244403>] warn_slowpath_null+0x13/0x20
>>  [<e2db5497>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
>>  [<c025cfa9>] run_workqueue+0x79/0x170
>>  [<c025d123>] worker_thread+0x83/0xe0
>>  [<c025fef4>] kthread+0x74/0x80
>>  [<c0203826>] kernel_thread_helper+0x6/0x10
>> ---[ end trace 3f0348b3b0c6f4ff ]---
>>
>> Reported by: Giacomo Comes <comes@naic.edu>
>> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
>> ---
>>
>> This patch has only been compile tested. Given the trace, I've
>> guessed that cfg80211 would prefer that orinoco abort the scan on
>> interface down.
>
> Any chance we can get a Tested-by on this one, so I can feel good
> about sending it for 2.6.37?

I was looking for an old PCMCIA orinoco hermes-I or -II card, but I
found a cheat sheet from my very first Linux book from Michael Kofler.
Which key on a EN/US keyboard is equivalent to the one on a DE
keyboard, nice catch :-).
Will look in the other cartons in the cellar...

- Sedat -
