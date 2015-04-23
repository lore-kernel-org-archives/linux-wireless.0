Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36848 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbbDWMsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 08:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1504231114290.3695@pobox.suse.cz>
References: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz>
	<1429764440.4084.5.camel@intel.com>
	<alpine.LNX.2.00.1504231011500.3695@pobox.suse.cz>
	<1429780366.11859.1.camel@intel.com>
	<alpine.LNX.2.00.1504231114290.3695@pobox.suse.cz>
Date: Thu, 23 Apr 2015 14:48:49 +0200
Message-ID: <CA+uBNfxXoLj9Nfss+j1G3PY9A2t=N6KRiYUAdoxiUOZvigwyAw@mail.gmail.com> (sfid-20150423_144855_458377_389EBD10)
Subject: Re: iwlwifi getting stuck with current Linus' tree (646da63172)
From: Piotr Karbowski <piotr.karbowski@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Thu, Apr 23, 2015 at 11:15 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 23 Apr 2015, Grumbach, Emmanuel wrote:
>
>> > I will try it, but I expect the result to be bogus because of this,
>> > unfortunately.
>>
>> I can understand. A few users reported that this bug occurred more
>> reliably when moving their system, although it seems very weird to me.
>
> My "feeling" was that it sometimes was related to start of audio playback,
> but not 100% relieble either.
>
>> > > First question is: Are you sure that 4.0-rc6 was good?
>> >
>> > Pretty much, yes. I've been running it for quite some time on this
>> > machine without any issues. But after updating to current HEAD two days
>> > ago, the issue triggered like 6 or 7 times already.
>>
>> Ok - I will try to look at the PCI commits there although I am not sure
>> I'll be able to make much sense of them...
>
> Thanks,

i've also started noticing hard system lockups with iwlwifi. What's
worth noticing is that I've started to see this on 3.19 and I also
have it on 4.0 kernel thus allow me to report it in this very thread.
I had over month uptime, untill I've updated iwl ucode, maybe this was
introduced not by kernel but firmware?. The lockups are random and
result in hard system lockup, frozen Xorg, screen artifacts/glitches,
audio playback keeps repeating last second or so of music, sysrq
cannot handle it as well as auto-reboot after kernel panic does not
kicks in.

The hardware I see this problem on is iwl 7260. The only workaround
I've found so far was to disable power save via `iw dev wlan0 set
power_save off` and not a single lockup since. What's rather
disturbing is that by 'modinfo iwlwifi' it does say that power_save is
default off, but it is not. I am sure that nothing else enables
power_save on my system because I don't even have udev, and for the
test I've also disabled wicd, then simple `modprobe iwlwifi` and `iw
dev wlan0 get power_save` reports 'on'.

I also have another system iwl 6205 and no single lockup was noted,
but it indeed have power_save disabled, so that may be the case.

-- Piotr.
