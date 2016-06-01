Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34697 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcFAWIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 18:08:18 -0400
Received: by mail-qg0-f50.google.com with SMTP id p34so45370120qgp.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2016 15:08:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464787139.2554.74.camel@intel.com>
References: <20160529214059.GA15677@localhost>
	<CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com>
	<20160601125453.GB12977@localhost>
	<1464787139.2554.74.camel@intel.com>
Date: Wed, 1 Jun 2016 16:08:17 -0600
Message-ID: <CAAA5faFaPow=Rw-1btgag9wRV-ub8=np2FgpRsoF99MPyb7row@mail.gmail.com> (sfid-20160602_000822_261784_5256C4C8)
Subject: Re: wireless-testing on 4.7
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "me@bobcopeland.com" <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2016 at 7:19 AM, Coelho, Luciano
<luciano.coelho@intel.com> wrote:
> On Wed, 2016-06-01 at 08:54 -0400, Bob Copeland wrote:
>> + Luca, Emmanuel
>
> Thanks, Bob!
>
>
>> On Tue, May 31, 2016 at 10:06:57PM -0600, Reinoud Koornstra wrote:
>> > Today I compiled 4.6+ and pulled sources today
>> > iwlwifi isn't super smooth.
>>
>> I assume you mean wireless-testing, based on 4.7-rc1 (as this email
>> is
>> in reply to my announcement of same).
>
> Yes, we need to know exactly what kernel you're using so we know what
> we're debugging.
>

Yesterday this is what I did to obtain the latest source:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
kernel_current

This is the latest commit in that tree:

commit 367d3fd50566a313946fa9c5b2116a81bf3807e4
Merge: 5eca831 cf0d44d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 31 09:43:24 2016 -0700

   Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux

   Pull s390 fixes from Martin Schwidefsky:
    "Three bugs fixes and an update for the default configuration"

   * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux:
     s390: fix info leak in do_sigsegv
     s390/config: update default configuration
     s390/bpf: fix recache skb->data/hlen for skb_vlan_push/pop
     s390/bpf: reduce maximum program size to 64 KB

>> >
>> > [  112.345457] wlp4s0: authenticate with 00:30:44:1d:cf:2b
>> > [  112.349002] wlp4s0: send auth to 00:30:44:1d:cf:2b (try 1/3)
>> > [  112.349647] wlp4s0: authenticated
>> > [  112.352456] wlp4s0: associate with 00:30:44:1d:cf:2b (try 1/3)
>> > [  112.353764] wlp4s0: RX AssocResp from 00:30:44:1d:cf:2b
>> > (capab=0x11
>> > status=0 aid=3)
>> > [  112.355035] wlp4s0: associated
>> > [  112.355393] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes
>> > ready
>> > [  118.616327] wlp4s0: deauthenticated from 00:30:44:1d:cf:2b
>> > (Reason:
>> > 15=4WAY_HANDSHAKE_TIMEOUT)
>> > [  128.673812] wlp4s0: authenticate with 00:30:44:1d:cf:2b
>> > [  128.676997] wlp4s0: send auth to 00:30:44:1d:cf:2b (try 1/3)
>> > [  128.677648] wlp4s0: authenticated
>> > [  128.678691] wlp4s0: associate with 00:30:44:1d:cf:2b (try 1/3)
>> > [  128.679807] wlp4s0: RX AssocResp from 00:30:44:1d:cf:2b
>> > (capab=0x11
>> > status=0 aid=3)
>> > [  128.681198] wlp4s0: associated
>> >
>> > I never experienced the 4 way handshake 802.11i timeout in my home
>> > setup.
>> > With other setups plenty of times, especially with mediatek
>> > drivers. :)
>> > If you wish I can sniff and see which side is at fault.
>>
>> I have not noticed any problems on my laptop with iwldvm on a 6205,
>> with
>> latest wireless-testing.  But maybe intel devs can weigh in.
>
> I'm not going to put all my weight in lest I break things even more. :P
>
> I can't really see much from the log extract you posted.  Can you get
> some logs (especially trace-cmd and a sniffer capture) and report a bug
> in bugzilla? We have some instructions on how to do it here:
>
> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging
>

Ok, will do so, thanks,

Reinoud.

> Thanks for reporting!
>
> --
> Cheers,
> Luca.
