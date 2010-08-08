Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60360 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0HHFUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 01:20:12 -0400
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: Odd BUG on wireless-testing master-2010-08-05
References: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
	<20100806135057.GA2753@tuxdriver.com>
	<AANLkTi=Q6K1xeDn6zmBD5co5aMgvDMyUqGE3vLoo4_2+@mail.gmail.com>
	<201008072104.43784.chunkeey@googlemail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 08 Aug 2010 08:20:08 +0300
In-Reply-To: <201008072104.43784.chunkeey@googlemail.com> (Christian Lamparter's message of "Sat\, 7 Aug 2010 21\:04\:43 +0200")
Message-ID: <874of5d6k7.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> I got this from slub_debug:
>
> [ 2857.899976] phy2: device now idle
> [ 2857.904032] =============================================================================
> [ 2857.909760] cfg80211: Calling CRDA to update world regulatory domain
> [ 2857.917337] BUG kmalloc-4096: Object already free
> [ 2857.917337] -----------------------------------------------------------------------------
> [ 2857.917337] 
> [ 2857.917337] INFO: Allocated in wireless_send_event+0x22a/0x34a age=4 cpu=1 pid=7527


I have similar warnings with ath9k, using commit
0ca923bdb96b1fee4d1db90b3094a0cf36120056:

Aug  6 21:02:08 tukki kernel: [   71.172707] =============================================================================
Aug  6 21:02:08 tukki kernel: [   71.172715] BUG kmalloc-4096: Object already free
Aug  6 21:02:08 tukki kernel: [   71.172718] -----------------------------------------------------------------------------
Aug  6 21:02:08 tukki kernel: [   71.172720] 
Aug  6 21:02:08 tukki kernel: [   71.172732] INFO: Allocated in wireless_send_event+0x1f2/0x410 age=0 cpu=1 pid=3056
Aug  6 21:02:08 tukki kernel: [   71.172741] INFO: Freed in skb_release_data+0xd0/0xe0 age=0 cpu=0 pid=3336
Aug  6 21:02:08 tukki kernel: [   71.172747] INFO: Slab 0xffffea00039af7c0 objects=7 used=3 fp=0xffff880107b4c120 flags=0x80000000000040c3
Aug  6 21:02:08 tukki kernel: [   71.172752] INFO: Object 0xffff880107b4c120 @offset=16672 fp=0xffff880107b4b0d8
Aug  6 21:02:08 tukki kernel: [   71.172754] 
Aug  6 21:02:08 tukki kernel: [   71.172757] Bytes b4 0xffff880107b4c110:  9d a6 ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .¦ÿÿ....ZZZZZZZZ
Aug  6 21:02:08 tukki kernel: [   71.172785]   Object 0xffff880107b4c120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.172812]   Object 0xffff880107b4c130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.172839]   Object 0xffff880107b4c140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.172866]   Object 0xffff880107b4c150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.172893]   Object 0xffff880107b4c160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.172919]   Object 0xffff880107b4c170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.172946]   Object 0xffff880107b4c180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.172973]   Object 0xffff880107b4c190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173000]   Object 0xffff880107b4c1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173027]   Object 0xffff880107b4c1b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173053]   Object 0xffff880107b4c1c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173080]   Object 0xffff880107b4c1d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173107]   Object 0xffff880107b4c1e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173134]   Object 0xffff880107b4c1f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173161]   Object 0xffff880107b4c200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173188]   Object 0xffff880107b4c210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173215]   Object 0xffff880107b4c220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173242]   Object 0xffff880107b4c230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173269]   Object 0xffff880107b4c240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173295]   Object 0xffff880107b4c250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173322]   Object 0xffff880107b4c260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173349]   Object 0xffff880107b4c270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173376]   Object 0xffff880107b4c280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173403]   Object 0xffff880107b4c290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173430]   Object 0xffff880107b4c2a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173457]   Object 0xffff880107b4c2b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173483]   Object 0xffff880107b4c2c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173510]   Object 0xffff880107b4c2d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173537]   Object 0xffff880107b4c2e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173564]   Object 0xffff880107b4c2f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173591]   Object 0xffff880107b4c300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173617]   Object 0xffff880107b4c310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173644]   Object 0xffff880107b4c320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173671]   Object 0xffff880107b4c330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173698]   Object 0xffff880107b4c340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173725]   Object 0xffff880107b4c350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173752]   Object 0xffff880107b4c360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173779]   Object 0xffff880107b4c370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173806]   Object 0xffff880107b4c380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173833]   Object 0xffff880107b4c390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173860]   Object 0xffff880107b4c3a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173886]   Object 0xffff880107b4c3b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173913]   Object 0xffff880107b4c3c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173940]   Object 0xffff880107b4c3d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173967]   Object 0xffff880107b4c3e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.173994]   Object 0xffff880107b4c3f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174021]   Object 0xffff880107b4c400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174048]   Object 0xffff880107b4c410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174074]   Object 0xffff880107b4c420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174102]   Object 0xffff880107b4c430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174128]   Object 0xffff880107b4c440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174155]   Object 0xffff880107b4c450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174182]   Object 0xffff880107b4c460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174209]   Object 0xffff880107b4c470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174236]   Object 0xffff880107b4c480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174263]   Object 0xffff880107b4c490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174290]   Object 0xffff880107b4c4a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174317]   Object 0xffff880107b4c4b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174343]   Object 0xffff880107b4c4c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174370]   Object 0xffff880107b4c4d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174397]   Object 0xffff880107b4c4e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174424]   Object 0xffff880107b4c4f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174451]   Object 0xffff880107b4c500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174478]   Object 0xffff880107b4c510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174504]   Object 0xffff880107b4c520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174531]   Object 0xffff880107b4c530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174558]   Object 0xffff880107b4c540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174585]   Object 0xffff880107b4c550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174612]   Object 0xffff880107b4c560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174638]   Object 0xffff880107b4c570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174665]   Object 0xffff880107b4c580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174692]   Object 0xffff880107b4c590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174719]   Object 0xffff880107b4c5a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174746]   Object 0xffff880107b4c5b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174773]   Object 0xffff880107b4c5c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174800]   Object 0xffff880107b4c5d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174826]   Object 0xffff880107b4c5e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174853]   Object 0xffff880107b4c5f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174880]   Object 0xffff880107b4c600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174907]   Object 0xffff880107b4c610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174934]   Object 0xffff880107b4c620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174960]   Object 0xffff880107b4c630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.174987]   Object 0xffff880107b4c640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175014]   Object 0xffff880107b4c650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175041]   Object 0xffff880107b4c660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175068]   Object 0xffff880107b4c670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175095]   Object 0xffff880107b4c680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175122]   Object 0xffff880107b4c690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175148]   Object 0xffff880107b4c6a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175175]   Object 0xffff880107b4c6b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175202]   Object 0xffff880107b4c6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175229]   Object 0xffff880107b4c6d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175256]   Object 0xffff880107b4c6e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175283]   Object 0xffff880107b4c6f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175309]   Object 0xffff880107b4c700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175336]   Object 0xffff880107b4c710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175363]   Object 0xffff880107b4c720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175390]   Object 0xffff880107b4c730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175417]   Object 0xffff880107b4c740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175444]   Object 0xffff880107b4c750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175471]   Object 0xffff880107b4c760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175497]   Object 0xffff880107b4c770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175524]   Object 0xffff880107b4c780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175551]   Object 0xffff880107b4c790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175578]   Object 0xffff880107b4c7a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175605]   Object 0xffff880107b4c7b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175631]   Object 0xffff880107b4c7c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175658]   Object 0xffff880107b4c7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175685]   Object 0xffff880107b4c7e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175712]   Object 0xffff880107b4c7f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175739]   Object 0xffff880107b4c800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175766]   Object 0xffff880107b4c810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175792]   Object 0xffff880107b4c820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175819]   Object 0xffff880107b4c830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175846]   Object 0xffff880107b4c840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175873]   Object 0xffff880107b4c850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175900]   Object 0xffff880107b4c860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175926]   Object 0xffff880107b4c870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175953]   Object 0xffff880107b4c880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.175980]   Object 0xffff880107b4c890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176007]   Object 0xffff880107b4c8a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176034]   Object 0xffff880107b4c8b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176060]   Object 0xffff880107b4c8c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176087]   Object 0xffff880107b4c8d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176114]   Object 0xffff880107b4c8e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176141]   Object 0xffff880107b4c8f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176168]   Object 0xffff880107b4c900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176195]   Object 0xffff880107b4c910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176222]   Object 0xffff880107b4c920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176249]   Object 0xffff880107b4c930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176276]   Object 0xffff880107b4c940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176302]   Object 0xffff880107b4c950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176329]   Object 0xffff880107b4c960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176356]   Object 0xffff880107b4c970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176383]   Object 0xffff880107b4c980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176410]   Object 0xffff880107b4c990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176436]   Object 0xffff880107b4c9a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176463]   Object 0xffff880107b4c9b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176490]   Object 0xffff880107b4c9c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176517]   Object 0xffff880107b4c9d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176544]   Object 0xffff880107b4c9e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176570]   Object 0xffff880107b4c9f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176597]   Object 0xffff880107b4ca00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176624]   Object 0xffff880107b4ca10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176651]   Object 0xffff880107b4ca20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176678]   Object 0xffff880107b4ca30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176705]   Object 0xffff880107b4ca40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176731]   Object 0xffff880107b4ca50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176758]   Object 0xffff880107b4ca60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176785]   Object 0xffff880107b4ca70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176812]   Object 0xffff880107b4ca80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176839]   Object 0xffff880107b4ca90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176866]   Object 0xffff880107b4caa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176893]   Object 0xffff880107b4cab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176919]   Object 0xffff880107b4cac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176946]   Object 0xffff880107b4cad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.176973]   Object 0xffff880107b4cae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177000]   Object 0xffff880107b4caf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177027]   Object 0xffff880107b4cb00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177053]   Object 0xffff880107b4cb10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177080]   Object 0xffff880107b4cb20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177107]   Object 0xffff880107b4cb30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177134]   Object 0xffff880107b4cb40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177161]   Object 0xffff880107b4cb50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177188]   Object 0xffff880107b4cb60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177215]   Object 0xffff880107b4cb70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177242]   Object 0xffff880107b4cb80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177268]   Object 0xffff880107b4cb90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177295]   Object 0xffff880107b4cba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177322]   Object 0xffff880107b4cbb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177349]   Object 0xffff880107b4cbc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177376]   Object 0xffff880107b4cbd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177403]   Object 0xffff880107b4cbe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177429]   Object 0xffff880107b4cbf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177456]   Object 0xffff880107b4cc00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177483]   Object 0xffff880107b4cc10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177510]   Object 0xffff880107b4cc20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177537]   Object 0xffff880107b4cc30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177564]   Object 0xffff880107b4cc40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177591]   Object 0xffff880107b4cc50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177617]   Object 0xffff880107b4cc60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177644]   Object 0xffff880107b4cc70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177671]   Object 0xffff880107b4cc80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177698]   Object 0xffff880107b4cc90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177725]   Object 0xffff880107b4cca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177752]   Object 0xffff880107b4ccb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177779]   Object 0xffff880107b4ccc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177806]   Object 0xffff880107b4ccd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177833]   Object 0xffff880107b4cce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177859]   Object 0xffff880107b4ccf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177886]   Object 0xffff880107b4cd00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177913]   Object 0xffff880107b4cd10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177940]   Object 0xffff880107b4cd20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177967]   Object 0xffff880107b4cd30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.177994]   Object 0xffff880107b4cd40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178020]   Object 0xffff880107b4cd50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178047]   Object 0xffff880107b4cd60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178074]   Object 0xffff880107b4cd70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178101]   Object 0xffff880107b4cd80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178128]   Object 0xffff880107b4cd90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178155]   Object 0xffff880107b4cda0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178182]   Object 0xffff880107b4cdb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178209]   Object 0xffff880107b4cdc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178236]   Object 0xffff880107b4cdd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178262]   Object 0xffff880107b4cde0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178289]   Object 0xffff880107b4cdf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178316]   Object 0xffff880107b4ce00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178343]   Object 0xffff880107b4ce10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178370]   Object 0xffff880107b4ce20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178396]   Object 0xffff880107b4ce30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178423]   Object 0xffff880107b4ce40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178450]   Object 0xffff880107b4ce50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178477]   Object 0xffff880107b4ce60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178504]   Object 0xffff880107b4ce70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178530]   Object 0xffff880107b4ce80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178557]   Object 0xffff880107b4ce90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178584]   Object 0xffff880107b4cea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178611]   Object 0xffff880107b4ceb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178637]   Object 0xffff880107b4cec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178664]   Object 0xffff880107b4ced0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178691]   Object 0xffff880107b4cee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178718]   Object 0xffff880107b4cef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178745]   Object 0xffff880107b4cf00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178772]   Object 0xffff880107b4cf10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178798]   Object 0xffff880107b4cf20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178825]   Object 0xffff880107b4cf30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178852]   Object 0xffff880107b4cf40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178879]   Object 0xffff880107b4cf50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178906]   Object 0xffff880107b4cf60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178933]   Object 0xffff880107b4cf70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178959]   Object 0xffff880107b4cf80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.178986]   Object 0xffff880107b4cf90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179013]   Object 0xffff880107b4cfa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179040]   Object 0xffff880107b4cfb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179066]   Object 0xffff880107b4cfc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179093]   Object 0xffff880107b4cfd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179120]   Object 0xffff880107b4cfe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179147]   Object 0xffff880107b4cff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179174]   Object 0xffff880107b4d000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179201]   Object 0xffff880107b4d010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179227]   Object 0xffff880107b4d020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179254]   Object 0xffff880107b4d030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179281]   Object 0xffff880107b4d040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179308]   Object 0xffff880107b4d050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179335]   Object 0xffff880107b4d060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179362]   Object 0xffff880107b4d070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179389]   Object 0xffff880107b4d080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179415]   Object 0xffff880107b4d090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179442]   Object 0xffff880107b4d0a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179469]   Object 0xffff880107b4d0b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179496]   Object 0xffff880107b4d0c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179523]   Object 0xffff880107b4d0d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179550]   Object 0xffff880107b4d0e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179577]   Object 0xffff880107b4d0f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179603]   Object 0xffff880107b4d100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 21:02:08 tukki kernel: [   71.179630]   Object 0xffff880107b4d110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
Aug  6 21:02:08 tukki kernel: [   71.179657]  Redzone 0xffff880107b4d120:  bb bb bb bb bb bb bb bb                         »»»»»»»»        
Aug  6 21:02:08 tukki kernel: [   71.179683]  Padding 0xffff880107b4d160:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Aug  6 21:02:08 tukki kernel: [   71.179711] Pid: 3546, comm: ofonod Not tainted 2.6.35-wl+ #70
Aug  6 21:02:08 tukki kernel: [   71.179715] Call Trace:
Aug  6 21:02:08 tukki kernel: [   71.179724]  [<ffffffff811230a3>] print_trailer+0x103/0x160
Aug  6 21:02:08 tukki kernel: [   71.179731]  [<ffffffff81329d00>] ? skb_release_data+0xd0/0xe0
Aug  6 21:02:08 tukki kernel: [   71.179736]  [<ffffffff81123141>] object_err+0x41/0x50
Aug  6 21:02:08 tukki kernel: [   71.179742]  [<ffffffff8112535a>] __slab_free+0x1aa/0x2e0
Aug  6 21:02:08 tukki kernel: [   71.179748]  [<ffffffff8112559c>] kfree+0x10c/0x170
Aug  6 21:02:08 tukki kernel: [   71.179754]  [<ffffffff81329d00>] ? skb_release_data+0xd0/0xe0
Aug  6 21:02:08 tukki kernel: [   71.179760]  [<ffffffff81329d00>] skb_release_data+0xd0/0xe0
Aug  6 21:02:08 tukki kernel: [   71.179766]  [<ffffffff81356cc2>] ? netlink_recvmsg+0x4a2/0x500
Aug  6 21:02:08 tukki kernel: [   71.179772]  [<ffffffff813299ae>] __kfree_skb+0x1e/0xa0
Aug  6 21:02:08 tukki kernel: [   71.179778]  [<ffffffff81329ab4>] kfree_skb+0x44/0xa0
Aug  6 21:02:08 tukki kernel: [   71.179783]  [<ffffffff81356cc2>] netlink_recvmsg+0x4a2/0x500
Aug  6 21:02:08 tukki kernel: [   71.179790]  [<ffffffff81325f28>] ? sock_update_classid+0xe8/0x190
Aug  6 21:02:08 tukki kernel: [   71.179796]  [<ffffffff81325e98>] ? sock_update_classid+0x58/0x190
Aug  6 21:02:08 tukki kernel: [   71.179802]  [<ffffffff8132176d>] sock_recvmsg+0xfd/0x130
Aug  6 21:02:08 tukki kernel: [   71.179809]  [<ffffffff811082dc>] ? might_fault+0x5c/0xb0
Aug  6 21:02:08 tukki kernel: [   71.179815]  [<ffffffff81108325>] ? might_fault+0xa5/0xb0
Aug  6 21:02:08 tukki kernel: [   71.179821]  [<ffffffff811082dc>] ? might_fault+0x5c/0xb0
Aug  6 21:02:08 tukki kernel: [   71.179827]  [<ffffffff81322150>] __sys_recvmsg+0x140/0x2d0
Aug  6 21:02:08 tukki kernel: [   71.179834]  [<ffffffff8113cad3>] ? putname+0x33/0x50
Aug  6 21:02:08 tukki kernel: [   71.179839]  [<ffffffff81140642>] ? user_path_at+0x62/0xa0
Aug  6 21:02:08 tukki kernel: [   71.179846]  [<ffffffff8113679c>] ? vfs_fstatat+0x3c/0x80
Aug  6 21:02:08 tukki kernel: [   71.179851]  [<ffffffff811337f5>] ? fget_light+0xd5/0x2d0
Aug  6 21:02:08 tukki kernel: [   71.179857]  [<ffffffff81322589>] sys_recvmsg+0x49/0x80
Aug  6 21:02:08 tukki kernel: [   71.179865]  [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b
Aug  6 21:02:08 tukki kernel: [   71.179870] FIX kmalloc-4096: Object at 0xffff880107b4c120 not freed

Aug  6 23:38:01 tukki kernel: [ 4161.050145] =============================================================================
Aug  6 23:38:01 tukki kernel: [ 4161.050155] BUG kmalloc-4096: Object already free
Aug  6 23:38:01 tukki kernel: [ 4161.050158] -----------------------------------------------------------------------------
Aug  6 23:38:01 tukki kernel: [ 4161.050160] 
Aug  6 23:38:01 tukki kernel: [ 4161.050173] INFO: Allocated in wireless_send_event+0x1f2/0x410 age=0 cpu=1 pid=3056
Aug  6 23:38:01 tukki kernel: [ 4161.050182] INFO: Freed in skb_release_data+0xd0/0xe0 age=0 cpu=1 pid=4283
Aug  6 23:38:01 tukki kernel: [ 4161.050187] INFO: Slab 0xffffea00043f7600 objects=7 used=3 fp=0xffff880136b430d8 flags=0x80000000000040c3
Aug  6 23:38:01 tukki kernel: [ 4161.050192] INFO: Object 0xffff880136b430d8 @offset=12504 fp=0xffff880136b461b0
Aug  6 23:38:01 tukki kernel: [ 4161.050194] 
Aug  6 23:38:01 tukki kernel: [ 4161.050198] Bytes b4 0xffff880136b430c8:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
Aug  6 23:38:01 tukki kernel: [ 4161.050226]   Object 0xffff880136b430d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050253]   Object 0xffff880136b430e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050280]   Object 0xffff880136b430f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050308]   Object 0xffff880136b43108:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050335]   Object 0xffff880136b43118:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050362]   Object 0xffff880136b43128:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050389]   Object 0xffff880136b43138:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050416]   Object 0xffff880136b43148:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050443]   Object 0xffff880136b43158:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050471]   Object 0xffff880136b43168:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050498]   Object 0xffff880136b43178:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050525]   Object 0xffff880136b43188:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050551]   Object 0xffff880136b43198:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050578]   Object 0xffff880136b431a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050605]   Object 0xffff880136b431b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050632]   Object 0xffff880136b431c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050658]   Object 0xffff880136b431d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050685]   Object 0xffff880136b431e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050712]   Object 0xffff880136b431f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050739]   Object 0xffff880136b43208:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050765]   Object 0xffff880136b43218:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050792]   Object 0xffff880136b43228:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050819]   Object 0xffff880136b43238:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050846]   Object 0xffff880136b43248:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050873]   Object 0xffff880136b43258:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050899]   Object 0xffff880136b43268:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050926]   Object 0xffff880136b43278:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050953]   Object 0xffff880136b43288:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.050980]   Object 0xffff880136b43298:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051006]   Object 0xffff880136b432a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051033]   Object 0xffff880136b432b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051060]   Object 0xffff880136b432c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051086]   Object 0xffff880136b432d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051113]   Object 0xffff880136b432e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051140]   Object 0xffff880136b432f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051167]   Object 0xffff880136b43308:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051194]   Object 0xffff880136b43318:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051220]   Object 0xffff880136b43328:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051247]   Object 0xffff880136b43338:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051274]   Object 0xffff880136b43348:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051301]   Object 0xffff880136b43358:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051327]   Object 0xffff880136b43368:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051354]   Object 0xffff880136b43378:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051381]   Object 0xffff880136b43388:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051407]   Object 0xffff880136b43398:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051434]   Object 0xffff880136b433a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051461]   Object 0xffff880136b433b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051487]   Object 0xffff880136b433c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051514]   Object 0xffff880136b433d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051541]   Object 0xffff880136b433e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051568]   Object 0xffff880136b433f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051594]   Object 0xffff880136b43408:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051621]   Object 0xffff880136b43418:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051648]   Object 0xffff880136b43428:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051674]   Object 0xffff880136b43438:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051701]   Object 0xffff880136b43448:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051728]   Object 0xffff880136b43458:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051754]   Object 0xffff880136b43468:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051781]   Object 0xffff880136b43478:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051808]   Object 0xffff880136b43488:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051835]   Object 0xffff880136b43498:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051862]   Object 0xffff880136b434a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051888]   Object 0xffff880136b434b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051915]   Object 0xffff880136b434c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051942]   Object 0xffff880136b434d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051969]   Object 0xffff880136b434e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.051995]   Object 0xffff880136b434f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052022]   Object 0xffff880136b43508:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052049]   Object 0xffff880136b43518:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052076]   Object 0xffff880136b43528:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052103]   Object 0xffff880136b43538:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052130]   Object 0xffff880136b43548:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052157]   Object 0xffff880136b43558:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052183]   Object 0xffff880136b43568:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052210]   Object 0xffff880136b43578:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052237]   Object 0xffff880136b43588:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052264]   Object 0xffff880136b43598:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052291]   Object 0xffff880136b435a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052318]   Object 0xffff880136b435b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052344]   Object 0xffff880136b435c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052371]   Object 0xffff880136b435d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052398]   Object 0xffff880136b435e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052425]   Object 0xffff880136b435f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052452]   Object 0xffff880136b43608:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052479]   Object 0xffff880136b43618:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052505]   Object 0xffff880136b43628:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052532]   Object 0xffff880136b43638:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052559]   Object 0xffff880136b43648:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052586]   Object 0xffff880136b43658:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052613]   Object 0xffff880136b43668:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052639]   Object 0xffff880136b43678:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052666]   Object 0xffff880136b43688:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052693]   Object 0xffff880136b43698:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052720]   Object 0xffff880136b436a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052747]   Object 0xffff880136b436b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052773]   Object 0xffff880136b436c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052800]   Object 0xffff880136b436d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052827]   Object 0xffff880136b436e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052854]   Object 0xffff880136b436f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052881]   Object 0xffff880136b43708:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052907]   Object 0xffff880136b43718:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052934]   Object 0xffff880136b43728:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052961]   Object 0xffff880136b43738:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.052988]   Object 0xffff880136b43748:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053015]   Object 0xffff880136b43758:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053042]   Object 0xffff880136b43768:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053068]   Object 0xffff880136b43778:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053095]   Object 0xffff880136b43788:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053122]   Object 0xffff880136b43798:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053149]   Object 0xffff880136b437a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053176]   Object 0xffff880136b437b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053202]   Object 0xffff880136b437c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053229]   Object 0xffff880136b437d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053256]   Object 0xffff880136b437e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053283]   Object 0xffff880136b437f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053310]   Object 0xffff880136b43808:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053337]   Object 0xffff880136b43818:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053363]   Object 0xffff880136b43828:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053390]   Object 0xffff880136b43838:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053417]   Object 0xffff880136b43848:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053444]   Object 0xffff880136b43858:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053471]   Object 0xffff880136b43868:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053498]   Object 0xffff880136b43878:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053524]   Object 0xffff880136b43888:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053551]   Object 0xffff880136b43898:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053578]   Object 0xffff880136b438a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053605]   Object 0xffff880136b438b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053632]   Object 0xffff880136b438c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053658]   Object 0xffff880136b438d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053685]   Object 0xffff880136b438e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053712]   Object 0xffff880136b438f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053739]   Object 0xffff880136b43908:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053766]   Object 0xffff880136b43918:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053792]   Object 0xffff880136b43928:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053819]   Object 0xffff880136b43938:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053846]   Object 0xffff880136b43948:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053873]   Object 0xffff880136b43958:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053899]   Object 0xffff880136b43968:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053926]   Object 0xffff880136b43978:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053953]   Object 0xffff880136b43988:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.053979]   Object 0xffff880136b43998:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054006]   Object 0xffff880136b439a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054033]   Object 0xffff880136b439b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054060]   Object 0xffff880136b439c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054086]   Object 0xffff880136b439d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054113]   Object 0xffff880136b439e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054140]   Object 0xffff880136b439f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054167]   Object 0xffff880136b43a08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054193]   Object 0xffff880136b43a18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054220]   Object 0xffff880136b43a28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054247]   Object 0xffff880136b43a38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054274]   Object 0xffff880136b43a48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054300]   Object 0xffff880136b43a58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054327]   Object 0xffff880136b43a68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054354]   Object 0xffff880136b43a78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054380]   Object 0xffff880136b43a88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054407]   Object 0xffff880136b43a98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054434]   Object 0xffff880136b43aa8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054461]   Object 0xffff880136b43ab8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054488]   Object 0xffff880136b43ac8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054514]   Object 0xffff880136b43ad8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054541]   Object 0xffff880136b43ae8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054568]   Object 0xffff880136b43af8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054594]   Object 0xffff880136b43b08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054621]   Object 0xffff880136b43b18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054648]   Object 0xffff880136b43b28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054675]   Object 0xffff880136b43b38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054702]   Object 0xffff880136b43b48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054728]   Object 0xffff880136b43b58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054755]   Object 0xffff880136b43b68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054782]   Object 0xffff880136b43b78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054809]   Object 0xffff880136b43b88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054835]   Object 0xffff880136b43b98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054862]   Object 0xffff880136b43ba8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054889]   Object 0xffff880136b43bb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054916]   Object 0xffff880136b43bc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054942]   Object 0xffff880136b43bd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054969]   Object 0xffff880136b43be8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.054996]   Object 0xffff880136b43bf8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055023]   Object 0xffff880136b43c08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055049]   Object 0xffff880136b43c18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055076]   Object 0xffff880136b43c28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055103]   Object 0xffff880136b43c38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055130]   Object 0xffff880136b43c48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055157]   Object 0xffff880136b43c58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055183]   Object 0xffff880136b43c68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055210]   Object 0xffff880136b43c78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055237]   Object 0xffff880136b43c88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055264]   Object 0xffff880136b43c98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055290]   Object 0xffff880136b43ca8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055317]   Object 0xffff880136b43cb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055344]   Object 0xffff880136b43cc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055371]   Object 0xffff880136b43cd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055397]   Object 0xffff880136b43ce8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055424]   Object 0xffff880136b43cf8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055451]   Object 0xffff880136b43d08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055478]   Object 0xffff880136b43d18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055504]   Object 0xffff880136b43d28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055531]   Object 0xffff880136b43d38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055558]   Object 0xffff880136b43d48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055584]   Object 0xffff880136b43d58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055611]   Object 0xffff880136b43d68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055638]   Object 0xffff880136b43d78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055664]   Object 0xffff880136b43d88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055691]   Object 0xffff880136b43d98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055718]   Object 0xffff880136b43da8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055745]   Object 0xffff880136b43db8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055772]   Object 0xffff880136b43dc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055799]   Object 0xffff880136b43dd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055825]   Object 0xffff880136b43de8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055852]   Object 0xffff880136b43df8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055879]   Object 0xffff880136b43e08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055906]   Object 0xffff880136b43e18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055933]   Object 0xffff880136b43e28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055960]   Object 0xffff880136b43e38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.055986]   Object 0xffff880136b43e48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056013]   Object 0xffff880136b43e58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056040]   Object 0xffff880136b43e68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056067]   Object 0xffff880136b43e78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056094]   Object 0xffff880136b43e88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056121]   Object 0xffff880136b43e98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056147]   Object 0xffff880136b43ea8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056174]   Object 0xffff880136b43eb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056201]   Object 0xffff880136b43ec8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056228]   Object 0xffff880136b43ed8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056255]   Object 0xffff880136b43ee8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056281]   Object 0xffff880136b43ef8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056308]   Object 0xffff880136b43f08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056335]   Object 0xffff880136b43f18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056362]   Object 0xffff880136b43f28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056389]   Object 0xffff880136b43f38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056416]   Object 0xffff880136b43f48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056442]   Object 0xffff880136b43f58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056469]   Object 0xffff880136b43f68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056496]   Object 0xffff880136b43f78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056523]   Object 0xffff880136b43f88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056550]   Object 0xffff880136b43f98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056577]   Object 0xffff880136b43fa8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056603]   Object 0xffff880136b43fb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056630]   Object 0xffff880136b43fc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056657]   Object 0xffff880136b43fd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056684]   Object 0xffff880136b43fe8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056711]   Object 0xffff880136b43ff8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056737]   Object 0xffff880136b44008:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056764]   Object 0xffff880136b44018:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056791]   Object 0xffff880136b44028:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056818]   Object 0xffff880136b44038:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056844]   Object 0xffff880136b44048:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056871]   Object 0xffff880136b44058:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056898]   Object 0xffff880136b44068:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056925]   Object 0xffff880136b44078:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056951]   Object 0xffff880136b44088:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.056978]   Object 0xffff880136b44098:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.057005]   Object 0xffff880136b440a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.057032]   Object 0xffff880136b440b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:01 tukki kernel: [ 4161.057058]   Object 0xffff880136b440c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
Aug  6 23:38:01 tukki kernel: [ 4161.057085]  Redzone 0xffff880136b440d8:  bb bb bb bb bb bb bb bb                         »»»»»»»»        
Aug  6 23:38:01 tukki kernel: [ 4161.057111]  Padding 0xffff880136b44118:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Aug  6 23:38:01 tukki kernel: [ 4161.057139] Pid: 3679, comm: connmand Not tainted 2.6.35-wl+ #70
Aug  6 23:38:01 tukki kernel: [ 4161.057143] Call Trace:
Aug  6 23:38:01 tukki kernel: [ 4161.057152]  [<ffffffff811230a3>] print_trailer+0x103/0x160
Aug  6 23:38:01 tukki kernel: [ 4161.057159]  [<ffffffff81329d00>] ? skb_release_data+0xd0/0xe0
Aug  6 23:38:01 tukki kernel: [ 4161.057165]  [<ffffffff81123141>] object_err+0x41/0x50
Aug  6 23:38:01 tukki kernel: [ 4161.057171]  [<ffffffff8112535a>] __slab_free+0x1aa/0x2e0
Aug  6 23:38:01 tukki kernel: [ 4161.057176]  [<ffffffff8112559c>] kfree+0x10c/0x170
Aug  6 23:38:01 tukki kernel: [ 4161.057182]  [<ffffffff81329d00>] ? skb_release_data+0xd0/0xe0
Aug  6 23:38:01 tukki kernel: [ 4161.057188]  [<ffffffff81329d00>] skb_release_data+0xd0/0xe0
Aug  6 23:38:01 tukki kernel: [ 4161.057194]  [<ffffffff81356cc2>] ? netlink_recvmsg+0x4a2/0x500
Aug  6 23:38:01 tukki kernel: [ 4161.057200]  [<ffffffff813299ae>] __kfree_skb+0x1e/0xa0
Aug  6 23:38:01 tukki kernel: [ 4161.057206]  [<ffffffff81329ab4>] kfree_skb+0x44/0xa0
Aug  6 23:38:01 tukki kernel: [ 4161.057211]  [<ffffffff81356cc2>] netlink_recvmsg+0x4a2/0x500
Aug  6 23:38:01 tukki kernel: [ 4161.057218]  [<ffffffff81143fe0>] ? pollwake+0x0/0x60
Aug  6 23:38:01 tukki kernel: [ 4161.057224]  [<ffffffff81325f28>] ? sock_update_classid+0xe8/0x190
Aug  6 23:38:01 tukki kernel: [ 4161.057230]  [<ffffffff81325e98>] ? sock_update_classid+0x58/0x190
Aug  6 23:38:01 tukki kernel: [ 4161.057236]  [<ffffffff813207ad>] sock_aio_read+0x17d/0x190
Aug  6 23:38:01 tukki kernel: [ 4161.057242]  [<ffffffff81131673>] ? do_sync_readv_writev+0xd3/0x110
Aug  6 23:38:01 tukki kernel: [ 4161.057248]  [<ffffffff811318aa>] do_sync_read+0xda/0x120
Aug  6 23:38:01 tukki kernel: [ 4161.057255]  [<ffffffff8113cad3>] ? putname+0x33/0x50
Aug  6 23:38:01 tukki kernel: [ 4161.057262]  [<ffffffff811b56b6>] ? security_file_permission+0x16/0x20
Aug  6 23:38:01 tukki kernel: [ 4161.057268]  [<ffffffff811323b0>] vfs_read+0x180/0x1a0
Aug  6 23:38:01 tukki kernel: [ 4161.057273]  [<ffffffff81132421>] sys_read+0x51/0x90
Aug  6 23:38:01 tukki kernel: [ 4161.057280]  [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b
Aug  6 23:38:01 tukki kernel: [ 4161.057285] FIX kmalloc-4096: Object at 0xffff880136b430d8 not freed
Aug  6 23:38:13 tukki kernel: [ 4173.158669] =============================================================================
Aug  6 23:38:13 tukki kernel: [ 4173.158684] BUG kmalloc-4096: Object already free
Aug  6 23:38:13 tukki kernel: [ 4173.158689] -----------------------------------------------------------------------------
Aug  6 23:38:13 tukki kernel: [ 4173.158693] 
Aug  6 23:38:13 tukki kernel: [ 4173.158713] INFO: Allocated in wireless_send_event+0x1f2/0x410 age=0 cpu=0 pid=3056
Aug  6 23:38:13 tukki kernel: [ 4173.158728] INFO: Freed in skb_release_data+0xd0/0xe0 age=0 cpu=0 pid=4283
Aug  6 23:38:13 tukki kernel: [ 4173.158737] INFO: Slab 0xffffea0001ceccc0 objects=7 used=2 fp=0xffff8800843aa090 flags=0x40000000000040c3
Aug  6 23:38:13 tukki kernel: [ 4173.158745] INFO: Object 0xffff8800843aa090 @offset=8336 fp=0xffff8800843a8000
Aug  6 23:38:13 tukki kernel: [ 4173.158749] 
Aug  6 23:38:13 tukki kernel: [ 4173.158754] Bytes b4 0xffff8800843aa080:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
Aug  6 23:38:13 tukki kernel: [ 4173.158800]   Object 0xffff8800843aa090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.158844]   Object 0xffff8800843aa0a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.158889]   Object 0xffff8800843aa0b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.158934]   Object 0xffff8800843aa0c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.158979]   Object 0xffff8800843aa0d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159023]   Object 0xffff8800843aa0e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159067]   Object 0xffff8800843aa0f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159112]   Object 0xffff8800843aa100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159156]   Object 0xffff8800843aa110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159199]   Object 0xffff8800843aa120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159243]   Object 0xffff8800843aa130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159287]   Object 0xffff8800843aa140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159332]   Object 0xffff8800843aa150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159376]   Object 0xffff8800843aa160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159420]   Object 0xffff8800843aa170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159463]   Object 0xffff8800843aa180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159508]   Object 0xffff8800843aa190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159552]   Object 0xffff8800843aa1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159596]   Object 0xffff8800843aa1b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159641]   Object 0xffff8800843aa1c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159684]   Object 0xffff8800843aa1d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159728]   Object 0xffff8800843aa1e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159772]   Object 0xffff8800843aa1f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159816]   Object 0xffff8800843aa200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159860]   Object 0xffff8800843aa210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159903]   Object 0xffff8800843aa220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159947]   Object 0xffff8800843aa230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.159990]   Object 0xffff8800843aa240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160034]   Object 0xffff8800843aa250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160078]   Object 0xffff8800843aa260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160122]   Object 0xffff8800843aa270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160165]   Object 0xffff8800843aa280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160209]   Object 0xffff8800843aa290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160253]   Object 0xffff8800843aa2a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160297]   Object 0xffff8800843aa2b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160340]   Object 0xffff8800843aa2c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160384]   Object 0xffff8800843aa2d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160427]   Object 0xffff8800843aa2e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160471]   Object 0xffff8800843aa2f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160515]   Object 0xffff8800843aa300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160558]   Object 0xffff8800843aa310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160602]   Object 0xffff8800843aa320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160645]   Object 0xffff8800843aa330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160688]   Object 0xffff8800843aa340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160732]   Object 0xffff8800843aa350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160775]   Object 0xffff8800843aa360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160819]   Object 0xffff8800843aa370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160862]   Object 0xffff8800843aa380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160906]   Object 0xffff8800843aa390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160949]   Object 0xffff8800843aa3a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.160992]   Object 0xffff8800843aa3b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161036]   Object 0xffff8800843aa3c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161079]   Object 0xffff8800843aa3d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161123]   Object 0xffff8800843aa3e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161167]   Object 0xffff8800843aa3f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161210]   Object 0xffff8800843aa400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161253]   Object 0xffff8800843aa410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161297]   Object 0xffff8800843aa420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161340]   Object 0xffff8800843aa430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161383]   Object 0xffff8800843aa440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161427]   Object 0xffff8800843aa450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161470]   Object 0xffff8800843aa460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161514]   Object 0xffff8800843aa470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161557]   Object 0xffff8800843aa480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161600]   Object 0xffff8800843aa490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161644]   Object 0xffff8800843aa4a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161687]   Object 0xffff8800843aa4b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161731]   Object 0xffff8800843aa4c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161775]   Object 0xffff8800843aa4d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161818]   Object 0xffff8800843aa4e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161862]   Object 0xffff8800843aa4f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161905]   Object 0xffff8800843aa500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161949]   Object 0xffff8800843aa510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.161992]   Object 0xffff8800843aa520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162036]   Object 0xffff8800843aa530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162079]   Object 0xffff8800843aa540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162123]   Object 0xffff8800843aa550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162166]   Object 0xffff8800843aa560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162209]   Object 0xffff8800843aa570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162253]   Object 0xffff8800843aa580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162296]   Object 0xffff8800843aa590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162340]   Object 0xffff8800843aa5a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162384]   Object 0xffff8800843aa5b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162427]   Object 0xffff8800843aa5c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162471]   Object 0xffff8800843aa5d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa5e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa5f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa6a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa6b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa6d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa6e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa6f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa7a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa7b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa7c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa7e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa7f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa8a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa8b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa8c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa8d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa8e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa8f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa9a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa9b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa9c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa9d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa9e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aa9f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaa90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaaa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaaf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aab90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aabb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aabc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aabd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aabe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aabf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aac90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aacb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aacc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aacd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aace0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aacf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aad90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aada0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aadb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aadc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aadd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aade0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aadf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aae90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaeb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaf90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aafa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aafb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aafc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aafd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aafe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843aaff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Aug  6 23:38:13 tukki kernel: [ 4173.162511]   Object 0xffff8800843ab080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  Redzone 0xffff8800843ab090:  bb bb bb bb bb bb bb bb                         »»»»»»»»        
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  Padding 0xffff8800843ab0d0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Aug  6 23:38:13 tukki kernel: [ 4173.162511] Pid: 3679, comm: connmand Not tainted 2.6.35-wl+ #70
Aug  6 23:38:13 tukki kernel: [ 4173.162511] Call Trace:
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff811230a3>] print_trailer+0x103/0x160
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81329d00>] ? skb_release_data+0xd0/0xe0
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81123141>] object_err+0x41/0x50
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff8112535a>] __slab_free+0x1aa/0x2e0
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff8112559c>] kfree+0x10c/0x170
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81329d00>] ? skb_release_data+0xd0/0xe0
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81329d00>] skb_release_data+0xd0/0xe0
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81356cc2>] ? netlink_recvmsg+0x4a2/0x500
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff813299ae>] __kfree_skb+0x1e/0xa0
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81329ab4>] kfree_skb+0x44/0xa0
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81356cc2>] netlink_recvmsg+0x4a2/0x500
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81143fe0>] ? pollwake+0x0/0x60
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81325f28>] ? sock_update_classid+0xe8/0x190
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81325e98>] ? sock_update_classid+0x58/0x190
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff813207ad>] sock_aio_read+0x17d/0x190
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81131673>] ? do_sync_readv_writev+0xd3/0x110
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff811318aa>] do_sync_read+0xda/0x120
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff811b56b6>] ? security_file_permission+0x16/0x20
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff811323b0>] vfs_read+0x180/0x1a0
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81132421>] sys_read+0x51/0x90
Aug  6 23:38:13 tukki kernel: [ 4173.162511]  [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b
Aug  6 23:38:13 tukki kernel: [ 4173.162511] FIX kmalloc-4096: Object at 0xffff8800843aa090 not freed

-- 
Kalle Valo
