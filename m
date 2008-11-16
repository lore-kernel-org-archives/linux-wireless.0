Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:17187 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYKPCLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 21:11:13 -0500
Received: by yw-out-2324.google.com with SMTP id 9so844342ywe.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 18:11:12 -0800 (PST)
Message-ID: <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com> (sfid-20081116_031128_690962_EA9DA928)
Date: Sat, 15 Nov 2008 20:11:12 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 11:02 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Nov 14, 2008 at 1:17 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> If our offsets are the same then its probably on line 791:
> [...]
>> 790             name = wiphy_dev(local->hw.wiphy)->driver->name;
>> 791             local->hw.workqueue = create_freezeable_workqueue(name);
>
> I agree, having looked at the objdump output.  Hmm, maybe ->driver pointer
> is bad even though I can't see that happening.  Dan, can you try adding a
> printk before line 790 to see if any of the pointers are null?

So I went back and added a few things to the original unpatched code
to see what was NULL pointering, just to be sure we were thinking
right. Here is the relevant code:
        printk(KERN_DEBUG "wiphy_dev() : %p\n", wiphy_dev(local->hw.wiphy));
        printk(KERN_DEBUG "driver      : %p\n",
wiphy_dev(local->hw.wiphy)->driver);
        printk(KERN_DEBUG "driver->name: %p\n",
wiphy_dev(local->hw.wiphy)->driver->name);
        name = wiphy_dev(local->hw.wiphy)->driver->name;
        local->hw.workqueue = create_freezeable_workqueue(name);

And the dmesg output:
ath5k_pci xxx: registered as ''
wiphy_dev() : b730b408
driver       : 00000001
BUG: unalbe to handle kernel NULL pointer dereference at 00000001

So we bugged out on trying to print driver->name, which is the same
problem we would have hit in the 'name =' line.

-Dan
