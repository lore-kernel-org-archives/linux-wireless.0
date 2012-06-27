Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.smith-nephew.com ([216.222.219.102]:59922 "EHLO
	mx1.smith-nephew.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab2F0WOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 18:14:03 -0400
Received: from USMANSMEXPWV41.sncorp.smith-nephew.com ([172.18.32.11])
	by USMANSMFMP01.sncorp.smith-nephew.com  with ESMTP id q5RLpfv3015844-q5RLpfv5015844
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=CAFAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 17:51:41 -0400
From: "Morrison, Tom" <Tom.Morrison@smith-nephew.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Compat-Wireless with CROSS_COMPILE OPTION
Date: Wed, 27 Jun 2012 21:51:39 +0000
Message-ID: <7D8DC74DEB12384E8E4F5EE4879A8497FD4F@USMANSMEXPW01> (sfid-20120628_001408_595127_00B4D87D)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have an embedded Cross Compiling environment on Fedora 9 - cross compiling an embedded
kernel for a TI DM355 Evaluation Board (running a TI Specific 2.6.32 kernel (for working with DSP)). 

I have successfully built the kernel and associated modules, and run all current demos. 
I decided I wanted to try a Wireless USB Dongle. There are NO drivers for this specific
USB Dongle (ath9k_htc). 

So, today, I got a stable version of compat-wireless-2.6 and tried to build the compatible driver,
It seems to build OK, but it is NOT installing correctly????

	Note:  compat-wireless tarball  un-tarred into compat-wireless-2012-05-10
      
Here are the steps I take to build / install 

1) Do a few exports - just to make sure there we get these in there

	EXPORT ARCH=arm
	EXPORT CROSS_COMPILE=/opt/armCodeSourcery/bin/arm-xxxx-

2) Perform Driver Select

	./scripts/driver-select ath9k_htc

3) Perform make

	(note: my 2.6.32 kernel directory is located <../git>)

	make ARCH=arm CROSS_COMPILE=/opt/armCodeSourcery/bin/arm-xxx- KLIB=../git  KLIB_BUILD ../git 


4) Perform install 

	make INSTALL_MOD_PATH=/home/morrisont/workdir/filesys2 ARCH=arm CROSS_COMPILE=/opt/armCodeSourcery/bin/arm-xxx- KLIB=../git  KLIB_BUILD ../git

	(note: I am assuming it will install in /home/morrisont/workdir/filesys2 ==> the NFS Root Directory)


The error is the following:

	FATAL: Could not open /lib/modules/2.6.25-14.fc9.i686/modules.dep.temp for writing: Permission denied
	make: *** [uninstall] Error 1

The directory it is attempting to modify(uninstall is on my host system root directory -NOTHING to doo with INSTALL_MOD_PATH

Inspecting the Makefile is quite confusing - can someone succinctly tell me what I am doing wrong?

Thanks in advance!

Tom Morrison
Tom.Morrison@smith-nephew.com

