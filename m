Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48429 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab2AIEJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 23:09:28 -0500
Received: by yenm10 with SMTP id m10so28528yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 20:09:28 -0800 (PST)
Message-ID: <4F0A686F.9050802@gmail.com> (sfid-20120109_050932_833440_66CA1A68)
Date: Mon, 09 Jan 2012 12:09:19 +0800
From: lina <lina.lastname@gmail.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: modprob b43 not work after hilibernate
References: <4F09AAE5.2080209@gmail.com>	<4F09BEC0.7080702@lwfinger.net>	<4F09C1E2.6020907@gmail.com> <CACna6rxMPnn1DHtMvsHtCG3y=_-sCKgb=L901MV96fj31BZ58A@mail.gmail.com>
In-Reply-To: <CACna6rxMPnn1DHtMvsHtCG3y=_-sCKgb=L901MV96fj31BZ58A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09,January,2012 05:44 AM, Rafał Miłecki wrote:
> 2012/1/8 lina<lina.lastname@gmail.com>:
>> On Monday 09,January,2012 12:05 AM, Larry Finger wrote:
>>>
>>> On 01/08/2012 08:40 AM, lina wrote:
>>>>
>>>> Hi,
>>>>
>>>> after hibernation,
>>>>
>>>> I tried modprob b43 and /etc/initi.d/network-manager restart not work,
>>>>
>>>> is it reboot the only option. ( I googled it seems, not so sure)
>>>
>>>
>>> Hibernation involves so many parts of the computer that it is hard to
>>> tell what is happening. If unloading and reloading b43 using modprobe
>>> does not help, then it is not solely a problem with b43.
>>>
>>> You need to provide a better description of what you are doing. Include
>>> specific output from dmesg and the exact commands you are trying. You
>>> should also include what distro you are running, your kernel version,
>>> and what brand and model of computer you are using.
>>
>>
>> It's fine with me to reboot.
>>
>> 3.2.0-1 SMP  x86_64 GNU/Linux
>>
>> Debian wheezy.
>>
>> I upload the dmesg output in the following link,
>>
>> https://docs.google.com/open?id=0B93SVRfpVVg3ZThiYmQ3NjctOWU2Ni00ODQ5LTgzMGMtMGMyMDgxMjVjYTFl
>>
>> It's absolutely not something urgent or very-necessary to me, so just take
>> your time and interest, I was just asking. btw, if there is some problem in
>> the dmesg, maybe not high relevant to this topic, please also feel free to
>> let me know.
>> any further info you need just let me know,
>
> I'm not sure if I can see suspend&resume in your dmesg...

I uploaded the new dmesg output in the following link:

before hibernation:
https://docs.google.com/leaf?id=0B93SVRfpVVg3ODVmMjc1MTEtZDlhNi00YjVlLWJlYmYtNmVjYmExYTIwMDFh&hl=en_US


after hibernation:
https://docs.google.com/open?id=0B93SVRfpVVg3YWNkMzljYTctMGQ0Zi00MTRhLWIyODItMTQ3ZGIyNjQyZDNm


