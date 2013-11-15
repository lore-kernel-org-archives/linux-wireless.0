Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:40071 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab3KOJEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:04:43 -0500
MIME-Version: 1.0
In-Reply-To: <5285E028.20906@gmail.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com> <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
 <CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
 <CAErSpo6xCUDqfvKB66nZJYBOWnZLEcSJ39+aTGnKKnuZP6+dRQ@mail.gmail.com>
 <CALkVjQaTnocYnV4GM=LHuYwMRZ=sOZnSrtna4C6anNAWr4O7=A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02E49@HASMSX103.ger.corp.intel.com>
 <CALkVjQZdPuE2F+ZARBLha-+iOMA4AjDWHO4=ssnuF2Uu87RyuQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02EC1@HASMSX103.ger.corp.intel.com>
 <CALkVjQbPTkGuEa8hLVZE0OVatw7ho=D+D51Qu68PRx-0dYay7w@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02FC6@HASMSX103.ger.corp.intel.com>
 <CAErSpo6bKOpycD=cp08aBqp2U-u7sdbTSBYoHop1-1Hkmr3F-g@mail.gmail.com>
 <CALkVjQaOHix5uxFGd-62negbfubz-rdP+zmj9w5wDEa1rCA75Q@mail.gmail.com> <5285E028.20906@gmail.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Fri, 15 Nov 2013 17:04:26 +0800
Message-ID: <CALkVjQYT9P--dgez064je4vM-xve4uF5ptOVVk3DuVoQiWQvew@mail.gmail.com> (sfid-20131115_100453_319420_575287D4)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"Bj?rn Mork" <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks a lot for explaination, Emmanuel!

Now I finally know why this is a "catch-22" situation: Disabling those
features with OS/drvier cannot be as neat as disabling them directly
in BIOS. And there may be chance, that disabling them at a bad timing
may cause G3...

--
wzyboy


2013/11/15 Emmanuel Grumbach <egrumbach@gmail.com>:
>
>
> On 11/15/2013 05:06 AM, wzyboy wrote:
>> 2013/11/15 Bjorn Helgaas <bhelgaas@google.com>:
>>> Why would it be unlikely to fix the driver?  Do people think the
>>> problem is not actually in the driver?
>>>
>>> Asking Lenovo how to disable L1 PM substates is really a non-answer.
>>> Only the extremely technical and extremely patient user (hi wzyboy :))
>>> will even bother to investigate why wifi works fine with Windows but
>>> not with Linux.  The only thing Lenovo *could* do is to release a new
>>> BIOS with a switch to control L1 PM Substates.  If I were Lenovo, I
>>> would never do that because then I would have to tell customers
>>> "disable this for Linux, enable this for Windows," and I'd have to
>>> deal with support calls about devices using more power than they
>>> should, battery life being shorter, etc.  Plus you'd have to ask every
>>> Linux user to upgrade their BIOS.  That's all just a terrible user
>>> experience.
>>
>>
>> I am a little confused. There are two sets of "setpci" commands, both
>> of which can make me use my NIC reliably. But you two say they are
>> just workarounds, not real fixes.
>>
>
> Right - because they force a mode that the BIOS doesn't allow. The BIOS
> doesn't allow the OS (the driver) to decide in what mode to work - so we
> cannot reach the same effect as the setpci command from the OS / driver
> level. setpci just directly accesses the HW without asking the
> permissions of anyone.
>
>> I know the "side effect" of first two "setpci" commands is consuming
>> more power. (Actually by my experience of running on battery, I did
>> not notice ...)
>>
>> But Grumbach said after the second two "setpci" commands enables "L1".
>> Does it mean it saves power? So what's the "side effect" of second two
>> "setpci" commands?
>>
>
> They are both the same in terms of side-effects. The first set of setpci
> commands will disable L1 altogether - meaning you don't save any power.
> The second set of setpci doesn't disable L1, but disable a more subtle
> power state (actually several) which are defined as L1 PM substates. In
> theses substates, you save less power than in L1 (I think) but you are
> more likely to be able to reach them. After all, it is always the same
> story - the deeper you sleep, you longer it takes to wake up. And if it
> takes longer to wake up, it also means that in several cases you won't
> chose to go to sleep. So the way PCI folks help to save power even in
> case where you cannot go to a deep sleep is to define states in the
> middle in which you save less power, but in which you are more likely to
> be. Again - time spent in each state and power saved in each state trade
> off.
> Now:
> L1 - deep sleep
> L1 PM substate - something in the middle.
>
> First setpci command - disable both features.
> Second setpci command - disable only the second feature.
>
> Regarding side effects... I don't think this is really "dangerous". But
> this is not a fix in the way that I wouldn't like to deploy millions of
> machines like that. The risk you have here is probably to have a bad
> timing and have the setpci commands run exactly when the link is in a
> state that setpci disables. That would be bad. How bad? Probably would
> just require a reboot - or worst case G3 (take the battery off).
>
>> IMHO, if this could user use their NIC reliably, maybe Grumbach may
>> write these commands to iwlwifi driver and run them when 7260 is
>> detected...
>
> I can't as exlained above.
>
>>
>> BTW, no replies from Lenovo, yet.
>>
>
>
>> Or maybe you could add an option, which enables this "workaround" if
>> user wants. A user could simply write a /etc/modprobe.d/iwlwifi.conf
>> and enable this "workaround", to use their NICs without having to
>> reboot from time to time...
>
> same.
>
