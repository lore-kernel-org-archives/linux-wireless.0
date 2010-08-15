Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48003 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579Ab0HORjE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:39:04 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Odd BUG on wireless-testing master-2010-08-05
References: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
	<20100806135057.GA2753@tuxdriver.com>
	<AANLkTi=Q6K1xeDn6zmBD5co5aMgvDMyUqGE3vLoo4_2+@mail.gmail.com>
	<201008072104.43784.chunkeey@googlemail.com>
	<874of5d6k7.fsf@purkki.adurom.net>
	<1281256404.3697.2.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 15 Aug 2010 20:39:01 +0300
In-Reply-To: <1281256404.3697.2.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Sun\, 08 Aug 2010 10\:33\:24 +0200")
Message-ID: <877hjrbwsq.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> I have similar warnings with ath9k, using commit
>> 0ca923bdb96b1fee4d1db90b3094a0cf36120056:
>> 
>> Aug  6 21:02:08 tukki kernel: [   71.172707] =============================================================================
>> Aug  6 21:02:08 tukki kernel: [   71.172715] BUG kmalloc-4096: Object already free
>> Aug  6 21:02:08 tukki kernel: [   71.172718] -----------------------------------------------------------------------------
>> Aug  6 21:02:08 tukki kernel: [   71.172720] 
>> Aug  6 21:02:08 tukki kernel: [   71.172732] INFO: Allocated in wireless_send_event+0x1f2/0x410 age=0 cpu=1 pid=3056
>
> I wonder if this is in any way related to
> commit 1235f504aaba2ebeabc863fdb3ceac764a317d47
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Mon Jul 26 13:09:16 2010 -0700
>
>     netlink: netlink_recvmsg() fix

Thanks, that was a good tip. I run a revert of this commit for few
days and didn't see any warnings. Yesterday I again dropped the revert
and started to see warnings again. I can't be 100% certain (yet) that
this commit is the culprit, but it really looks like it.

-- 
Kalle Valo
