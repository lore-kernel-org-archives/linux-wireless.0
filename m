Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56630 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1CJK2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 05:28:44 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pxd6m-0008C9-G7
	for linux-wireless@vger.kernel.org; Thu, 10 Mar 2011 11:28:40 +0100
Received: from 212.44.20.129.ip.redstone-isp.net ([212.44.20.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 11:28:40 +0100
Received: from arend by 212.44.20.129.ip.redstone-isp.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 11:28:40 +0100
To: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend@broadcom.com>
Subject: Re: Problem with BCM943224
Date: Thu, 10 Mar 2011 10:28:28 +0000 (UTC)
Message-ID: <loom.20110310T112254-310@post.gmane.org>
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@...> writes:

> 
> It seems all reads are 1 (0xffffffff). Can this be some bug in driver?
> Can this be because I use adapter mini PCIe to PCIe x1? I remember
> such a situation when I connected adapter to PCIe x16 and used N-PHY
> card SSB based.
> 

I am using a Dell laptop (Latitude E6410) with 43224 installed and no
issues with it. We also have a test setup over here which is a desktop
model in which we use the 4313 in half-mini-pci to PCIe x1 adapter. Also
had 43224 in same adapter and both did not give issues with the si_attach,
which scans the chipset for the cores. Reading back 0xFFFFFFFF is reason
to abort this scan and end in a failure.

Gr. AvS


