Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:23628 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbXFMHyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 03:54:00 -0400
Received: from lin01.mn-solutions.de (pD95F8E67.dip0.t-ipconnect.de [217.95.142.103])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 762255E594D
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2007 09:53:59 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 7BA491E002B
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2007 09:53:54 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: libertas warnings in upstream
Date: Wed, 13 Jun 2007 09:53:57 +0200
References: <Pine.SOC.4.64.0706131022450.12888@math>
In-Reply-To: <Pine.SOC.4.64.0706131022450.12888@math>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706130953.57827.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

> Tried to test-compile libertas on a 64-bit platform.

I don't have a 64 bit machine and can't therefore say anything
about those 64 issues. However, sparse doesn't moan about
anything, not sure if sparse checks 64bit issues on a 32bit
machine.


But for this warning:

>   CC [M]  drivers/net/wireless/libertas/scan.o
> drivers/net/wireless/libertas/scan.c: In function
> 'wlan_scan_process_results':
> drivers/net/wireless/libertas/scan.c:235: warning: unused
> variable 'i' 

I can assure you that it's already fixed in the libertas-2.6
tree, as of 30 May 2007. Here's a reference:

http://git.infradead.org/?p=libertas-2.6.git;a=commitdiff;h=403eb874fd36c3b8af952e3ff4e6ea2af16c8cf5


In the shortlog in this tree I also see various mentions of 64
fixes, maybe your other issues are handled as well.


Fancy trying this tree with your current kernel?

   git clone --reference /usr/src/linux-git git://git.infradead.org/libertas-2.6
   make -C /usr/src/linux-git modules SUBDIRS=libertas-2.6/drivers/net/wireless/libertas
