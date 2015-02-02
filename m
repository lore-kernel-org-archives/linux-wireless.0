Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:42366 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbbBBVTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 16:19:14 -0500
Received: by mail-la0-f45.google.com with SMTP id gd6so45228486lab.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 13:19:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAk3=uuvm7if9V6rKP0wsZ=JLJ7ivS7FF1HGP4PtsOXZ3_TAdA@mail.gmail.com>
References: <CAAk3=uumFdCe69HVPGp0TL6-RDuk58B5qxLxAsTOBCwY43fVkA@mail.gmail.com>
	<CAAk3=uvCn84yBEa+hUoX7Wp799-O-Xy6QJFgNiQwt3rH3PLsWQ@mail.gmail.com>
	<CANUX_P2CMvw4wZnpydPprw0=VwKMXBAcONSVyKSTcsnun=OCGQ@mail.gmail.com>
	<CAAk3=uv7ioMeLYU0YiChWNpWBQWJTqqEPONoMQzrJx=UoBY-1w@mail.gmail.com>
	<CANUX_P3pjqhNuX1e0WLe-B-gxnU4PTOFp=v3iNg_4H+NhTUF8A@mail.gmail.com>
	<CAAk3=uuvm7if9V6rKP0wsZ=JLJ7ivS7FF1HGP4PtsOXZ3_TAdA@mail.gmail.com>
Date: Mon, 2 Feb 2015 23:19:11 +0200
Message-ID: <CANUX_P0gZqyMH8zXfb-5qHVjWw+QrM+sBogG3GFSrjYwyFtbYA@mail.gmail.com> (sfid-20150202_221918_635367_FE9D07A5)
Subject: Re: [iwlwifi] fail to flush all tx queues on kernel 3.17.6
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Gerlof Fokkema <gerlof.fokkema@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2015 at 9:56 PM, Gerlof Fokkema <gerlof.fokkema@gmail.com> wrote:
>
> Dear Emmanuel,
>
> I have compiled and experimented with the kernel from this specific commit.
> While I don't get any crash logs from iwlmvm anymore, network performance is still truly horrible.
>
> After connecting the WiFi connection seems to work fine for a few minutes,
> and after that the network card does not seem to flush any data anymore.
> When running a ping job together with a download, fully utilizing WiFi, after a few minutes (or less) I get:
>
> 64 bytes from 172.16.2.1: icmp_seq=63 ttl=64 time=1476 ms
> 64 bytes from 172.16.2.1: icmp_seq=64 ttl=64 time=476 ms
> 64 bytes from 172.16.2.1: icmp_seq=65 ttl=64 time=10.6 ms
> 64 bytes from 172.16.2.1: icmp_seq=66 ttl=64 time=1558 ms
> 64 bytes from 172.16.2.1: icmp_seq=67 ttl=64 time=569 ms
> 64 bytes from 172.16.2.1: icmp_seq=68 ttl=64 time=9.97 ms
> ping: sendmsg: No buffer space available
> ping: sendmsg: No buffer space available
>
> It seems to me there is something fundamentally wrong with flushing network traffic,
> and with the newest commits it doesn't log these problems anymore either.
>
> This problem persists on linux 3.18.0 - 3.18.5 and on the aforementioned 3.19 branch.

Can you try with this firmware:
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/plain/iwlwifi-7260-10.ucode?id=d5cd7a6cb5f85f6234cca596354e440061a28aa4

Please copy the file to /lib/firmware/

you may want to back up the previous version first.

>
> Kind regards,
>
> Gerlof Fokkema
>
> On Thu, Jan 22, 2015 at 7:33 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>> Hi,
>>
>> On Thu, Jan 22, 2015 at 4:14 PM, Gerlof Fokkema
>> <gerlof.fokkema@gmail.com> wrote:
>> > Hello Emmanuel,
>> >
>> > First of all, thanks for your previous reply.
>> > I'm glad the issue is known and being looked at.
>> >
>> > Recently I tried linux kernel 3.18.2 on Arch linux and had the same
>> > issues I previously mentioned.
>> > Is there any bug report on this I can follow or any other way to be updated?
>> >
>>
>> This should help:
>> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=4e6c48e0984e28d064ee8fbc292aee7b7920c507
>>
>> >
>> > On Tue, Dec 30, 2014 at 3:30 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> >> Hi,
>> >>
>> >> Sorry for the delay. This one got lost in my inbox.
>> >>
>> >> On Sat, Dec 27, 2014 at 4:03 PM, Gerlof Fokkema
>> >> <gerlof.fokkema@gmail.com> wrote:
>> >>> Hi all,
>> >>>
>> >>> Since a few weeks I own a laptop with an Intel Wireless 7260 wireless adapter.
>> >>> I first noticed that my connection started dropping when I transferred
>> >>> large files over WiFi.
>> >>> Later on I noticed this problem when the signal strength was low as well.
>> >>>
>> >>> I seem to be experiencing the bug described here:
>> >>> https://bugzilla.kernel.org/show_bug.cgi?id=56581
>> >>
>> >> This bug relates to dvm - which is de-facto another driver. We made
>> >> this work around because
>> >> of firmware issues. These issues aren't supposed to happen on devices
>> >> supported by iwlmvm.
>> >> Obviously, they do. You are not the only one to report this issue.
>> >> I will discuss it with our firmware team.
>> >>
>> >>>
>> >>> However, if I read the changelogs correctly, this should've been fixed
>> >>> in 3.17.3.
>> >>>
>> >>> Atttached you'll find dmesg.log with the error.
>> >>> Excerpt:
>> >>> [  152.941067] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
>> >>> [  152.941072] iwlwifi 0000:03:00.0: Current SW read_ptr 209 write_ptr 234
>> >>> [  152.941097] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>> >>> 00 00 00 00  ................
>> >>> [  152.941111] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x80003000
>> >>> [  152.941125] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc01100f2
>> >>> [  152.941139] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
>> >>> When I try reconnecting to WiFi I get dozens more of those errors.
>> >>>
>> >>> Can someone point me in the right direction for this?
>> >>> Is there already a bugreport for this on kernel 3.17.6?
>> >>> Should you need more information, I'm happy to supply.
>> >>>
>> >>> For now I've reverted to 3.16.4, since it seems to work better...
>> >>
>> >> Probably because 3.16 uses an older firmware (-9.ucode).
>> >> This is also an interesting input - although I heard complaints about
>> >> this very same issue on -9.ucode as well.
>> >>
>> >>>
>> >>> Kind regards,
>> >>> Gerlof Fokkema
>
>
