Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58566 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0JGTOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 15:14:14 -0400
Message-ID: <4CAE1C02.7090405@candelatech.com>
Date: Thu, 07 Oct 2010 12:14:10 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com> <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com> <4CAE1553.1070900@candelatech.com>
In-Reply-To: <4CAE1553.1070900@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2010 11:45 AM, Ben Greear wrote:
> On 10/07/2010 11:42 AM, Luis R. Rodriguez wrote:
>> On Thu, Oct 7, 2010 at 11:39 AM, Ben Greear<greearb@candelatech.com>
>> wrote:
>>> On 10/07/2010 11:29 AM, Luis R. Rodriguez wrote:
>>>>
>>>> On Thu, Oct 7, 2010 at 11:14 AM, Johannes Berg
>>>> <johannes@sipsolutions.net> wrote:
>>>>>
>>>>> On Thu, 2010-10-07 at 10:33 -0700, Ben Greear wrote:
>>>>>>
>>>>>> In case it helps, here is a dump of where the corrupted SKB was
>>>>>> deleted.
>>>>>
>>>>> I wonder, do you have a machine with a decent IOMMU? Adding IOMMU
>>>>> debugging into the mix could help you figure out if it's a DMA
>>>>> problem.
>>>>
>>>> Ben, how much traffic are you RX'ing on these virtual interfaces?
>>>
>>> I disabled my user-space application, and this script alone can
>>> reproduce
>>> the problem fairly quickly on my system. You will need to change some
>>> of those first variables. Just start it and wait a few minutes and
>>> watch the splats show on the console :)
>>>
>>> Note that I am not generating any traffic, but the wpa_supplicants are
>>> doing their thing of course...
>>>
>>> I'm using the kernel found here:
>>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux.wireless-testing.ct/.git;a=summary
>>>
>>>
>>> It's latest wireless-testing with some of my own patches, and some
>>> I've gathered from here an there. I doubt I'm causing this problem,
>>> but if you can't reproduce it with this script on your kernels,
>>> I can try with base wireless-testing or whatever you are using.
>>
>> I'll run this now, but can you try a vanilla wireless-testing? I hear
>> the latest wireless-testing is borked so maybe try (git reset --hard
>> master-2010-09-29), its what I'm on.
>
> You are liable to hit a bunch of those crashes I've been reporting
> before you hit the DMA thing if you don't use latest (with Johanne's scan
> locking patch).
>
> I'm going to poke at IOMMU debugging and see what I find.
>
> I'll start a compile of vanilla wireless-testing + scan fix as well.

Well, vanilla + scan patch locked pretty hard when I started the script.

I was able to get sysrq to dump the locks, but it didn't seem to complete
that and couldn't even dump more sysrq info after that.

Might be something entirely different, of course, and no idea if
this lock dump shows any real problem.

Oct  7 12:08:43 localhost kernel: SysRq : Show Locks Held
Oct  7 12:08:43 localhost kernel:
Oct  7 12:08:43 localhost kernel: Showing all locks held in the system:
Oct  7 12:08:43 localhost kernel: 3 locks held by kworker/0:0/4:
Oct  7 12:08:43 localhost kernel: #0:  (events){+.+.+.}, at: [<c0443cea>] process_one_work+0x145/0x295
Oct  7 12:08:43 localhost kernel: #1:  ((linkwatch_work).work){+.+.+.}, at: [<c0443cea>] process_one_work+0x145/0x295
Oct  7 12:08:43 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 3 locks held by kworker/u:1/38:
Oct  7 12:08:43 localhost kernel: #0:  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<c0443cea>] process_one_work+0x145/0x295
Oct  7 12:08:43 localhost kernel: #1:  ((&sta->ampdu_mlme.work)){+.+...}, at: [<c0443cea>] process_one_work+0x145/0x295
Oct  7 12:08:43 localhost kernel: #2:  (&sta->ampdu_mlme.mtx){+.+...}, at: [<f8887180>] ieee80211_ba_session_work+0x52/0xbe [mac80211]
Oct  7 12:08:43 localhost kernel: 1 lock held by mingetty/1584:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by mingetty/1586:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by mingetty/1589:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by mingetty/1593:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by mingetty/1596:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by mingetty/1598:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by bash/1683:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by bash/1728:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by bash/1752:
Oct  7 12:08:43 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f5e91>] n_tty_read+0x1d1/0x5ed
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2840:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2842:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2844:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2846:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2848:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2850:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2852:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2854:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
Oct  7 12:08:43 localhost kernel: 1 lock held by wpa_supplicant/2856:
Oct  7 12:08:43 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06da190>] rtnl_lock+0xf/0x11
OcSysRq : Show State
Process wpa_supplicant (pid: 2904, ti=f3946000 task=f4124a60 task.ti=f3946000)
Stack:
Call Trace:
Code: 73 18 8b 75 08 01 73 14 88 4c 02 1c 5b 5e 5d c3 55 89 e5 57 56 53 8b 5d 08 6b 72 04 3c ff 84 30 70 11 00 00 8b 79 10 6b 72 04 3c <8b> 7f 50 01 bc 30
SysRq : Show Locks Held
Process wpa_supplicant (pid: 2904, ti=f3946000 task=f4124a60 task.ti=f3946000)
Stack:
Call Trace:
Code: 73 18 8b 75 08 01 73 14 88 4c 02 1c 5b 5e 5d c3 55 89 e5 57 56 53 8b 5d 08 6b 72 04 3c ff 84 30 70 11 00 00 8b 79 10 6b 72 04 3c <8b> 7f 50 01 bc 30


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

