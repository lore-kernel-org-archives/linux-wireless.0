Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:46855 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYKNGRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 01:17:13 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1133183rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 22:17:12 -0800 (PST)
Message-ID: <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com> (sfid-20081114_071717_774921_CFA367FF)
Date: Thu, 13 Nov 2008 22:17:11 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan McGee" <dpmcgee@gmail.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2008 at 9:46 PM, Dan McGee <dpmcgee@gmail.com> wrote:
> Also reported here a few times, I've been seeing this bug every time I
> try to load up the ath5k module in my kernel:
> http://www.kerneloops.org/search.php?search=ieee80211_register_hw&btnG=Function+Search
>
> If you guys have any suggestions, I'd love to hear them. I
> disassembled the code in question but am not very good with these
> things. It looks to be somewhere between lines 804-825 in
> net/mac80211/main.c.
>
> -Dan
>
> ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> ath5k_pci 0000:01:00.0: setting latency timer to 64
> ath5k_pci 0000:01:00.0: registered as ''
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<b80c1252>] :mac80211:ieee80211_register_hw+0x10f/0x2d6
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> Modules linked in: ath5k(+) mac80211
>
> Pid: 818, comm: modprobe Not tainted (2.6.27.6eee #3)
> EIP: 0060:[<b80c1252>] EFLAGS: 00010286 CPU: 0
> EIP is at ieee80211_register_hw+0x10f/0x2d6 [mac80211]

I don't know assembly but if you compile with debugging symbols you
can pin point the line at which your EIP points to with gdb.

Run

gdb /lib/modules/`uname -r`/kernel/net/mac80211.ko

Then

l *(ieee80211_register_hw+0x10f)

If our offsets are the same then its probably on line 791:

(gdb) l *(ieee80211_register_hw+0x10f)
0x2df is in ieee80211_register_hw (net/mac80211/main.c:791).
786             mdev->type = ARPHRD_IEEE80211;
787             mdev->header_ops = &ieee80211_header_ops;
788             mdev->set_multicast_list = ieee80211_master_set_multicast_list;
789
790             name = wiphy_dev(local->hw.wiphy)->driver->name;
791             local->hw.workqueue = create_freezeable_workqueue(name);
792             if (!local->hw.workqueue) {
793                     result = -ENOMEM;
794                     goto fail_workqueue;
795             }

I have run into this before but on a very rare occasion and it was
with iwlagn,  and I wasn't able to find the culprit. Do you run into
this all the time?

  Luis
