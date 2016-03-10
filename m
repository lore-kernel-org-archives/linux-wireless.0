Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34239 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbcCJIgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 03:36:22 -0500
Received: by mail-wm0-f51.google.com with SMTP id p65so18320908wmp.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 00:36:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgW7S8xru6KVBdQMLN3+=N-uzMf18rwfDWW6uNzCv7eaWg@mail.gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
	<1456358932-23114-7-git-send-email-afenkart@gmail.com>
	<CAGRGNgW7S8xru6KVBdQMLN3+=N-uzMf18rwfDWW6uNzCv7eaWg@mail.gmail.com>
Date: Thu, 10 Mar 2016 09:36:20 +0100
Message-ID: <CALtMJECeueX2HH8gu0gRHFsu5Y1xAox9H-UvfRsQMrNtnh+xow@mail.gmail.com> (sfid-20160310_093646_246091_53BAB19B)
Subject: Re: [PATCH 6/7] mwifiex: factor out mwifiex_cancel_pending_scan_cmd
From: Andreas Fenkart <afenkart@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

thanks for your time!

2016-02-25 2:14 GMT+01:00 Julian Calaby <julian.calaby@gmail.com>:
> Hi Andreas,
>
> On Thu, Feb 25, 2016 at 11:08 AM, Andreas Fenkart <afenkart@gmail.com> wrote:
>> releasing the scan_pending lock in mwifiex_check_next_scan_command
>> is valid, since the lock is taken again, and all nodes removed
>> from the scan_pending queue.
>>
>> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
>> ---
>>  drivers/net/wireless/marvell/mwifiex/cmdevt.c      | 43 ++++++++++------------
>>  drivers/net/wireless/marvell/mwifiex/main.h        |  1 +
>>  drivers/net/wireless/marvell/mwifiex/scan.c        | 23 +++---------
>>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 13 +------
>>  4 files changed, 27 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
>> index 6ddc98b..490d0d1 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
>> @@ -1920,13 +1910,10 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
>>                 }
>>         } else if ((priv->scan_aborting && !priv->scan_request) ||
>>                    priv->scan_block) {
>> -               list_for_each_entry_safe(cmd_node, tmp_node,
>> -                                        &adapter->scan_pending_q, list) {
>> -                       list_del(&cmd_node->list);
>> -                       mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
>> -               }
>>                 spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
>>
>> +               mwifiex_cancel_pending_scan_cmd(adapter);
>> +
>
> This is creating a "short" window where &adapter->scan_pending_q_lock
> is unlocked here. Is that safe?
>
> You might want to write mwifiex_cancel_pending_scan_cmd() as two
> functions, one which takes the spinlock and calls the other and one
> which does all the work so you can call the latter here without that
> window where ..._q_lock is unlocked.

I added this comment to the description of the updated patch, that I
will send out shortly:

Releasing the scan_pending lock in mwifiex_check_next_scan_command
introduces a short window where pending scan commands can be removed
or added before removing them all in mwifiex_cancel_pending_scan_cmd.
I think this is safe, since the worst thing to happen is that a
pending scan cmd is removed by the command handler. Adding new scan
commands is not possible while one is pending, see scan_processing.
Since all commands are removed from the queue anyway, we don't care if
some commands are removed by a different code path earlier, the final
state remains the same.
I assume, that the critical section needed for the check has been
extended over clearing the pending scan queue, out of convenience. The
lock was already held and releasing it first just to grab it again was
more work. It doesn't seem to be necessary because of concurrency.

Thanks,
Andi
