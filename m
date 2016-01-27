Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:36527 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967397AbcA0TuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 14:50:11 -0500
MIME-Version: 1.0
In-Reply-To: <1453861388.11327.51.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1453830820-27104-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAGRGNgV7MUXdk+e8Arx05yiWX6owei5dmnFQ-TBfs55jfy+qBw@mail.gmail.com>
	<CAM_iQpWawou1Z_NnAzM5TxH7TUQUCAhf+k96PErNV8q_SOCShw@mail.gmail.com>
	<1453861388.11327.51.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Wed, 27 Jan 2016 11:50:10 -0800
Message-ID: <CAM_iQpXOEQhwPp6HD3L16DV1tygEyKNoHH+zHkukux7zYzaJeA@mail.gmail.com> (sfid-20160127_205114_502421_A7A66BB7)
Subject: Re: [PATCH RESEND net] nfc: use GFP_USER for user-controlled kmalloc
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	netdev <netdev@vger.kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2016 at 6:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Tue, 2016-01-26 at 15:12 -0800, Cong Wang wrote:
>> On Tue, Jan 26, 2016 at 2:55 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> > Hi Cong,
>> >
>> > On Wed, Jan 27, 2016 at 4:53 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> >
>> > A commit message would be nice. A brief rundown of how this is called
>> > from userspace would be nice (I'm talking a single sentence here, e.g.
>> > "this is allocated when submitting a nfc packet") and what issue
>> > __GFP_NOWARN is fixing. (I'm guessing log spam due to allocation
>> > failures.)
>> >
>>
>> I thought it is obvious. ;) Keep in mind that $subject is one part of commit
>> message too, so there is a commit message although very short.
>>
>> I will add it.
>
>
> BTW, kzalloc() is useless here, since it is followed by
>
> if (memcpy_from_msg(msg_data, msg, len)) {

Hmm? I think nfc_llcp_send_ui_frame() needs to do some fragmention
with this temporary memory, or you are saying msg_iter has some
API available to seek the pointer? Even if so, it doesn't look like
suitable for -stable.

>
> Also, this file seems to have two spots with the same problem,
> in nfc_llcp_send_ui_frame() & nfc_llcp_send_i_frame()
>

Ah, yes, I missed nfc_llcp_send_i_frame().
