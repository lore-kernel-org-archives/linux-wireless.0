Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54137 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab0GZRbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 13:31:08 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o6QHV5gt011126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 10:31:06 -0700
Message-ID: <4C4DC659.7090006@candelatech.com>
Date: Mon, 26 Jul 2010 10:31:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: linux-wireless compile broken
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pulled and attempted to build linux-wireless this morning:

[greearb@build-32 linux-wireless.p4s]$ make bzImage modules
make -C /home/greearb/git/wireless-2.6 O=/home/greearb/kernel/2.6/linux-wireless.p4s/. bzImage modules
   Using /home/greearb/git/wireless-2.6 as source for kernel
   GEN     /home/greearb/kernel/2.6/linux-wireless.p4s/Makefile
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    /home/greearb/git/wireless-2.6/scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   LD      drivers/staging/built-in.o
   CC [M]  drivers/staging/netwave/netwave_cs.o
/home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:250: error: expected specifier-qualifier-list before ‘dev_node_t’
/home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c: In function ‘netwave_snapshot’:
/home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:291: error: ‘netwave_private’ has no member named ‘lastExec’
/home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:302: error: implicit declaration of function ‘copy_from_pc’
/home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:302: error: ‘netwave_private’ has no member named ‘nss’
/home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c: In function ‘netwave_get_wireless_stats’:
/home/greearb/git/wireless-2.6/drivers/staging/netwave/netwave_cs.c:318: error: ‘netwave_private’ has no member named ‘ramBase’


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

