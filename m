Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52776 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab0HJSx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 14:53:26 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o7AIrPWW030923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 11:53:25 -0700
Message-ID: <4C61A025.4090909@candelatech.com>
Date: Tue, 10 Aug 2010 11:53:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: build failure in intel_scu_ipc.c
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just tried to build the latest wireless-testing tree on 32-bit Fedora 13,
and found this error:

make -C /home/greearb/git/wireless-testing O=/home/greearb/kernel/2.6/wireless-testing.p4s/. bzImage modules
   Using /home/greearb/git/wireless-testing as source for kernel
   GEN     /home/greearb/kernel/2.6/wireless-testing.p4s/Makefile
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    /home/greearb/git/wireless-testing/scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CC      drivers/platform/x86/intel_scu_ipc.o
In file included from /home/greearb/git/wireless-testing/drivers/platform/x86/intel_scu_ipc.c:27:
/home/greearb/git/wireless-testing/arch/x86/include/asm/mrst.h:14: warning: ‘struct sfi_table_header’ declared inside parameter list
/home/greearb/git/wireless-testing/arch/x86/include/asm/mrst.h:14: warning: its scope is only this definition or declaration, which is probably not what you want
/home/greearb/git/wireless-testing/drivers/platform/x86/intel_scu_ipc.c: In function ‘pwr_reg_rdwr’:
/home/greearb/git/wireless-testing/drivers/platform/x86/intel_scu_ipc.c:175: error: ‘MRST_CPU_CHIP_PENWELL’ undeclared (first use in this function)
/home/greearb/git/wireless-testing/drivers/platform/x86/intel_scu_ipc.c:175: error: (Each undeclared identifier is reported only once
/home/greearb/git/wireless-testing/drivers/platform/x86/intel_scu_ipc.c:175: error: for each function it appears in.)
/home/greearb/git/wireless-testing/drivers/platform/x86/intel_scu_ipc.c: In function ‘intel_scu_ipc_init’:
/home/greearb/git/wireless-testing/drivers/platform/x86/intel_scu_ipc.c:741: error: implicit declaration of function ‘mrst_identify_cpu’
make[5]: *** [drivers/platform/x86/intel_scu_ipc.o] Error 1
make[4]: *** [drivers/platform/x86] Error 2
make[3]: *** [drivers/platform] Error 2
make[2]: *** [drivers] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

