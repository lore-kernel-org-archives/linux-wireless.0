Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44346 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbeAXHja (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 02:39:30 -0500
Message-ID: <1516779566.2508.41.camel@sipsolutions.net> (sfid-20180124_083950_575456_D426AD58)
Subject: Re: WARNING in check_flush_dependency
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot+41cdaf4232c50e658934@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date: Wed, 24 Jan 2018 08:39:26 +0100
In-Reply-To: <001a1143c56ef80bb405636ca341@google.com> (sfid-20180123_083904_793142_75F4D2AB)
References: <001a1143c56ef80bb405636ca341@google.com>
         (sfid-20180123_083904_793142_75F4D2AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-22 at 23:39 -0800, syzbot wrote:
> Hello,
> 
> syzbot hit the following crash on upstream commit
> 0d665e7b109d512b7cae3ccef6e8654714887844 (Fri Jan 19 12:49:24 2018 +0000)
> mm, page_vma_mapped: Drop faulty pointer arithmetics in check_pte()
> 
> So far this crash happened 23 times on net-next, upstream.
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> user-space arch: i386
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+41cdaf4232c50e658934@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for  
> details.
> If you forward the report, please keep this part and the footer.
> 
> ------------[ cut here ]------------
> workqueue: WQ_MEM_RECLAIM hwsim_wq:destroy_radio is  
> flushing !WQ_MEM_RECLAIM events_highpri:flush_backlog
> WARNING: CPU: 0 PID: 3706 at kernel/workqueue.c:2439  
> check_flush_dependency+0x239/0x380 kernel/workqueue.c:2435
> Kernel panic - not syncing: panic_on_warn set ...

Yeah, we clearly shouldn't have WQ_RECLAIM set on this workqueue...

johannes
