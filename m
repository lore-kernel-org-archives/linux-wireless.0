Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:49417 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3GKVCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 17:02:43 -0400
Received: by mail-qe0-f50.google.com with SMTP id f6so4697095qej.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jul 2013 14:02:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130625142514.GA1938@redhat.com>
References: <20120503182853.GA12461@mac.home> <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com> <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com> <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com> <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com> <20130625142514.GA1938@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Thu, 11 Jul 2013 22:02:22 +0100
Message-ID: <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com> (sfid-20130711_230246_886440_6A7CA748)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1On Tue, Jun 25, 2013 at 3:25 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Fri, Jun 14, 2013 at 03:18:29PM +0200, Stanislaw Gruszka wrote:
>> > >> I also got a SYSASSERT:
>> > >> (...)
>> > >>
>> > >> I disabled powersave (but kept running the same kernel) and none of
>> > >> the errors appeared again.
>> > >
>> > > Yes, this seems to be iwlegacy PS issue and has to be fixed before
>> > > this patch could be applied.
>> >
>> > But is it a driver-only issue? I had assumed it was some sort of
>> > fireware+driver issue...
>> Looks like driver issue or firmware issue that can be workaround in
>> the driver.
>>
>> > Will running with debug on help? Or is it easily reproducible on any
>> > iwl3945 / iwl4465 ?
>> >
>> > Because in my case (iwl3945) it happens after boot, no prior suspend
>> > to RAM is required to trigger the issues.
>> I can reproduce microcode error on iwl4965 by reloading modules. Looks
>> like we put device in sleep mode and it can not be properly booted when
>> driver initalize. I did not yet test patch on iwl3945. When I'll do
>> this, I think I'll be able to reproduce problems you discovered. If not
>> I'll ask for more debug info.
>
> I found problem on 4965, we have to send power configuration command to
> device earlier, before some other commands. Attached patch solved
> microcode errors I have on 4965.
>
> Regarding iwl3945. Display on my 3945 laptop no longer works. I took
> 3945 device from that laptop and installed it on two different machines.
> Unfortunately on none of them device was detected by pci system :-/
> I have figure out how to get working 3945 testing environment, but for
> now, perhaps you could provide me some more debug information.
>
> Pedro, please do the fallowing:
>
> Add this line in /etc/rsyslog.conf:
> kern.*                                                  /var/log/kernel
>
> Restart rsyslog services:
> # systemctl restart rsyslog.service
>
> Restart iwl3945 module with verbose debug enabled:
> modprobe -r iwl3945
> modprobe iwl3945 debug=0x47ffffff
>
> Reproduce the problem.
>
> Unload module:
> modprobe -r iwl3945
>
> Then provide me generated /var/log/kernel file (compressed if needed).

I seem only to be able to trigger it with disable_hw_scan=0, I need
further testing with disable_hw_scan=1 (I use disable_hw_scan=0
because it prevents me from getting disconnected from eduroam Cisco
APs -- haven't tested disable_hw_scan=0 since the VOIP-friendly SW
scanning patch, however).

Do you want the log anyway? (modprobe iwl3945 debug=0x47ffffff
disable_hw_scan=0 and runtime PCI powersave also enabled -- I don't
know if it matters).
--
Pedro
