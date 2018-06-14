Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:42540 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755427AbeFNU5F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 16:57:05 -0400
Received: by mail-qt0-f196.google.com with SMTP id y31-v6so7185610qty.9
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2018 13:57:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180614041517.1GPY0.168676.root@dnvrco-web14>
References: <20180612181932.KVWU0.184603.root@dnvrco-web01> <20180614041517.1GPY0.168676.root@dnvrco-web14>
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Thu, 14 Jun 2018 22:57:04 +0200
Message-ID: <CAFED-jn2jtR+9cdEzgKzzJgzNip=Sdh1DwdV4uW2tjFHWGCQiw@mail.gmail.com> (sfid-20180614_225709_714601_20AA8776)
Subject: Re: Atheros AR9462 - 5Ghz not working
To: mgreger@cinci.rr.com
Cc: sedat.dilek@gmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-06-14 6:15 GMT+02:00  <mgreger@cinci.rr.com>:
>
> ---- mgreger@cinci.rr.com wrote:
>>
>> ---- mgreger@cinci.rr.com wrote:
>> >
>> > ---- mgreger@cinci.rr.com wrote:
>> > >
>> > > ---- Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > > > On Tue, May 22, 2018 at 7:21 PM,  <mgreger@cinci.rr.com> wrote:
>> > > > > I've run out of ideas and am hoping someone here can help.
>> > > > >
>> > > > > All I want to do is connect a client to my 5Ghz network.
>> > > > >
>> > > > > My client:
>> > > > >   OS is Debian stable "Stretch" with sysvinit instead of systemd
>> > > > >   Atheros AR9462 (World roaming 0x64 regdomain in EEPROM)
>> > > > >   "iw reg set US"
>> > > > >   "iw list" shows both 2.4Ghz and 5Ghz bands available.
>> > > > >   "iw wlp3s0 survey dump" shows received traffic on 5Ghz bands.
>> > > > >
>> > > > > There are oodles of 5Ghz AP's within range, but scans (including passive scans) reveal only 2.4Ghz networks. My only guess was that it won't transmit due to regulatory requirements, but I cannot make it work.
>> > > > >
>> > > > > What I've tried:
>> > > > >   Running with and without CRDA
>> > > > >   Running latest mainline kernel
>> > > > >   Hacking around on the ath9k driver and nl80211 to remove all regulatory enforcement.
>> > > > >
>> > > > > Nothing works and I'm pulling my hair out. Any help would be greatly appreciated.
>> > > >
>> > > > Hi,
>> > > >
>> > > > I try to give some initial help.
>> > > >
>> > > > The linux-wireless driver is supported by ath9k driver see [1] and [2].
>> > > >
>> > > > Unfortunately, you have not sent any log-files at least your dmesg-log.
>> > > > No output of the above userspace commands or userspace-tools versions.
>> > > > No information to VendorID/ProductID (PCI, USB, whatever).
>> > > > It's not clear to me if this is a kernelspace (ath9k-driver) or
>> > > > userspace (CRDA/regulatory) problem.
>> > > > How should someone help you effectively?
>> > > >
>> > > > The linux-wireless wiki has somne informations on how to debug
>> > > > Atheros/Qualcomm ath9k-driver, see [3].
>> > > >
>> > > > As a debianist I say try Linux v4.16 Debian packages from
>> > > > stretch-backports (and maybe a higher version of wireless-regdb).
>> > > >
>> > > > Try to ask questions the smart way [4] :-).
>> > > >
>> > > > Hope this helps.
>> > > >
>> > > > Regards,
>> > > > - Sedat -
>> > > >
>> > > > [1] https://wireless.wiki.kernel.org/en/users/drivers/ath9k
>> > > > [2] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/devices
>> > > > [3] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/debug
>> > > > [4] http://www.catb.org/esr/faqs/smart-questions.html
>> > >
>> > >
>> > > I have also built the latest wireless-regdb and crda, but it made no difference.
>> >
>> >
>> >
>> > Did any of the information I posted point towards a cause?
>>
>>
>> Also, I'll gladly send one of these adapters to someone with ath9k experience if they suspect they can make it work.
>> Just message me.   :)
>
>
> I'm surprised at the apparent lack of interest in this by anybody whatsoever.
>
> Are there any other M.2 cards (both A and E keyed) on the market that support dual band with a fully open driver and requiring no proprietary firmware?
>
> Maybe it was too good to be true and there is no such thing?
>
>

Seems, pcie version works fine:
root@test4:~# lspci |grep Atheros
01:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network
Adapter (rev 01)
root@test4:~# iw wlp1s0 scan|grep "freq: 5"
    freq: 5180
    freq: 5180
    freq: 5180
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5620
    freq: 5745
    freq: 5785
    freq: 5785
    freq: 5745
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5200
    freq: 5200
    freq: 5220
    freq: 5220
    freq: 5785
    freq: 5180
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5540
    freq: 5540
    freq: 5540
    freq: 5540
    freq: 5540
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5200
    freq: 5200
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5220
    freq: 5240
    freq: 5540
    freq: 5540
    freq: 5540
    freq: 5660
    freq: 5745
    freq: 5745
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5785
    freq: 5200
    freq: 5220
    freq: 5785
    freq: 5785
root@test4:~# uname -a
Linux test4 4.17.0-rc7+ #5 SMP Mon May 28 12:35:22 CEST 2018 x86_64 GNU/Linux

Added:
ATH_USER_REGD - openwrt patch (4 returns in ath/regd.c)

I have this card (pcie version) in 10 laptops (in some 2,3 of them) -
working perfectly :)

BR
Janusz
