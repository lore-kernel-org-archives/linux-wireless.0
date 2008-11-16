Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:43838 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYKPCie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 21:38:34 -0500
Received: by gxk4 with SMTP id 4so1149247gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 18:38:33 -0800 (PST)
Message-ID: <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com> (sfid-20081116_033902_354235_80B8EFDA)
Date: Sat, 15 Nov 2008 20:38:32 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 8:11 PM, Dan McGee <dpmcgee@gmail.com> wrote:
> On Fri, Nov 14, 2008 at 11:02 AM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Fri, Nov 14, 2008 at 1:17 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> If our offsets are the same then its probably on line 791:
>> [...]
>>> 790             name = wiphy_dev(local->hw.wiphy)->driver->name;
>>> 791             local->hw.workqueue = create_freezeable_workqueue(name);
>>
>> I agree, having looked at the objdump output.  Hmm, maybe ->driver pointer
>> is bad even though I can't see that happening.  Dan, can you try adding a
>> printk before line 790 to see if any of the pointers are null?
>
> So I went back and added a few things to the original unpatched code
> to see what was NULL pointering, just to be sure we were thinking
> right. Here is the relevant code:
>        printk(KERN_DEBUG "wiphy_dev() : %p\n", wiphy_dev(local->hw.wiphy));
>        printk(KERN_DEBUG "driver      : %p\n",
> wiphy_dev(local->hw.wiphy)->driver);
>        printk(KERN_DEBUG "driver->name: %p\n",
> wiphy_dev(local->hw.wiphy)->driver->name);
>        name = wiphy_dev(local->hw.wiphy)->driver->name;
>        local->hw.workqueue = create_freezeable_workqueue(name);
>
> And the dmesg output:
> ath5k_pci xxx: registered as ''
> wiphy_dev() : b730b408
> driver       : 00000001
> BUG: unalbe to handle kernel NULL pointer dereference at 00000001
>
> So we bugged out on trying to print driver->name, which is the same
> problem we would have hit in the 'name =' line.

I should clarify here- the real bug was when trying to access
'->driver', as we got the 00000001 poison pointer returned (this is a
poison value, right?).

The above sequence of events was what took place when trying to load
the module on startup. To see if other things had an effect, I
disabled module autoloading during the boot sequence and got slightly
different results but it looks to be the same type of problem:

registered as ''
wiphy_dev: b730d740
driver: 7fffffff
driver->name: ffffffff
BUG: unable to handle kernel paging request at ffffffff

One more note- booting with the 2.6.27.6 shipped wireless modules
(mac80211 and ath5k) has always been working fine. It is only when I
try to run compat-wireless on top of this kernel that we are seeing
issues. Theoretically that means this should be bisectable if we
really can't figure it out, but I'm not sure how practical that is.

-Dan
