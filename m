Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3253 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbXERPtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 11:49:09 -0400
Received: from lin01.mn-solutions.de (pD95F9490.dip0.t-ipconnect.de [217.95.148.144])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id D64FA5E47DF
	for <linux-wireless@vger.kernel.org>; Fri, 18 May 2007 17:49:03 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id E32821E002B
	for <linux-wireless@vger.kernel.org>; Fri, 18 May 2007 17:48:57 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: How to (passive?) scan
Date: Fri, 18 May 2007 17:48:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200705181748.54779.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have two points:


1. Documentation?

in wireless-dev/Documentation there is hardly any mentioning of 
mac80211. Lest is there any documentation at that place.



2. Scanning

I've backported mac80211 to my 2.6.21.1 kernel (with some help 
from

      http://intellinuxwireless.org/?p=mac80211&n=HOWTO-mac80211

I'm doing some range tests with a bunch of different cards, one 
of the a prism54 based. The prism54pci.ko driver (which uses 
mac80211) gives me the following output in dmesg:

   p54: LM86 firmware
   wmaster0: Selected rate control algorithm 'simple'
   phy0: hwaddr 00:10:c6:21:e4:8a, isl3890
   HW CONFIG: channel=1 freq=2412 phymode=3
   wmaster0: Does not support passive scan, disabled

And of course it doesn't detect any access point. Manually 
scannig helps, after "iwlist eth1 scanning" I get some output 
from iwlist, and the following lines in dmesg:

   HW CONFIG: channel=1 freq=2412 phymode=3
   HW CONFIG: channel=2 freq=2417 phymode=3
   HW CONFIG: channel=3 freq=2422 phymode=3
   HW CONFIG: channel=4 freq=2427 phymode=3
   HW CONFIG: channel=5 freq=2432 phymode=3
   HW CONFIG: channel=6 freq=2437 phymode=3
   HW CONFIG: channel=7 freq=2442 phymode=3
   HW CONFIG: channel=8 freq=2447 phymode=3
   HW CONFIG: channel=9 freq=2452 phymode=3
   HW CONFIG: channel=10 freq=2457 phymode=3
   HW CONFIG: channel=11 freq=2462 phymode=3
   HW CONFIG: channel=1 freq=2412 phymode=3
   HW CONFIG: channel=8 freq=2447 phymode=3
   eth1: Initial auth_alg=0
   eth1: authenticate with AP 00:13:19:80:da:30
   eth1: RX authentication from 00:13:19:80:da:30 (alg=0
      transaction=2 status=0)
   eth1: authenticated
   eth1: associate with AP 00:13:19:80:da:30
   eth1: RX AssocResp from 00:13:19:80:da:30 (capab=0x11 status=0
     aid=11)
   eth1: associated
   wmaster0: Added STA 00:13:19:80:da:30
   eth1: CTS protection enabled (BSSID=00:13:19:80:da:30)

After this I'm associated and can use the wireless link. But hey, 
adding "post-up iwlist eth1 scanning" or something like this is 
just a kludge, not a solution. After all, non mac80211 drivers 
can do that as well. And this kludge would probably not work in 
a mobile scenario, where I constantly have to scan because I 
move and my old AP might get out of range and I need to find, 
without user intervention, one of the other APs.



So, what is the suggested solution to this problem ?

a) wait until this is finished and working

b) implement some scanning in the prism54common and populate
   local->ops->passive_scan function pointer? Hmm, an
     grep -rl passive_scan \
     wireless-dev/drivers/net/wireless/mac80211
   did not reveal anything ...   so does currently
   no driver can associate/roam?

c) do it from user space. But how, where is the cfg80211
   interface documented?  Oh, whoops, we're back at
   Question 1 from above :-)