[ 2704.950566] bcma: PLL enable timeout
[ 2704.950628] ------------[ cut here ]------------
[ 2704.950649] WARNING: at 
/var/local/cache/alien/compat-wireless-2012-01-07/drivers/net/wireless/b43/main.c:2453 
b43_wireless_core_init+0x1275/0x12a0 [b43]()
[ 2704.950656] Hardware name: MacBookPro8,2
[ 2704.950659] Modules linked in: arc4 b43(O) mac80211(O) cfg80211(O) 
ssb(O) pcmcia pcmcia_core rng_core fglrx(P) uvcvideo videodev video 
v4l2_compat_ioctl32 tg3 [last unloaded: scsi_wait_scan]
[ 2704.950691] Pid: 2153, comm: NetworkManager Tainted: P           O 
3.2.0-1-lina #1
[ 2704.950696] Call Trace:
[ 2704.950709]  [<ffffffff8106378b>] ? warn_slowpath_common+0x7b/0xc0
[ 2704.950722]  [<ffffffffa043de85>] ? 
b43_wireless_core_init+0x1275/0x12a0 [b43]
[ 2704.950735]  [<ffffffff81543e65>] ? inet6_fill_link_af+0x15/0x30
[ 2704.950747]  [<ffffffffa043e570>] ? b43_op_start+0x1b0/0x1d0 [b43]
[ 2704.950767]  [<ffffffffa03d16c9>] ? ieee80211_do_open+0x299/0xa30 
[mac80211]
[ 2704.950784]  [<ffffffffa03cf7f2>] ? 
ieee80211_check_concurrent_iface+0x22/0x1a0 [mac80211]
[ 2704.950793]  [<ffffffff814b32f6>] ? __dev_open+0x86/0xe0
[ 2704.950799]  [<ffffffff814b358a>] ? __dev_change_flags+0x9a/0x180
[ 2704.950806]  [<ffffffff814b3720>] ? dev_change_flags+0x20/0x70
[ 2704.950816]  [<ffffffff814beef6>] ? do_setlink+0x276/0x9a0
[ 2704.950826]  [<ffffffff814a156d>] ? sock_rmalloc+0x2d/0x90
[ 2704.950835]  [<ffffffff8129563d>] ? nla_parse+0x2d/0xd0
[ 2704.950844]  [<ffffffff814c08c0>] ? __rtnl_unlock+0x10/0x10
[ 2704.950852]  [<ffffffff814bf6d2>] ? rtnl_setlink+0xb2/0x110
[ 2704.950863]  [<ffffffff814da9b9>] ? netlink_rcv_skb+0x99/0xc0
[ 2704.950871]  [<ffffffff814be988>] ? rtnetlink_rcv+0x18/0x20
[ 2704.950879]  [<ffffffff814da2b1>] ? netlink_unicast+0x2b1/0x300
[ 2704.950888]  [<ffffffff814da5e9>] ? netlink_sendmsg+0x2e9/0x340
[ 2704.950896]  [<ffffffff8149a350>] ? sock_sendmsg+0x110/0x130
[ 2704.950904]  [<ffffffff8149a350>] ? sock_sendmsg+0x110/0x130
[ 2704.950912]  [<ffffffff8149cccc>] ? move_addr_to_kernel+0x4c/0x90
[ 2704.950919]  [<ffffffff814a7ae6>] ? verify_iovec+0x56/0xd0
[ 2704.950927]  [<ffffffff8149b996>] ? __sys_sendmsg+0x3a6/0x3c0
[ 2704.950935]  [<ffffffff81156e1c>] ? do_path_lookup+0x2c/0xc0
[ 2704.950944]  [<ffffffff8113b47a>] ? kmem_cache_free+0x2a/0x110
[ 2704.950951]  [<ffffffff8149d7d6>] ? sys_sendto+0x136/0x190
[ 2704.950960]  [<ffffffff8149dc54>] ? sys_sendmsg+0x44/0x80
[ 2704.950971]  [<ffffffff815bed92>] ? system_call_fastpath+0x16/0x1b
[ 2704.950976] ---[ end trace 6fce5487e497336c ]---
[ 2706.114589] b43-phy0 ERROR: Microcode not responding
[ 2706.114600] b43-phy0 ERROR: You must go to 
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and 
download the correct firmware for this driver version. Please carefully 
read all instructions on this website.
[ 2706.117610] ------------[ cut here ]------------
[ 2706.117638] WARNING: at 
/var/local/cache/alien/compat-wireless-2012-01-07/drivers/net/wireless/b43/main.c:2453 
b43_wireless_core_init+0x1275/0x12a0 [b43]()
[ 2706.117646] Hardware name: MacBookPro8,2
[ 2706.117649] Modules linked in: arc4 b43(O) mac80211(O) cfg80211(O) 
ssb(O) pcmcia pcmcia_core rng_core fglrx(P) uvcvideo videodev video 
v4l2_compat_ioctl32 tg3 [last unloaded: scsi_wait_scan]
[ 2706.117680] Pid: 5214, comm: wpa_supplicant Tainted: P        W  O 
3.2.0-1-lina #1
[ 2706.117686] Call Trace:
[ 2706.117700]  [<ffffffff8106378b>] ? warn_slowpath_common+0x7b/0xc0
[ 2706.117713]  [<ffffffffa043de85>] ? 
b43_wireless_core_init+0x1275/0x12a0 [b43]
[ 2706.117724]  [<ffffffff81055fcf>] ? update_shares+0xbf/0xf0
[ 2706.117736]  [<ffffffffa043e570>] ? b43_op_start+0x1b0/0x1d0 [b43]
[ 2706.117758]  [<ffffffffa03d16c9>] ? ieee80211_do_open+0x299/0xa30 
[mac80211]
[ 2706.117782]  [<ffffffffa03cf7f2>] ? 
ieee80211_check_concurrent_iface+0x22/0x1a0 [mac80211]
[ 2706.117793]  [<ffffffff814b32f6>] ? __dev_open+0x86/0xe0
[ 2706.117803]  [<ffffffff814b358a>] ? __dev_change_flags+0x9a/0x180
[ 2706.117812]  [<ffffffff814b3720>] ? dev_change_flags+0x20/0x70
[ 2706.117825]  [<ffffffff81514fcf>] ? devinet_ioctl+0x61f/0x7b0
[ 2706.117838]  [<ffffffff81499d89>] ? sock_do_ioctl+0x29/0x60
[ 2706.117847]  [<ffffffff8149ad34>] ? sock_ioctl+0x74/0x2e0
[ 2706.117856]  [<ffffffff8115a216>] ? do_vfs_ioctl+0x96/0x550
[ 2706.117865]  [<ffffffff8115ef2a>] ? dput+0xda/0x1c0
[ 2706.117872]  [<ffffffff8115a768>] ? sys_ioctl+0x98/0xa0
[ 2706.117883]  [<ffffffff815bed92>] ? system_call_fastpath+0x16/0x1b
[ 2706.117889] ---[ end trace 6fce5487e497336d ]---
[ 2707.281486] b43-phy0 ERROR: Microcode not responding
[ 2707.281497] b43-phy0 ERROR: You must go to 
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and 
download the correct firmware for this driver version. Please carefully 
read all instructions on this website.
[ 2707.415448] bcma: PLL enable timeout
[ 2707.415503] ------------[ cut here ]------------
[ 2707.415524] WARNING: at 
/var/local/cache/alien/compat-wireless-2012-01-07/drivers/net/wireless/b43/main.c:2453 
b43_wireless_core_init+0x1275/0x12a0 [b43]()
[ 2707.415531] Hardware name: MacBookPro8,2
[ 2707.415534] Modules linked in: arc4 b43(O) mac80211(O) cfg80211(O) 
ssb(O) pcmcia pcmcia_core rng_core fglrx(P) uvcvideo videodev video 
v4l2_compat_ioctl32 tg3 [last unloaded: scsi_wait_scan]
[ 2707.415565] Pid: 5214, comm: wpa_supplicant Tainted: P        W  O 
3.2.0-1-lina #1
[ 2707.415570] Call Trace:
[ 2707.415584]  [<ffffffff8106378b>] ? warn_slowpath_common+0x7b/0xc0
[ 2707.415597]  [<ffffffffa043de85>] ? 
b43_wireless_core_init+0x1275/0x12a0 [b43]
[ 2707.415608]  [<ffffffff815b6386>] ? mutex_lock+0x16/0x40
[ 2707.415620]  [<ffffffffa043e570>] ? b43_op_start+0x1b0/0x1d0 [b43]
[ 2707.415640]  [<ffffffffa03d16c9>] ? ieee80211_do_open+0x299/0xa30 
[mac80211]
[ 2707.415657]  [<ffffffffa03cf7f2>] ? 
ieee80211_check_concurrent_iface+0x22/0x1a0 [mac80211]
[ 2707.415666]  [<ffffffff814b32f6>] ? __dev_open+0x86/0xe0
[ 2707.415673]  [<ffffffff814b358a>] ? __dev_change_flags+0x9a/0x180
[ 2707.415679]  [<ffffffff814b3720>] ? dev_change_flags+0x20/0x70
[ 2707.415688]  [<ffffffff81514fcf>] ? devinet_ioctl+0x61f/0x7b0
[ 2707.415697]  [<ffffffff81499d89>] ? sock_do_ioctl+0x29/0x60
[ 2707.415705]  [<ffffffff8149ad34>] ? sock_ioctl+0x74/0x2e0
[ 2707.415714]  [<ffffffff8115a216>] ? do_vfs_ioctl+0x96/0x550
[ 2707.415721]  [<ffffffff8149d041>] ? sys_bind+0xe1/0x100
[ 2707.415728]  [<ffffffff8115a768>] ? sys_ioctl+0x98/0xa0
[ 2707.415739]  [<ffffffff815bed92>] ? system_call_fastpath+0x16/0x1b
[ 2707.415744] ---[ end trace 6fce5487e497336e ]---
[ 2708.580286] b43-phy0 ERROR: Microcode not responding
[ 2708.580297] b43-phy0 ERROR: You must go to 
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and 
download the correct firmware for this driver version. Please carefully 
read all instructions on this website.
[ 2731.104322] applesmc: FS! : read arg fail




>
> What does happen after resume? What after reloading b43? Have you
> tried reloading both: b43 and bcma:
> rmmod b43
> rmmod bcma
> modprobe b43
> ?

I did both now.

> Does your kernel have
> [PATCH] bcma: support for suspend and resume
> applied?

I don't know how to check, googled for a while, found some thread, but 
did not find the patch, is it in the kernel.org [patch] part, I thought 
the [full source] is already patched?
>

