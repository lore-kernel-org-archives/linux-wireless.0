Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41593 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab0GZSAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 14:00:13 -0400
Date: Mon, 26 Jul 2010 13:49:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: linux-wireless compile broken
Message-ID: <20100726174902.GD3903@tuxdriver.com>
References: <4C4DC659.7090006@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4C4DC659.7090006@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 10:31:05AM -0700, Ben Greear wrote:
> Pulled and attempted to build linux-wireless this morning:
> 
> [greearb@build-32 linux-wireless.p4s]$ make bzImage modules
> make -C /home/greearb/git/wireless-2.6 O=/home/greearb/kernel/2.6/linux-wireless.p4s/. bzImage modules
>   Using /home/greearb/git/wireless-2.6 as source for kernel
>   GEN     /home/greearb/kernel/2.6/linux-wireless.p4s/Makefile
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    /home/greearb/git/wireless-2.6/scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   LD      drivers/staging/built-in.o
>   CC [M]  drivers/staging/netwave/netwave_cs.o
> /home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:250: error: expected specifier-qualifier-list before ‘dev_node_t’
> /home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c: In function ‘netwave_snapshot’:
> /home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:291: error: ‘netwave_private’ has no member named ‘lastExec’
> /home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:302: error: implicit declaration of function ‘copy_from_pc’
> /home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:302: error: ‘netwave_private’ has no member named ‘nss’
> /home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c: In function ‘netwave_get_wireless_stats’:
> /home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:318: error: ‘netwave_private’ has no member named ‘ramBase’

wireless-2.6 doesn't have this:

commit e5b3e80016198ee55c82dfd653c1dee99a38964b
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Wed May 5 23:17:29 2010 -0700

    Staging: netwave: delete the driver
    
    It has sat in the staging directory since October of 2009, and no one
    has stepped up to take it over, so odds are, no one cares about it
    anymore.  So, it is now deleted as scheduled, and documented in the TODO
    file.
    
    Cc: John W. Linville <linville@tuxdriver.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

You should probably just turn-off that driver in your .config.
Anyway, I normally recommend that people use wireless-testing for
actual development.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
