Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51164 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbeBSOEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 09:04:53 -0500
Message-ID: <1519049086.16723.21.camel@sipsolutions.net> (sfid-20180219_150456_765599_DBDB7841)
Subject: Re: [mac80211:master 6/11] net/mac80211/tx.c:3581:3: error:
 implicit declaration of function 'sk_pacing_shift_update'; did you mean
 'sk_incoming_cpu_update'?
From: Johannes Berg <johannes@sipsolutions.net>
To: kbuild test robot <fengguang.wu@intel.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org
Date: Mon, 19 Feb 2018 15:04:46 +0100
In-Reply-To: <201802192131.ck2stMs0%fengguang.wu@intel.com> (sfid-20180219_145205_818245_EBD9A6C0)
References: <201802192131.ck2stMs0%fengguang.wu@intel.com>
         (sfid-20180219_145205_818245_EBD9A6C0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 21:51 +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git master
> head:   49241828e8ed0b0a3dc73466d5bc562ae90acfd6
> commit: 96bd4b9e4a44c6c1da93fd3e48bd8eb1b332584a [6/11] mac80211: Adjust TSQ pacing shift
> config: x86_64-randconfig-x011-201807 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout 96bd4b9e4a44c6c1da93fd3e48bd8eb1b332584a
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    net/mac80211/tx.c: In function '__ieee80211_subif_start_xmit':
> > > net/mac80211/tx.c:3581:3: error: implicit declaration of function 'sk_pacing_shift_update'; did you mean 'sk_incoming_cpu_update'? [-Werror=implicit-function-declaration]
> 
>       sk_pacing_shift_update(skb->sk, 8);
>       ^~~~~~~~~~~~~~~~~~~~~~

Yeah, umm, I accidentally applied this on the wrong tree - already
fixed.

johannes
