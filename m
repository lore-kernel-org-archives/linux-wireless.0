Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3268 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab1FGKMr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 06:12:47 -0400
Message-ID: <4DEDF98C.6020905@broadcom.com> (sfid-20110607_121251_305367_B3D53DC8)
Date: Tue, 7 Jun 2011 12:12:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arnd Bergmann" <arnd@arndb.de>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"George Kashperko" <george@znau.edu.ua>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Greg KH" <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
 <201106061503.14852.arnd@arndb.de> <4DED48EA.7070001@hauke-m.de>
 <201106062353.40470.arnd@arndb.de>
In-Reply-To: <201106062353.40470.arnd@arndb.de>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 11:53 PM, Arnd Bergmann wrote:
> On Monday 06 June 2011 23:38:50 Hauke Mehrtens wrote:
>> Accessing chip common should be possible without scanning the hole bus
>> as it is at the first position and initializing most things just needs
>> chip common. For initializing the interrupts scanning is needed as we do
>> not know where the mips core is located.
>>
>> As we can not use kalloc on early boot we could use a function which
>> uses kalloc under normal conditions and when on early boot the
>> architecture code which starts the bcma code should also provide a
>> function which returns a pointer to some memory in its text segment to
>> use. We need space for 16 cores in the architecture code.
>>
>> In addition bcma_bus_register(struct bcma_bus *bus) has to be divided
>> into two parts. The first part will scan the bus and initialize chip
>> common and mips core. The second part will initialize pci core and
>> register the devices in the system. When using this under normal
>> conditions they will be called directly after each other.
> Just split out the minimal low-level function from the bcma_bus_scan
> then, to locate a single device based on some identifier. The
> bcma_bus_scan() function can then repeatedly allocate one device
> and pass it to the low-level function when doing the proper scan,
> while the arch code calls the low-level function directly with static
> data.

If going for this we should pass struct bcma_device_id as match 
parameter as that identifies the core appropriately although you 
probably only want to match manufacturer and core identifiers.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


