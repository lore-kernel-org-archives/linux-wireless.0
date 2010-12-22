Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58305 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0LVQrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 11:47:19 -0500
Message-ID: <4D122B8F.5090302@hauke-m.de>
Date: Wed, 22 Dec 2010 17:47:11 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Elvis Dowson <elvis.dowson@mac.com>, "Kahn, Gery" <geryk@ti.com>,
	Oz Krakowski <ozk@ti.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com> <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com> <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com> <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com> <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com> <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com> <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com> <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com> <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com> <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
In-Reply-To: <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/2010 05:13 PM, Luis R. Rodriguez wrote:
> On Wed, Dec 22, 2010 at 11:09 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
>> netdev_alloc_skb_ip_align
> 
> I notice you have an android kernel, is that kernel a vanilla kernel
> or did it get netdev_alloc_skb_ip_align() cherry picked into it?
> 
>   Luis

netdev_alloc_skb_ip_align is not defined in the 2.6.32.27 vanilla
kernel. Someone else (google or ti) must have backported it to this
kernel and added it to your kernel.

I do not want to add some special handling into compat-wireless just for
some android kernel. Just remove netdev_alloc_skb_ip_align() and
NETDEV_POST_INIT from include/linux/compat-2.6.33.h and the compile
problems you posted should be fixed.

Hauke
