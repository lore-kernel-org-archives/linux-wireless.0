Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5190 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbcCPVNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 17:13:18 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: linuxwifi <linuxwifi@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	WCS WCD Linux SW Group Staff
	<wcs.wcd.linux.sw.group.staff@intel.com>,
	"Barash, Yair" <yair.barash@intel.com>,
	"Amir, Ido" <ido.amir@intel.com>
Subject: Re: iwlwifi incomplete initialization in Linux 4.5?
Date: Wed, 16 Mar 2016 21:13:13 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA7A541@hasmsx107.ger.corp.intel.com> (sfid-20160316_221322_852231_4B592E95)
References: <CA+55aFxOMO6u6xu4Pz7BzbLD=SwwzdPcSU2dX2S0kkh4jFaVbw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linus,

On 03/16/2016 10:48 PM, Linus Torvalds wrote:
> So I upgraded the firmware on my Intel NUC (NUC6i3SYK), and that made
> the wireless no longer work with a 4.5 kernel. I could get the
> occasional packets through, but not many, and ti would hang for ten
> seconds at a time, and then output errors like
> 
>   iwlwifi 0000:01:00.0: Queue 2 stuck for 10000 ms.
>   iwlwifi 0000:01:00.0: Current SW read_ptr 60 write_ptr 93
>   ..
> 

This ... typically means that the firmware got stuck while sending
packets. Can you tell me on what band your router operates? 2.4GHz or
5.2GHz?
Do you use 20Mhz or 40MHz?

Basically, I'd like to see the output of iw dev

> which was odd, because that kernel had worked fine before.

This is really firmware related.

> 
> I booted between two different kernels, going back to an older 4.5-rc3
> one that had been running a lot longer on that machine, because
> initially I thought that this was some recent kernel failure (I didn't
> initially connect it with the firmware upgrade, because this is my
> kids machine and I hadn't tested networking after the firmware
> update). But that older known-good kernel failed the same way.
> 
> Going all the way back to the 4.4 kernel that Fedora uses made
> wireless work, and then rebooting back into a 4.5 kernel also worked.
> 

Hmm, this is strange since 4.4 and 4.5 will both load -16.ucode which
you seemed to be running when the have the Queue hang message. So I'd
assume you have the same firmware running on both kernels. Sometimes, a
bug starts to appear on a new kernel, and people think the bug is in the
kernel, but in fact the newer kernel just loads a new firmware which has
a bug. In a way, it is a regression in the "system" caused by a kernel
upgrade, but the debug must be done on the firmware really.

FYI: the newest firmware a kernel supports is in:
drivers/net/wireless/intel/iwlwifi/iwl-X000.c
in your case: 8000.c:
#define IWL8000_UCODE_API_MAX   20

The newest firmware I released to distros is -16, so you load -16.
BTW - when you'll pull from davem, you be able to run -21.ucode which
has been merged into linux-firmware.git.

> Now, it's *possible* that it was just something odd and transient and
> it just happened to clear up as I rebooted into the Fedora kernel, but
> it feels more likely that there's some incomplete initialization in
> recent 4.5 kernels, which isn't normally noticeable, but the full
> system reset done as part of the firmware upgrade might have shown it.

While everything is possible especially when you have radio involved, it
would really surprise me.

> 
> I'm attaching all the iwlwifi debug output that goes along with the
> stuck queue, in the hopes that it makes sense to somebody. This is
> from the 4.5-rc3 boot into an older kernel, but final 4.5 showed the
> same behavior.

Sadly, the only sense it makes is that the firmware gets stuck.
>From that point, I can suggest you test different firmware versions
(including intermediate version that I haven't pushed to
linux-firmware.git). You can check the firmware versions from -16 to -21
in my linux-firmware.git clone:
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git
You need iwlwifi-8000C-XX.ucode

> 
> Googling iwlwifi stuck queues shows a lot of reports over the years,
> but it might be a common symptom of "something is screwed up".

Yeah... I can't claim it is the first time I see this. The good news is
that we have developed very powerful tools to debug this kind of
problems now and the firmware team can get what they need to address
those issues. The debugging and fix is outside my area of control though.

> 
> I'm not sure I can reproduce it any more now that it works again (and
> I'm not really willing to force a firmware downgrade), but if there is
> something particular to test, I can do that.

If you can reproduce, I can send you an instrumented firmware that can
record data in a cyclic buffer. When it will crash, it'll create a
devcoredump device which you can dump on the file system and send to me.
More details here:
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging#firmware_debugging

Please also look at the privacy notice.

But of course, if you can't reproduce, it won't really help. Let me know
if you want me to send you a firmware for debugging.

> 
> Ideas?
> 
>                             Linus
> 
