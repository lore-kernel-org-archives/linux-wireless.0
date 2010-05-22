Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:45770 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0EVNPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 May 2010 09:15:33 -0400
Received: from [10.23.202.43] (unknown [10.23.202.43])
	by smtp.heaven-czfree.net (Postfix) with ESMTP id 3CBCF14768F
	for <linux-wireless@vger.kernel.org>; Sat, 22 May 2010 15:15:31 +0200 (CEST)
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Sat, 22 May 2010 15:05:31 +0200
MIME-Version: 1.0
Subject: Problems with compilation "compat-wireless-2.6.34-rc4"
Message-ID: <4BF7D69B.26828.A345D@jafojtik.seznam.cz>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dears,

It is interesting that compilation fails with misleading error
 "cp: cannot create regular file `/lib/udev/rules.d/': Is a directory"

  When I create a directory /lib/udev/rules.d/ manually, compilation 
runs normally. It would be a good idea to check existency of
/lib/udev/rules.d/ e.g. insige "configure" script.


make -C /usr/src/linux-2.6.32.11 M=/I/USR_SRC/compat-wireless-2.6.34-rc4 modules
make[1]: Entering directory `/I/USR_SRC/linux-2.6.32.11'
  Building modules, stage 2.
  MODPOST 67 modules

make[1]: Leaving directory `/I/USR_SRC/linux-2.6.32.11'
make -C /usr/src/linux-2.6.32.11 M=/I/USR_SRC/compat-wireless-2.6.34-rc4 modules
depmod will prefer updates/ over kernel/ -- OK!
cp: cannot create regular file `/lib/udev/rules.d/': Is a directory
make: *** [install-scripts] Error 1
make: *** Waiting for unfinished jobs....

Your old wireless subsystem modules were left intact:

/lib/modules/2.6.21.5/kernel/drivers/net/b44.ko

Your old bluetooth subsystem modules were left intact:


make[1]: Entering directory `/I/USR_SRC/linux-2.6.32.11'
  Building modules, stage 2.
  MODPOST 67 modules

make[1]: Leaving directory `/I/USR_SRC/linux-2.6.32.11'

regards
   Jara
