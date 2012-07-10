Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49294 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GJFCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 01:02:23 -0400
Received: by wgbdr13 with SMTP id dr13so12106030wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 22:02:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFB62DA.9000706@hauke-m.de>
References: <1341751888-12679-1-git-send-email-zajec5@gmail.com>
	<4FFB62DA.9000706@hauke-m.de>
Date: Tue, 10 Jul 2012 07:02:22 +0200
Message-ID: <CACna6rwYi7HvHmijzW-_o4RFhY5exAcCgOptrRu-oFSG=14Qpg@mail.gmail.com> (sfid-20120710_070227_173367_05345A35)
Subject: Re: [RFC][PATCH] bcma: add trivial GBIT MAC COMMON driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/10 Hauke Mehrtens <hauke@hauke-m.de>:
> On 07/08/2012 02:51 PM, Rafał Miłecki wrote:
>> GMAC COMMON core is present on BCM4706 and is used for example to access
>> board PHYs (PHYs can not be accessed directly using GBIT MAC core).
>
> I think this is the cleanest way of doing this. I thought about handling
> this in the Ethernet driver, but as we need locking, an extra driver
> would be needed, just for this stupid locking.

Yeah... I really wonder why Broadcom didn't just connect GMAC core
with the proper PHY.

At the beginning I implemented chipphyrd in driver_gmac_cmn.c and
cared for the mutex internally. It would be much cleaner and easier
for GMAC driver to just use such a complete function and don't care
for mutex.

Then I started writing chipphywr and... I noticed that after writing
to BCMA_GMAC_CMN_PHY_ACCESS in GMAC CMN, this chipphywr have to touch
intstatus register in GMAC core. Just before accessing
BCMA_GMAC_CMN_PHY_CTL.

So I decided to keep PHY ops in GMAC core driver. We need to take care
of this mutex, but we don't need to handle callbacks (touching
intstatus) or passing GMAC core reference to the GMAC CMN (to let it
touch intstatus).


> You should not register an external device for this core in
> bcma_register_cores().

Ouch, thanks!

-- 
Rafał
