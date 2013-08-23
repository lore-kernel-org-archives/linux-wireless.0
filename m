Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab3HWJsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 05:48:01 -0400
From: "Rymarkiewicz, WaldemarX" <waldemarx.rymarkiewicz@intel.com>
To: Lars Poeschel <poeschel@lemonage.de>
CC: Lars Poeschel <larsi@wh2.tu-dresden.de>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"jslaby@suse.cz" <jslaby@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>
Subject: RE: [linux-nfc] [PATCH RFC] nfc: add a driver for pn532 connected
 on uart
Date: Fri, 23 Aug 2013 09:47:57 +0000
Message-ID: <A4DEEF93D8D14A418311321B77DB71E9C9E299@IRSMSX104.ger.corp.intel.com> (sfid-20130823_114825_358235_B720103B)
References: <1377181699-1668-1-git-send-email-larsi@wh2.tu-dresden.de>
 <A4DEEF93D8D14A418311321B77DB71E9C9D773@IRSMSX104.ger.corp.intel.com>
 <201308231128.47731.poeschel@lemonage.de>
In-Reply-To: <201308231128.47731.poeschel@lemonage.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>Yes, I know that and I explicitly mentioned that. I had to get this chip working
>somehow and I had to begin somewhere. The pn533 driver is really very hard 
>to understand with it's massive use of nested callbacks, workqueues and
>usb urbs. So I took the approach to try to understand what happens while modifying
>and would then later factor out what both drivers have in common.
>The other way is understanding the code first and then decide what would be needed for
> both chips, factor that out and then write the pn532 uart specific stuff. And this uart stuff
>is a pain itself in linux. This way seemed much harder to me,
> especially as I have no pn533 device to test which things will break.

I understand. It took me some time to understand this too. Now, it's even harder after adding  protocol ops, but still is pretty well layered. 

> I suggest to separate transport layer from the core in pn533 and add 
> support for uart and usb separately. This is exactly what I've planned 
> while changing pn533 to support acr122 device.
>> Yes, I agree with you this should be done. I'll expect it to be challenging
>> but based on my previous work this could be doable. 

Be sure there will be pitfalls separating transport.  I've already experienced some of them adding support for acr122. 

>> I'll look into that in my next free timeslot. I'll not be able to do that in the next two months. 
>>Sorry.

No worries. I know this pain :) 

Thanks,
/Waldek
