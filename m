Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:33483 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYKPAMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 19:12:09 -0500
Received: by gxk4 with SMTP id 4so1126188gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 16:12:06 -0800 (PST)
Message-ID: <449c10960811151612y1ea36312p8192598bcbda674b@mail.gmail.com> (sfid-20081116_011214_420219_3C8C2FFE)
Date: Sat, 15 Nov 2008 18:12:05 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: mcgrof@gmail.com, m.sujith@gmail.com,
	linux-wireless@vger.kernel.org, mb@bu3sch.de,
	johannes@sipsolutions.net
In-Reply-To: <20081115181941.GD10702@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811141133o6d34c53fke3894a32cc1e5b8b@mail.gmail.com>
	 <43e72e890811141241k7ae83fc3qe90e2e42d61b8df6@mail.gmail.com>
	 <43e72e890811141313t33b6a3edo86488bea9a7b3371@mail.gmail.com>
	 <449c10960811141625o171d1e31v974d2f921f5a825@mail.gmail.com>
	 <20081115003608.GK27642@tesla>
	 <449c10960811141805w428df33ak2f98651abb7403e6@mail.gmail.com>
	 <20081115022913.GC10702@hash.localnet>
	 <449c10960811141857u2b0c4153h3735545dbec7ef8b@mail.gmail.com>
	 <449c10960811142229v77ea85f4nf898d447c7e63422@mail.gmail.com>
	 <20081115181941.GD10702@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 12:19 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Nov 15, 2008 at 12:29:34AM -0600, Dan McGee wrote:
>> On Fri, Nov 14, 2008 at 8:57 PM, Dan McGee <dpmcgee@gmail.com> wrote:
>> >
>> > BUG: unable to handle kernel NULL pointer dereference at 00000082
>> > IP: [<7818ca71>] sysfs_find_dirent+0x9/0x23
>> > Oops: 0000 [#1] PREEMPT
>> > Modules linked in: ath5k(+) mac80211
>
> So, just to recap, this is with Luis' patch; now you get a null pointer
> dereference in sysfs instead of in ieee80211_register_hw?  It does look
> like we're deep in register_netdevice now.  If you revert his patch, you
> can still get the error in register_hw every time?

Yeah, this is with Luis' patch. Without that patch it always bugs out
at the earlier step in register_hw(). And like I said, I can't
reproduce this one with debug symbols built into the kernel
unfortunately.

>> > Pid: 818 comm: modprobe Not tainted (2.6.27.6eee #1)
>> > EIP: 0060:[<7818ca71>] EFLAGS: 00010206 CPU: 0
>> > EIP is at sysfs_find_dirent+0x9/0x23
>> > EAX: 00000001 EBX: 00000072 ECX: 00000001 EDX: b730b4f0
>> > ESI: b730b4f0 EDI: fffffff4 EBP: b7311490 ESP: b73ffd34
>
> EBX is 00000072, definitely not a pointer.
>
>> And I had the code completely wrong, oops. Looks like we are bailing
>> on the strcmp call in this function or something along those lines? I
>> wish I could be a bigger help with debugging this stuff.
>
> Yep, or at least in the setup code for that.  Don't worry, you're being
> a big help; I think we just don't have a good enough theory yet to
> propose decent debugging patches.
>
>> struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
>>                                        const unsigned char *name)
>> {
>>  1bc:   56                      push   %esi
>>  1bd:   89 d6                   mov    %edx,%esi
>>  1bf:   53                      push   %ebx
>>         struct sysfs_dirent *sd;
>>
>>         for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling)
>>  1c0:   8b 58 18                mov    0x18(%eax),%ebx
>>  1c3:   eb 11                   jmp    1d6 <sysfs_find_dirent+0x1a>
>>                 if (!strcmp(sd->s_name, name))
>>  1c5:   8b 43 10                mov    0x10(%ebx),%eax
>
> EBX appears to be sd (it's initialized at line 1c0 to parent_sd + 0x18,
> which is &parent_sd->s_dir.children, then it jumps to the loop test).
> Thus EAX must be sd->s_sibling, which we hope to use for strcmp.
>
> So, while traversing the sibling pointers, one of them happens to be
> 00000072 (instead of what should probably have been NULL).  0x72 is not
> a poison value I'm aware of.  At this point, things have gone south, but
> the real problem happened earlier.

Yeah, I figured it was something earlier that didn't quite work out,
but I really had no idea where to start poking.

> Can you post your .config?

Sure- here it is: http://www.toofishes.net/uploads/kernelconfig

-Dan
