Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:26419 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKFSly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 13:41:54 -0500
Received: by yw-out-2324.google.com with SMTP id 9so306971ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 10:41:53 -0800 (PST)
Message-ID: <43e72e890811061041x4e203243v3fcd9cceeb707eb7@mail.gmail.com> (sfid-20081106_194158_656489_D3644EAA)
Date: Thu, 6 Nov 2008 10:41:53 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Gert Steenssens" <gsteenss@gmail.com>
Subject: Re: error when building Intel compat wireless
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <49135499.60707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <49135499.60707@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2008 at 12:33 PM, Gert Steenssens <gsteenss@gmail.com> wrote:
> Hi,
>
> I am trying to build Intel compat wireless drivers for 2.6.22 on Ubuntu
> 7.10 but get the errors shown below.
>
> At some point during making ( i guess during or after:
> ./scripts/gen-compat-autoconf.sh config.mk ) it reports: 'Fatal: not a
> git repository'
>
> any idea how to fix this?
>
> Thanks,
> Gert
>
>
>
>
> make -C /lib/modules/2.6.22-15-generic/build
> M=/home/gsteenss/compat-wireless-2.6-old modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.22-15-generic'
> LD /home/gsteenss/compat-wireless-2.6-old/drivers/misc/built-in.o
> CC [M] /home/gsteenss/compat-wireless-2.6-old/drivers/misc/eeprom_93cx6.o
> LD /home/gsteenss/compat-wireless-2.6-old/drivers/net/built-in.o
> CC [M] /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.o
> In file included from
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:34:
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.h:361: error:
> field 'napi' has incomplete type
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
> 'b44_poll':
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:849: warning:
> type defaults to 'int' in declaration of '__mptr'
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:849: warning:
> initialization from incompatible pointer type
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:879: error: too
> many arguments to function 'netif_rx_complete'
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
> 'b44_interrupt':
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:911: error: too
> many arguments to function 'netif_rx_schedule_prep'
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:917: error: too
> many arguments to function '__netif_rx_schedule'

Seems b44 needs to be ported or disabled for 2.6.22.

  Luis

> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
> 'b44_open':
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:1433: warning:
> implicit declaration of function 'napi_enable'
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:1442: warning:
> implicit declaration of function 'napi_disable'
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: At top level:
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:2051: error:
> unknown field 'get_sset_count' specified in initializer
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:2051: warning:
> initialization from incompatible pointer type
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
> 'b44_init_one':
> /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:2159: warning:
> implicit declaration of function 'netif_napi_add'
> make[3]: *** [/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.o]
> Error 1
> make[2]: *** [/home/gsteenss/compat-wireless-2.6-old/drivers/net] Error 2
> make[1]: *** [_module_/home/gsteenss/compat-wireless-2.6-old] Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-15-generic'
> make: *** [modules] Error 2
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
