Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62800 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3KDJmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 04:42:18 -0500
Received: by mail-wg0-f51.google.com with SMTP id l18so1836379wgh.30
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 01:42:16 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CALkVjQaTvnn+boD+8eaTRrTm4bZOfMC3mx8Ng972ShoNq7EimQ@mail.gmail.com>
References: <5276134B.8070808@wzyboy.org>
	<0BA3FCBA62E2DC44AF3030971E174FB301DE75AE@HASMSX103.ger.corp.intel.com>
	<CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
	<CALkVjQaTvnn+boD+8eaTRrTm4bZOfMC3mx8Ng972ShoNq7EimQ@mail.gmail.com>
Date: Mon, 4 Nov 2013 10:42:16 +0100
Message-ID: <CA+icZUUZo0rh45+cbkABXdHRrRuOFC_+kmdmYQWbaOLwDp7RMg@mail.gmail.com> (sfid-20131104_104221_359152_BFCE7C75)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
From: Sedat Dilek <sedat.dilek@gmail.com>
To: wzyboy <wzyboy@wzyboy.org>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 4, 2013 at 10:21 AM, wzyboy <wzyboy@wzyboy.org> wrote:
> Here is a text/plain version of mail since the mail gateway at
> kernel.org does not accept any html mail.
>

Hi,

Here two hints for "correct asking" on Linux-related mailing-lists:

Documentation/email-clients.txt [1] says:

"The default setting of not composing in HTML is appropriate; do not
enable it."

Documentation/development-process/2.Process [2] says:

"- Avoid top-posting (the practice of putting your answer above the quoted
  text you are responding to).  It makes your response harder to read and
  makes a poor impression."

Checkout Documentation/ directory for more help/hints.

Regards,
- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/email-clients.txt#n89
[2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/development-process/2.Process#n426

> --
> wzyboy
>
>
> ---------- Forwarded message ----------
> From: wzyboy <wzyboy@wzyboy.org>
> Date: 2013/11/4
> Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
> To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
> Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
> "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
>
>
> Hi,
>
> thanks for your quick reply.
>
> On receiving your email 23 hours ago, I set that option in modprobe
> and rebooted my laptop. It works fine till just now when that bug
> occurs again when I was just viewing some man-page. Then I have to
> reboot my laptop to bring network back alive, in order to reply you
> this email :-)
>
> I've attached the lasted systemd journal, it seems a little different
> from yesterday's dmesg log... Could you take a look at it? And I found
> that every time I boot up my laptop there is a little line of message
> like:
>
> Nov 04 17:07:36 xenien kernel: iwlwifi 0000:03:00.0: can't disable
> ASPM; OS doesn't have ASPM control
>
> Does it have something to do with the bug?
>
> Though this bug only occurs at a frequency of ~1 per day but it's
> somewhat unexpected and annoying... ;-(
>
> Sincere regards.
>
> --
> wzyboy
>
>
> 2013/11/3 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>
>
>> >
>> > Hi, there.
>> >
>> > I am encountering some bugs with iwlwifi.ko in Linux 3.11.6.
>> >
>> > My laptop is a ThinkPad X240s with Network controller Intel Corporation
>> > Wireless 7260 (rev 6b). I have Arch Linux with kernel 3.11.6 installed on it. The
>> > wireless works out-of-box, thanks for your work!
>> >
>> > However, after using wireless for some time (could be either an hour with
>> > normal web page browsing, or several hours with heavy Internet
>> > downloading), the wireless works abnormally. The sympton is that every
>> > connection get lost, and the hardware "timed out" when I try to take down
>> > or take up the interface with `ip link set wlan0 down' or `ip link set wlan0 up'.
>> > When this bug occurs, even reloading the kernel modules (with `modprobe')
>> > could not bring the wireless back alive. What I could only do is to reboot the
>> > laptop.
>> >
>> > After encountering this bug for several times, I found something useful in
>> > `dmesg', as I've attached. Please take a look at the log and find out then
>> > squash this bug.
>> >
>>
>> How easily can you reproduce the bug?
>> Can you please try to see if this work around can help?
>> Add
>> options iwlmvm power_scheme=1
>>
>> in a .conf file under /etc/modprobe.d/
>>
>> Thanks.
>>
