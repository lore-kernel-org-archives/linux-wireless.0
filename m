Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdJPK1u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 06:27:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: usb/net/rt2x00: warning in rt2800_eeprom_word_index
References: <CAAeHK+yUNrrNU3Jqrfs7XAT809eyF4nv673cSL8RppbLrDtWNA@mail.gmail.com>
        <20171012072529.GB2686@redhat.com>
        <CACT4Y+YLM-u7bMfRB=eu_pz1M9iDrY-Qmnho7Hw_Lh3M=LSeMQ@mail.gmail.com>
Date: Mon, 16 Oct 2017 13:27:43 +0300
In-Reply-To: <CACT4Y+YLM-u7bMfRB=eu_pz1M9iDrY-Qmnho7Hw_Lh3M=LSeMQ@mail.gmail.com>
        (Dmitry Vyukov's message of "Sat, 14 Oct 2017 16:38:03 +0200")
Message-ID: <8760bfo09s.fsf@kamboji.qca.qualcomm.com> (sfid-20171016_122821_081647_A3620DA6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dmitry Vyukov <dvyukov@google.com> writes:

> On Thu, Oct 12, 2017 at 9:25 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> Hi
>>
>> On Mon, Oct 09, 2017 at 07:50:53PM +0200, Andrey Konovalov wrote:
>>> I've got the following report while fuzzing the kernel with syzkaller.
>>>
>>> On commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f (4.14-rc4).
>>>
>>> I'm not sure whether this is a bug in the driver, or just a way to
>>> report misbehaving device. In the latter case this shouldn't be a
>>> WARN() call, since WARN() means bug in the kernel.
>>
>> This is about wrong EEPROM, which reported 3 tx streams on
>> non 3 antenna device. I think WARN() is justified and thanks
>> to the call trace I was actually able to to understand what
>> happened.
>>
>> In general I do not think WARN() only means a kernel bug, it
>> can be F/W or H/W bug too.
>
> Hi Stanislaw,
>
> Printing messages is fine. Printing stacks is fine. Just please make
> them distinguishable from kernel bugs and don't kill the whole
> possibility of automated Linux kernel testing. That's an important
> capability.

Not really following you. Are you saying that using WARN() prevents
automated Linux kernel testing?

-- 
Kalle Valo
