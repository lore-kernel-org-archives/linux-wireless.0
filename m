Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.mailasail.com ([212.227.250.41]:58390 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZHYMyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 08:54:16 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.2.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 4EFF5B51E08
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 13:46:49 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.2.1])
	by localhost (mail1.nippynetworks.com [127.0.2.1]) (amavisd-new, port 10024)
	with LMTP id 9IcjFyM+eC-m for <linux-wireless@vger.kernel.org>;
	Tue, 25 Aug 2009 13:46:49 +0100 (BST)
Received: from ed-wildgooses-macbook-pro.local (office.nippynetworks.com [94.194.201.187])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id EA230B51E07
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 13:46:48 +0100 (BST)
Message-ID: <4A93DD37.5060206@wildgooses.com>
Date: Tue, 25 Aug 2009 13:46:47 +0100
From: Ed W <lists@wildgooses.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Compiling against different kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I am building a kernel for an embedded 32bit x86 kernel on my x86_64 
machine.  I have a 32bit x86 build environment in a chroot, but 
obviously "uname" still looks like the host

I try to compile compat-wireless (2009-08-24) like this:

make ARCH=x86 KLIB=/usr/src/linux-2.6.30.5-grsecurity-2.1.14-aufs/ 
KLIB_BUILD=/usr/src/linux-2.6.30.5-grsecurity-2.1.14-aufs/

I get:

FATAL: Could not load 
/lib/modules/2.6.29.6-grsec2.1.14-vs2.3.0.36.14/modules.dep: No such 
file or directory
FATAL: Could not load 
/lib/modules/2.6.29.6-grsec2.1.14-vs2.3.0.36.14/modules.dep: No such 
file or directory
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
FATAL: Could not load 
/lib/modules/2.6.29.6-grsec2.1.14-vs2.3.0.36.14/modules.dep: No such 
file or directory
FATAL: Could not load 
/lib/modules/2.6.29.6-grsec2.1.14-vs2.3.0.36.14/modules.dep: No such 
file or directory
make -C /usr/src/linux-2.6.30.5-grsecurity-2.1.14-aufs/ 
M=/usr/src/compat-wireless-2009-08-24 modules
..etc..

(where it's clearly trying to find the modules dir for the running 64bit 
kernel, rather than the
I'm looking through the makefile, but I can't see how it's trying to 
adapt depmod to use the correct modules.dep?

Can someone please help with the correct incantation to cross compile?

Thanks

Ed W
