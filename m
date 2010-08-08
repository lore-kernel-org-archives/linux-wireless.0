Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0HHId3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 04:33:29 -0400
Subject: Re: Odd BUG on wireless-testing master-2010-08-05
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <874of5d6k7.fsf@purkki.adurom.net>
References: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
	 <20100806135057.GA2753@tuxdriver.com>
	 <AANLkTi=Q6K1xeDn6zmBD5co5aMgvDMyUqGE3vLoo4_2+@mail.gmail.com>
	 <201008072104.43784.chunkeey@googlemail.com>
	 <874of5d6k7.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 10:33:24 +0200
Message-ID: <1281256404.3697.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-08-08 at 08:20 +0300, Kalle Valo wrote:
> Christian Lamparter <chunkeey@googlemail.com> writes:
> 
> > I got this from slub_debug:
> >
> > [ 2857.899976] phy2: device now idle
> > [ 2857.904032] =============================================================================
> > [ 2857.909760] cfg80211: Calling CRDA to update world regulatory domain
> > [ 2857.917337] BUG kmalloc-4096: Object already free
> > [ 2857.917337] -----------------------------------------------------------------------------
> > [ 2857.917337] 
> > [ 2857.917337] INFO: Allocated in wireless_send_event+0x22a/0x34a age=4 cpu=1 pid=7527
> 
> 
> I have similar warnings with ath9k, using commit
> 0ca923bdb96b1fee4d1db90b3094a0cf36120056:
> 
> Aug  6 21:02:08 tukki kernel: [   71.172707] =============================================================================
> Aug  6 21:02:08 tukki kernel: [   71.172715] BUG kmalloc-4096: Object already free
> Aug  6 21:02:08 tukki kernel: [   71.172718] -----------------------------------------------------------------------------
> Aug  6 21:02:08 tukki kernel: [   71.172720] 
> Aug  6 21:02:08 tukki kernel: [   71.172732] INFO: Allocated in wireless_send_event+0x1f2/0x410 age=0 cpu=1 pid=3056

I wonder if this is in any way related to
commit 1235f504aaba2ebeabc863fdb3ceac764a317d47
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Mon Jul 26 13:09:16 2010 -0700

    netlink: netlink_recvmsg() fix


johannes


