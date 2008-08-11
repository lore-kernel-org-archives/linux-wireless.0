Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:55792 "EHLO willies.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbYHKS3D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 14:29:03 -0400
Message-ID: <48A084F7.6070206@willies.info> (sfid-20080811_202915_495587_45451C4C)
Date: Mon, 11 Aug 2008 20:29:11 +0200
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: unable to associate with WPA-AP - rt2x00-2.1.8
References: <489FF6A8.9030204@willies.info> <200808112017.58980.IvDoorn@gmail.com>
In-Reply-To: <200808112017.58980.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Monday 11 August 2008, Jan Willies wrote:
>> I'm using Fedore9 and since the last update I cannot associate my rt2500pci card anymore, it's running into a timeout. I'm not seeing any log entries on the AP.
>>
>> rt2500pci is version 2.1.8
> 
> I think this should have been fixed by patch:
> http://lkml.org/lkml/2008/7/31/35
> 
> But I don't know if John has merged that patch to FC9 yet.

I tried compat-wireless from today which doesn't have the patch, and it didn't work. Applying the fix from above results in a not-compiling compat-wireless:

  CC [M]  /home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.o
/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.c: In function 'rt2500pci_write_tx_desc':
/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.c:1223: error: 'struct skb_frame_desc' has no member named 'data_len'
make[4]: *** [/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.o] Error 1
make[3]: *** [/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00] Error 2
make[2]: *** [/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/elke/src/compat-wireless-2008-08-06] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.25.11-97.fc9.i686'


- Jan
