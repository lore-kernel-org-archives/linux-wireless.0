Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:15133 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaHZVKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 17:10:34 -0400
Message-ID: <53FCF7C8.6020309@broadcom.com> (sfid-20140826_231037_334011_C07C3339)
Date: Tue, 26 Aug 2014 23:10:32 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Fredrik Kempe <l.f.kempe@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Wireless doesn't work on macbook air 6.2
References: <CAOUSx5cR2TjbtJ+Eb+JvdG4c_GEj5O3ZSAubaGenOy7cXhZLNg@mail.gmail.com>
In-Reply-To: <CAOUSx5cR2TjbtJ+Eb+JvdG4c_GEj5O3ZSAubaGenOy7cXhZLNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/14 22:15, Fredrik Kempe wrote:
> Hope I'm sending this to the right mailinglist and that i provided all info.
>
> Wireless doesn't work on macbook air 6.2
>
> Im trying out new kernels to get monitor via thunderbolt and i noticed
> that the wireless stoped working for me. While installing the kernel i
> get an error.
> ERROR LOG:
> make: Entering directory `/usr/src/linux-headers-3.17.0-031700rc2-generic'
> CFG80211 API is prefered for this kernel version
> Using CFG80211 API
>    LD /var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/built-in.o
>    CC [M] /var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/src/shared/linux_osl.o
>    CC [M] /var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/src/wl/sys/wl_linux.o
> /var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/src/wl/sys/wl_linux.c: In
> function ‘wl_alloc_linux_if’:
> /var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/src/wl/sys/wl_linux.c:1354:64:
> error: macro "alloc_netdev" requires 4 arguments, but only 3 given
>    dev = alloc_netdev(sizeof(priv_link_t), intf_name, ether_setup);
>                                                                  ^
> /var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/src/wl/sys/wl_linux.c:1354:8:
> error: ‘alloc_netdev’ undeclared (first use in this function)
>    dev = alloc_netdev(sizeof(priv_link_t), intf_name, ether_setup);
>          ^
> /var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/src/wl/sys/wl_linux.c:1354:8:
> note: each undeclared identifier is reported only once for each
> function it appears in
> make[1]: *** [/var/lib/dkms/bcmwl/6.30.223.141+bdcom/build/src/wl/sys/wl_linux.o]
> Error 1
> make: *** [_module_/var/lib/dkms/bcmwl/6.30.223.141+bdcom/build] Error 2
> make: Leaving directory `/usr/src/linux-headers-3.17.0-031700rc2-generic'

The bcmwl driver is an out-of-tree driver with binary blob. So this is 
not an upstream driver, which is what linux-wireless is about. Now the 
error message seems clear to me and it means that in the new 3.17-rc2 
kernel alloc_netdev interface changed. So you could try fixing that. 
This is the commit changing the api:

   commit c835a677331495cf137a7f8a023463afd9f032f8
   Author: Tom Gundersen <teg@jklm.no>
   Date:   Mon Jul 14 16:37:24 2014 +0200

       net: set name_assign_type in alloc_netdev()

Regards,
Arend
