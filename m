Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36468 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0HHJfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 05:35:10 -0400
Received: by iwn33 with SMTP id 33so2792173iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Aug 2010 02:35:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281256404.3697.2.camel@jlt3.sipsolutions.net>
References: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
	<20100806135057.GA2753@tuxdriver.com> <AANLkTi=Q6K1xeDn6zmBD5co5aMgvDMyUqGE3vLoo4_2+@mail.gmail.com>
	<201008072104.43784.chunkeey@googlemail.com> <874of5d6k7.fsf@purkki.adurom.net>
	<1281256404.3697.2.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 8 Aug 2010 02:34:49 -0700
Message-ID: <AANLkTik5TuYkkuXnw0+xGb3igtpwkinC0HmUVRbapo5r@mail.gmail.com>
Subject: Re: Odd BUG on wireless-testing master-2010-08-05
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@adurom.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 8, 2010 at 1:33 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2010-08-08 at 08:20 +0300, Kalle Valo wrote:
>> Christian Lamparter <chunkeey@googlemail.com> writes:
>>
>> > I got this from slub_debug:
>> >
>> > [ 2857.899976] phy2: device now idle
>> > [ 2857.904032] =============================================================================
>> > [ 2857.909760] cfg80211: Calling CRDA to update world regulatory domain
>> > [ 2857.917337] BUG kmalloc-4096: Object already free
>> > [ 2857.917337] -----------------------------------------------------------------------------
>> > [ 2857.917337]
>> > [ 2857.917337] INFO: Allocated in wireless_send_event+0x22a/0x34a age=4 cpu=1 pid=7527
>>
>>
>> I have similar warnings with ath9k, using commit
>> 0ca923bdb96b1fee4d1db90b3094a0cf36120056:
>>
>> Aug  6 21:02:08 tukki kernel: [   71.172707] =============================================================================
>> Aug  6 21:02:08 tukki kernel: [   71.172715] BUG kmalloc-4096: Object already free
>> Aug  6 21:02:08 tukki kernel: [   71.172718] -----------------------------------------------------------------------------
>> Aug  6 21:02:08 tukki kernel: [   71.172720]
>> Aug  6 21:02:08 tukki kernel: [   71.172732] INFO: Allocated in wireless_send_event+0x1f2/0x410 age=0 cpu=1 pid=3056
>
> I wonder if this is in any way related to
> commit 1235f504aaba2ebeabc863fdb3ceac764a317d47
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Mon Jul 26 13:09:16 2010 -0700
>
>    netlink: netlink_recvmsg() fix
>

FWIW using compat-wireless instead with the same code work swell.

 Luis
