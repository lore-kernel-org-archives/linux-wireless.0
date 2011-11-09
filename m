Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36486 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab1KIJj3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 04:39:29 -0500
Message-ID: <4EBA4A4B.2020804@hauke-m.de> (sfid-20111109_103933_284839_11196E25)
Date: Wed, 09 Nov 2011 10:39:23 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Harald Freitag <harald.freitag@gmx.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Compability Issue regarding Freescale i.MX356 and Marvell 88w8688
 Wifi-Module
References: <20111109091341.83440@gmx.net>
In-Reply-To: <20111109091341.83440@gmx.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 10:13 AM, Harald Freitag wrote:
> Hello!
> 
> I am a student from Germany currently working on a solution to combine the Freescale i.MX356 application processor with the Marvell 88w8688 Wifi-Module over the SDIO interface of the processor.
> 
> My main problem is that the application processor of Freescale got an embedded linux 2.6.31 system including the necessary driver support (specially for the SDIO interface) implemented and the driver for the Marvell 88w8688 Wifi-Module is coming with a linux 2.6.35 firmware/driver support.
> 
> Now the question is, how do I get them both working together? (I am still a novice on that field of expertise!)
> 
> Option 1: Backporting the Marvell 88w8688 SDIO driver from linux 2.6.35 to 2.6.31
> Option 2: Finding an older Marvell 88w8688 SDIO compatible with linux 2.6.31
> 
> I already did some research (on http://kernelnewbies.org/) trying to figure out what general differences and changes in the libertas driver support have been made (with moderate success, since I am still lacking quite alot of the necessary coding understanding). 
> I also downloaded the latest software/firmware packages from Freescale and Marvell in order to learn something about the functionality of SDIO interface drivers (pretty much hitting a wall though...).
> After some time looking through the archives here on "http://linuxwireless.org/" and on "http://lists.infradead.org/mailman/listinfo/libertas-dev" I saw a few articles that could be partially helpful for my problem, but that didnt got me very far yet...
> 
> Since the embedded linux 2.6.31 system on the application processor got already adapted and configured for the intended feature support, it is not an option to upgrade/patch the linux system on the application processor. 
> 
> I would be most grateful for any helpful information regarding this issue or hint towards the right place to look, if there have been similar problems solved/delt with in the past.
> 
> Thank you very much and I appreciate that you took some time reading through this...
> 
> Regards Harald
Hi Harald,

we have compat-wireless [0] which backports a recent wireless subsystem
to older kernel versions. This seams to be exactly what you are
searching for, but libertas_sdio is just working for kernel >= 2.6.32,
because of some changes in the power management API in recent kernel
versions. You could implement a backport for the power management
interface into compat-wireless or just backport the new power management
API into your kernel.

Hauke

[0]: http://linuxwireless.org/en/users/Download

--
Now with mailing list in CC
