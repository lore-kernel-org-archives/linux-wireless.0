Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47176 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbZJGTZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 15:25:28 -0400
Received: by ewy4 with SMTP id 4so2193347ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 12:24:51 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 Oct 2009 20:16:34 +0100
Message-ID: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
Subject: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6: adding
	ethtool.h to compat-2.6.31.h)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 7, 2009 at 4:22 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Oct 7, 2009 at 10:45 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Wed, Oct 07, 2009 at 01:40:04AM -0400, Luis R. Rodriguez wrote:
>>> On Tue, Oct 6, 2009 at 11:39 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>>> > Between 2.6.30 and 2.6.31, linux/netdevice.h started
>>> > to include linux/ethtool.h (commit b1b67dd45a6b629eb41553856805aaa1614fbb83,
>>> > "net: factor out ethtool invocation of vlan/macvlan drivers"),
>>> > and commit 7508e486965b0af13984bc6d9da62a8d8f0dc5f9,
>>> > "cfg80211: add firmware and hardware version to wiphy", introduces
>>> > dependency of ETHTOOL_BUSINFO_LEN from linux/ethtool.h
>>> > to net/cfg80211.h .
>>>
>>> John's patch titled "cfg80211: fix compile error from missing
>>> ethtool.h" seems to address this upstream. I'll wait until he applies
>>> that to the tree.
>>
>> As Hin-Tak points-out, linux/netdevice.h is alreadying "doing the needful". :-)
>>
>> I'll just drop my patch and let this get sorted in compat-wireless.
>
> Heh ok applied, thanks.
>
>  Luis
>

It is probably just a transient problem with recent activities - I had
a NULL pointer deref from loading rtl8187 of compat-wireless
v2.6.32-rc3-39563-g98c2609 -

BUG: unable to handle kernel NULL pointer dereference at 000000000000003d
IP: [<ffffffff8147822c>] wext_ioctl_dispatch+0xd9/0x180
PGD 61c2b067 PUD 6246f067 PMD 0
Oops: 0000 [#1] SMP
...
Call Trace:
 [<ffffffff814783f5>] wext_handle_ioctl+0x4d/0x98
 [<ffffffff813e53a5>] dev_ioctl+0x625/0x662
 [<ffffffff813cfa45>] sock_ioctl+0x225/0x248
 [<ffffffff811237a3>] vfs_ioctl+0x31/0xaa
 [<ffffffff811e1801>] ? security_d_instantiate+0x37/0x4d
 [<ffffffff81123c88>] do_vfs_ioctl+0x46c/0x4c3
 [<ffffffff81123d44>] sys_ioctl+0x65/0x9c
 [<ffffffff81012082>] system_call_fastpath+0x16/0x1b

I'm sure whatever changes made this happen will go away soon, so I'll
just re-try in a few days... but if anybody knows what commit causes
this (and what fixes it!), I'd like to know.
