Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:51258 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbYHKVR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 17:17:59 -0400
Received: by nf-out-0910.google.com with SMTP id d3so759331nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 14:17:57 -0700 (PDT)
To: Jan Willies <jan@willies.info>
Subject: Re: unable to associate with WPA-AP - rt2x00-2.1.8
Date: Mon, 11 Aug 2008 23:46:19 +0200
Cc: linux-wireless@vger.kernel.org
References: <489FF6A8.9030204@willies.info> <200808112017.58980.IvDoorn@gmail.com> <48A084F7.6070206@willies.info>
In-Reply-To: <48A084F7.6070206@willies.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808112346.20015.IvDoorn@gmail.com> (sfid-20080811_231804_090872_1E82639F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 August 2008, Jan Willies wrote:
> Ivo van Doorn wrote:
> > On Monday 11 August 2008, Jan Willies wrote:
> >> I'm using Fedore9 and since the last update I cannot associate my rt2500pci card anymore, it's running into a timeout. I'm not seeing any log entries on the AP.
> >>
> >> rt2500pci is version 2.1.8
> > 
> > I think this should have been fixed by patch:
> > http://lkml.org/lkml/2008/7/31/35
> > 
> > But I don't know if John has merged that patch to FC9 yet.
> 
> I tried compat-wireless from today which doesn't have the patch, and it didn't work. Applying the fix from above results in a not-compiling compat-wireless:
> 
>   CC [M]  /home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.o
> /home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.c: In function 'rt2500pci_write_tx_desc':
> /home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.c:1223: error: 'struct skb_frame_desc' has no member named 'data_len'
> make[4]: *** [/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00/rt2500pci.o] Error 1
> make[3]: *** [/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless/rt2x00] Error 2
> make[2]: *** [/home/elke/src/compat-wireless-2008-08-06/drivers/net/wireless] Error 2
> make[1]: *** [_module_/home/elke/src/compat-wireless-2008-08-06] Error 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.25.11-97.fc9.i686'

That is correct, the patch is different for 2.6.26 and 2.6.27 (and wireless-compat).
I was planning to send the patch for 2.6.26 seperately, but saw that John already
converted the patch correctly.
I'll double check where the patches are heading, and one is at least moving
toways 2.6.26-stable.

Ivo
