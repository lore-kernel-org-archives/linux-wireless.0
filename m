Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39511 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab1KIW13 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 17:27:29 -0500
Message-ID: <4EBAFE49.9000401@hauke-m.de> (sfid-20111109_232744_858991_4F7EF1CD)
Date: Wed, 09 Nov 2011 23:27:21 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Harald Freitag <harald.freitag@gmx.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Compability Issue regarding Freescale i.MX356 and Marvell 88w8688
 Wifi-Module
References: <20111109091341.83440@gmx.net> <4EBA4A4B.2020804@hauke-m.de> <20111109115910.37620@gmx.net>
In-Reply-To: <20111109115910.37620@gmx.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Harald,

Please do not remove the mailing list.

On 11/09/2011 12:59 PM, Harald Freitag wrote:
> Hello Hauke,
> 
> first of all thank you for your fast reply - I realy appreciate your help.
> 
> I know that I might make a fool out of myself or that I might ask silly/redundant/obvious questions, but I am just trying to understand the given informations from you and I try to specify my issue more detailed.
> 
> As a side note, I would also like to add, that I am currently at the beginning of a very promising project and I am doing mostly research work, before the actual "GO" for the project is given. My expertise and my knowledge about embedded linux systems, the implementation of drivers, the specific coding of features needed and the entire environment within/around the project is yet fairly limited, but I am more then willing to change that! (hopefully with success ;) )
> 
> With that being said I would like to get a little more concrete with a few more questions that came to my attention, after receiving your answer:
> 
> ------------------------------------------------------------
> 
> 1. What exactly is this compat-wireless-package!?
> 
>> we have compat-wireless [0] which backports a recent wireless subsystem
>> to older kernel versions. 
> 
> From my understanding (after following the link that you provided), it is described as a driver-package that allows me to implement the latest changes/advances/features of a driver (f.ex. within linux v. 3.x) into an older system (f.ex. linux v2.6.31) without the need to make major changes in my old system.
Yes that is correct it is intended that you do not have to make any
changes to your kernel, but this does not work for every driver.

> 2. Was/Is the linux kernel v2.6.31 a stable version to work with?
> 
> Since the latest stable version on kernel.org is v2.6.32.48 and there is no more support for v2.6.31.

Please read this Note at the stable page: NOTE: Please be aware that the
releases below contain code from the given version of the Linux kernel.
Therefore to add functionality, you should select a version that is
later than your kernel version.

> 3. With what package do I have to start working?
> 
> My goal is to find a way of a possible backportation from a SDIO driver (linux v2.6.35) provided by Marvell directly to an embedded system on the Freescale application processor i.MX356 (linux v2.6.31 with its own SDIO driver) with a preconfiguration by Freescale and an adaption for additional feature support by my customer.
> 
> Currently I dont know if the software/driver packages accessible/provided by Freescale and Marvell are even working with the libertas SDIO drivers that are already included in the basic kernel versions v2.6.31 and v2.6.35 or if they got their own individual SDIO drivers. (that is something for me to find out yet)
> I only looked into the changes to the libertas driver listed @kernelnewbies.org so that I could get a small idea of what might be different between the SDIO driver v2.6.35 from Marvell and the SDIO driver v2.6.31 from Freescale and which features/modules of the v2.6.35 driver would actually need to be "ported".
> 
> On the link that you provided it reads "compat-wireless aims to always support kernel compatibility down to the last supported 2.6 stable kernel release as noted on kernel.org.". At the moment that would mean kernel v2.6.32.48 and I would have to work with the compat-wireless-2.6.32.16.tar.bz2 package correct? Does this package include the functionality of the v2.6.35 SDIO driver which will run on kernel v2.6.32? (I know this sounds stupid, but I dont realy have a clue yet how exactly those compat packages work and what their actual capabilities are...)
Compat-wireless works down to kernel 2.6.27 for now (2.6.24 should not
be a big problem). Some drivers like liberats_sdio are not going back to
that version because they need something not backported in compat
wireless like the new SDIO PM API
> 
>> but libertas_sdio is just working for kernel >= 2.6.32,
>> because of some changes in the power management API in recent kernel
>> versions. 
> 
> What does this mean? 

In kernel 2.6.32 a new API in the sdio subsystem for SDIO power
management was introduced and the libertas_sdio driver is using it in
recent kernel versions. For some of these APIs compat-wireless provides
a backport so it also works with older kernels for this SDIO power
management API it does not.

> 
> If I take the compat-wireless-2.6.32.16.tar.bz2 package it will be compatible to older kernel versions like my v2.6.31 except the changes in the power management API?
> 
>> You could implement a backport for the power management
>> interface into compat-wireless or just backport the new power management
>> API into your kernel.
> 
> In my eyes you mean by that, that I either have to rewrite the power management API from the compat-wireless-2.6.32.16.tar.bz2 package (f.ex. excluding some new features) or that I would have to rewrite my old powermanagement API from v2.6.31 (f.ex. adding some new features) so that it supports the features of the new interfaces within the compat-wireless-2.6.32.16.tar.bz2 package correct?

Yes that is mostly correct.
In addition you have to remove the check for kernel >= 2.6.32 from
config.mk in compat-wireless to build it.

> I hope this wasnt too much gibberish that I wrote here and that you are able to at least follow my thoughts somehow, because my english isnt on the necessary standard level yet.
Your English isn't a problem at least for me, mine isn't better than
yours. ;-)
> 
> Is there maybe a german "consultant" or someone that speaks german among your team @linux-wireless or maybe even a possible translation for the documentation available on your site!?
I am speaking German, but I just have knowledge in compat-wireless in
general and not about SDIO or libertas.

> Anyway I will most definetly print all the documentary available from your link and I will try to understand it...
> 
> 
> Again I am very thankful for your help and your patience with me!
> 
> 
> Regards Harald
> 
Hauke
