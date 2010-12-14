Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:19978 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab0LNKZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 05:25:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 493C9506FF
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 11:13:40 +0100 (CET)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
	by localhost (kso.tls-tautenburg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jVNTTXehxZ7U for <linux-wireless@vger.kernel.org>;
	Tue, 14 Dec 2010 11:13:35 +0100 (CET)
Received: from [194.94.209.168] (unknown [194.94.209.168])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by kso.tls-tautenburg.de (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 11:13:35 +0100 (CET)
Message-ID: <4D07434F.6070006@tls-tautenburg.de>
Date: Tue, 14 Dec 2010 11:13:35 +0100
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: unresolved symbols due to missing iwlcore.ko
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am having trouble installing iwlagn from the recent compat-wireless. My system 
is Ubuntu 8.10 running kernel 2.6.36-1. The reason is that iwlcore.ko does not 
get build and installed in the update modules folder which, of course, leads 
unresolved symbols. Here is a short log

stecklum@extragalactix:~/System/src/compat-wireless-2010-12-12$ 
./scripts/driver-select iwlwifi
make
...
   Building modules, stage 2.
   MODPOST 7 modules
   CC      /home/stecklum/System/src/compat-wireless-2010-12-12/compat/compat.mod.o
   LD [M]  /home/stecklum/System/src/compat-wireless-2010-12-12/compat/compat.ko
   CC 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atl1c/atl1c.mod.o
   LD [M] 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atl1c/atl1c.ko
   CC 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atl1e/atl1e.mod.o
   LD [M] 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atl1e/atl1e.ko
   CC 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atlx/atl1.mod.o
   LD [M] 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atlx/atl1.ko
   CC 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atlx/atl2.mod.o
   LD [M] 
/home/stecklum/System/src/compat-wireless-2010-12-12/drivers/net/atlx/atl2.ko
   CC 
/home/stecklum/System/src/compat-wireless-2010-12-12/net/mac80211/mac80211.mod.o
   LD [M] 
/home/stecklum/System/src/compat-wireless-2010-12-12/net/mac80211/mac80211.ko
   CC 
/home/stecklum/System/src/compat-wireless-2010-12-12/net/wireless/cfg80211.mod.o
   LD [M] 
/home/stecklum/System/src/compat-wireless-2010-12-12/net/wireless/cfg80211.ko
make[1]: Leaving directory `/usr/src/linux-headers-2.6.36-1-generic'

So no iwlcore.ko at this stage.

This is after make install

stecklum@extragalactix:~/System/src/compat-wireless-2010-12-12$ find . -name 
iwlcore.ko -print
stecklum@extragalactix:~/System/src/compat-wireless-2010-12-12$

and consequently the module is not in the update module folder. Thus, upon 
modprobe iwlagn the original kernel module will be loaded which, of course, 
lacks the new symbols.

Regards, Bringfried


