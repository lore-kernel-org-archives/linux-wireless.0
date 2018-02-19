Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:37598 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753439AbeBSS6e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 13:58:34 -0500
Received: by mail-pl0-f68.google.com with SMTP id ay8so6097890plb.4
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2018 10:58:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1516779566.2508.41.camel@sipsolutions.net>
References: <001a1143c56ef80bb405636ca341@google.com> <1516779566.2508.41.camel@sipsolutions.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 19 Feb 2018 19:58:13 +0100
Message-ID: <CACT4Y+bziyU+32umG=VD7wCbxpsKoGkbAypDwQS=PivfGSzypA@mail.gmail.com> (sfid-20180219_195857_759910_C9226AB8)
Subject: Re: WARNING in check_flush_dependency
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot+41cdaf4232c50e658934@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 24, 2018 at 8:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2018-01-22 at 23:39 -0800, syzbot wrote:
>> Hello,
>>
>> syzbot hit the following crash on upstream commit
>> 0d665e7b109d512b7cae3ccef6e8654714887844 (Fri Jan 19 12:49:24 2018 +0000)
>> mm, page_vma_mapped: Drop faulty pointer arithmetics in check_pte()
>>
>> So far this crash happened 23 times on net-next, upstream.
>> C reproducer is attached.
>> syzkaller reproducer is attached.
>> Raw console output is attached.
>> compiler: gcc (GCC) 7.1.1 20170620
>> .config is attached.
>> user-space arch: i386
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+41cdaf4232c50e658934@syzkaller.appspotmail.com
>> It will help syzbot understand when the bug is fixed. See footer for
>> details.
>> If you forward the report, please keep this part and the footer.
>>
>> ------------[ cut here ]------------
>> workqueue: WQ_MEM_RECLAIM hwsim_wq:destroy_radio is
>> flushing !WQ_MEM_RECLAIM events_highpri:flush_backlog
>> WARNING: CPU: 0 PID: 3706 at kernel/workqueue.c:2439
>> check_flush_dependency+0x239/0x380 kernel/workqueue.c:2435
>> Kernel panic - not syncing: panic_on_warn set ...
>
> Yeah, we clearly shouldn't have WQ_RECLAIM set on this workqueue...

Hi Johannes,

Do you mind to send a patch to fix this?
