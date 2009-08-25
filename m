Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.mailasail.com ([212.227.250.41]:34849 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZHYSqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 14:46:51 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.2.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id B80D2B59D5B
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 19:46:52 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.2.1])
	by localhost (mail1.nippynetworks.com [127.0.2.1]) (amavisd-new, port 10024)
	with LMTP id EkuHnTvusX4i for <linux-wireless@vger.kernel.org>;
	Tue, 25 Aug 2009 19:46:52 +0100 (BST)
Received: from ed-wildgooses-macbook-pro.local (office.nippynetworks.com [94.194.201.187])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id 6D913B59D59
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 19:46:52 +0100 (BST)
Message-ID: <4A94319B.9030903@wildgooses.com>
Date: Tue, 25 Aug 2009 19:46:51 +0100
From: Ed W <lists@wildgooses.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Cross compiling currently broken?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It would appear that there is something broken with the current Makefile 
when crosscompiling - I need a bit of help figuring out a proper solution.

In this case it's barely cross compiling, I just want to use a kernel I 
compiled somewhere, but isn't installed (I'm also in a chroot).  
According to the docs (http://linuxwireless.org/en/users/Download) I 
should do something like:

  make KLIB=/home/mcgrof/kernels/linux-2.6.27.22 \
   KLIB_BUILD=/home/mcgrof/kernels/linux-2.6.27.22

However, the makefile then installs the files in completely the wrong 
location, eg the following puts the files in 
/usr/src/linux/lib/modules/2.6.30.5-grsec-wrap/ !!

  make KLIB=/usr/src/linux \
   KLIB_BUILD=/usr/src/linux install-modules

So KLIB should apparently be something like /lib/modules/xyz.  However, 
this is still wrong because the line below puts the files in: 
/lib/modules/2.6.30.5-grsec-wrap/lib/modules/2.6.30.5-grsec-wrap/

  make KLIB=/lib/modules/2.6.30.5-grsec-wrap/ \
    KLIB_BUILD=/usr/src/linux  install-modules


Adding unsetting KMODPATH_ARG seems to do the trick (but seems unintended?):

  make KLIB=/lib/modules/2.6.30.5-grsec-wrap/ \
    KLIB_BUILD=/usr/src/linux KMODPATH_ARG= install-modules


But I still get repeated errors while building (where this is the 
currently running kernel, but the modules dir is unavailable in this 
chroot):

  FATAL: Could not load 
/lib/modules/2.6.29.6-grsec2.1.14-vs2.3.0.36.14/modules.dep: No such 
file or directory
  FATAL: Could not load 
/lib/modules/2.6.29.6-grsec2.1.14-vs2.3.0.36.14/modules.dep: No such 
file or directory


This appears to be caused by these lines at the top of the makefile:
  MADWIFI=$(shell $(MODPROBE) -l ath_pci)
  OLD_IWL=$(shell $(MODPROBE) -l iwl4965)

Clearly these need some parametrisation to include the running kernel 
name.  Something like this might pluck out the correct
uname:
KERNELRELEASE = $(cat $(KLIB_BUILD)/include/config/kernel.release 2> 
/dev/null)


I'm not quite clear what all the KLIB/KLIB_BUILD vars are supposed to be 
achieving, but at present they aren't working correctly when overridden 
to build a non installed kernel.  I'm surprised more people aren't 
hitting this?

Grateful if someone with a bit more experience could suggest a proper fix?

Thanks

Ed W

