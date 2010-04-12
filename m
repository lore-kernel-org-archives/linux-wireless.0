Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:35521 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0DLV7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 17:59:37 -0400
Received: by pzk42 with SMTP id 42so4261636pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 14:59:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC37D2B.8020502@gmail.com>
References: <4BC2EF3B.2060902@gmail.com> <n2k43e72e891004121221rac6e1a98k824bcf370974a00c@mail.gmail.com>
	<4BC37D2B.8020502@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 12 Apr 2010 14:59:16 -0700
Message-ID: <q2w43e72e891004121459n3bc456p5d15332be4eda7e8@mail.gmail.com>
Subject: Re: ath9k compilation error
To: =?UTF-8?Q?Torquil_Macdonald_S=C3=B8rensen?= <torquil@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 12, 2010 at 1:06 PM, Torquil Macdonald Sørensen
<torquil@gmail.com> wrote:
> On 12/04/10 21:21, Luis R. Rodriguez wrote:
>>
>> On Mon, Apr 12, 2010 at 3:00 AM, Torquil Macdonald Sørensen
>>>
>>> I'm getting an error when compiling the ath9k driver in
>>> compat-wireless-2010-04-11. The version 2010-04-04 compiles fine after
>>> fixing a simple
>>>
>>> First I do:
>>>
>>> ./scripts/driver-select ath9k
>>>
>>> The I run "make", and after some time I get the following:
>>>
>>>  CC [M]  /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o
>>> /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c: In
>>> function
>>> ‘ieee80211_alloc_hw’:
>>> /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c:394: error:
>>> implicit declaration of function ‘__hw_addr_init’
>>> make[5]: ***
>>> [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o]
>>> Error 1
>>> make[4]: *** [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211]
>>> Error
>>> 2
>>> make[3]: *** [_module_/home/tmac/src/compat-wireless-2010-04-11] Error 2
>>> make[2]: *** [sub-make] Error 2
>>>
>>>
>>> I want to try the newest driver because I have a lot of dropout problems
>>> when using my "Atheros Communications Inc. AR9285 Wireless Network
>>> Adapter
>>> (PCI-Express) (rev 01)"
>>>
>>> gcc (Debian 4.4.3-7) 4.4.3
>>
>> What kernel version are you on?
>>
>
> Hi Luis!
>
> tmac@asus ~$ uname -a
> Linux asus 2.6.32-3-amd64 #1 SMP Wed Feb 24 18:07:42 UTC 2010 x86_64
> GNU/Linux
>
> It is from the Debian package linux-image-2.6.32-3-amd64, with Debian
> version number 2.6.32-9. At the same time I have the corresponding kernel
> header packages installed:
>
> linux-headers-2.6.32-3-common (Debian version 2.6.32-9)
> linux-headers-2.6.32-3-amd64 (Debian version 2.6.32-9)

OK so I checked this and the problems is these two patches on linux-next:


commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
Author: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Date:   Sun Apr 4 17:59:30 2010 +0000

    mac80211: Ensure initializing private mc_list in prepare_multicast().

    Fix kernel panic by NULL pointer dereference in the context of
    ieee80211_ops->prepare_multicast().

    This bug was introduced by commit 22bedad3c.. ("net: convert
    multicast list to list_head").

    Call __hw_addr_init() in ieee80211_alloc_hw() to initialize
    list_head of private device multicast list, like we do in
    bond_init().

    Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    Reviewed-by: Jiri Pirko <jpirko@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Author: Jiri Pirko <jpirko@redhat.com>
Date:   Thu Apr 1 21:22:57 2010 +0000

    net: convert multicast list to list_head

    Converts the list and the core manipulating with it to be the same
as uc_list.

    +uses two functions for adding/removing mc address (normal and "global"
     variant) instead of a function parameter.
    +removes dev_mcast.c completely.
    +exposes netdev_hw_addr_list_* macros along with __hw_addr_* functions for
     manipulation with lists on a sandbox (used in bonding and 80211 drivers)

    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

I don't have time to address this at the moment but reverting it
should do it for you for now. I welcome someone else's patch if they
get to it first.

  Luis
