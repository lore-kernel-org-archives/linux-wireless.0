Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbeIKTbU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 15:31:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sid Hayn <sidhayn@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4.19] mt76x0: fix remove_interface
References: <1535970381-5526-1-git-send-email-sgruszka@redhat.com>
        <87y3cisq5g.fsf@purkki.adurom.net>
        <CAM0KTbAgj==H9SkoFF7WeSrh=TJHKFtuubf06JKSKoHoa4xV5w@mail.gmail.com>
        <20180904102352.GA978@redhat.com>
Date: Tue, 11 Sep 2018 17:31:42 +0300
In-Reply-To: <20180904102352.GA978@redhat.com> (Stanislaw Gruszka's message of
        "Tue, 4 Sep 2018 12:23:53 +0200")
Message-ID: <87d0tkrtpt.fsf@purkki.adurom.net> (sfid-20180911_163149_854383_443AAF77)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Mon, Sep 03, 2018 at 09:36:37AM -0400, Sid Hayn wrote:
>> Best I can say is that it seemed to happen after a failed connection.  It
>> would connect and disconnect a few times and work fine, but if it failed to
>> connect for any reason (mostly mismatched settings between AP and
>> wpa_supplicant.conf) then the bug would occur. So, wpa_supplicant would up
>> the interface, try to connect, fail, down the interface and exit, then the
>> next loop of my script (with a different conf file) would start and
>> wpa_supplicant would be unable to up the interface.
> <snip>
>> > For bug fixes please always try to describe the bug and symptoms. I can
>> > add it this time. From the other thread I saw that 'ifconfig up' failed
>> > like this:
>> >
>> > SIOCSIFFLAGS: No space left on device
>> >
>> > But in what cases did that happen? (I assume not always)
>
> Problem will happen when we remove interface more than 8 times.
> I'm not sure at how this can be triggerd execpt by doing:
>
> iw dev <devname> interface add <name> type <type>
> iw dev <name> del
>
> but looks somehow this is triggerd by Sid scripts
> by just by using wpa_supplicant and ifconfig. 

Good, thanks. So I'll use this as the commit message:

"We wrongly use wcid_mask instead of vif_mask. This creates problems
when the interface is removed more than 8 times, for example with iw:

iw dev <devname> interface add <name> type <type>
iw dev <name> del

This caused 'ifconfig up' to fail with error:

SIOCSIFFLAGS: No space left on device"

Does that look good?

-- 
Kalle Valo
