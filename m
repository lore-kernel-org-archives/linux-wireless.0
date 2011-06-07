Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46160 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab1FGVow (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 17:44:52 -0400
Message-ID: <4DEE9BCD.1030304@hauke-m.de> (sfid-20110607_234459_897364_393A9FEC)
Date: Tue, 07 Jun 2011 23:44:45 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Arnd Bergmann <arnd@arndb.de>,
	George Kashperko <george@znau.edu.ua>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Greg KH <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <201106061503.14852.arnd@arndb.de> <4DED48EA.7070001@hauke-m.de> <201106062353.40470.arnd@arndb.de> <4DEDF98C.6020905@broadcom.com>
In-Reply-To: <4DEDF98C.6020905@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2011 12:12 PM, Arend van Spriel wrote:
> On 06/06/2011 11:53 PM, Arnd Bergmann wrote:
>> On Monday 06 June 2011 23:38:50 Hauke Mehrtens wrote:
>>> Accessing chip common should be possible without scanning the hole bus
>>> as it is at the first position and initializing most things just needs
>>> chip common. For initializing the interrupts scanning is needed as we do
>>> not know where the mips core is located.
>>>
>>> As we can not use kalloc on early boot we could use a function which
>>> uses kalloc under normal conditions and when on early boot the
>>> architecture code which starts the bcma code should also provide a
>>> function which returns a pointer to some memory in its text segment to
>>> use. We need space for 16 cores in the architecture code.
>>>
>>> In addition bcma_bus_register(struct bcma_bus *bus) has to be divided
>>> into two parts. The first part will scan the bus and initialize chip
>>> common and mips core. The second part will initialize pci core and
>>> register the devices in the system. When using this under normal
>>> conditions they will be called directly after each other.
>> Just split out the minimal low-level function from the bcma_bus_scan
>> then, to locate a single device based on some identifier. The
>> bcma_bus_scan() function can then repeatedly allocate one device
>> and pass it to the low-level function when doing the proper scan,
>> while the arch code calls the low-level function directly with static
>> data.
> 
> If going for this we should pass struct bcma_device_id as match
> parameter as that identifies the core appropriately although you
> probably only want to match manufacturer and core identifiers.
> 
> Gr. AvS
> 

What is the problem with scanning the full bus? Scanning in general
works for embedded devices, just allocating memory with kalloc does not
work at that time, but the architecture code (something in
arch/mips/bcm47xx/) could provide some memory to store the struct
bcma_core, like it does for struct bcma_bus. We could just provide
memory for chipcommon and mips core or memory for all possible 16 cores,
the maximum number, as most embedded devices have ~9 cores providing
memory for 16 cores is not a big vast of memory and then we could use
the normal scan function.

A special scan function would just skip the wrong cores so I do not see
any advantage in that.

We could build a scan function which searches for one core and uses a
struct bcma_core stored on the stack and returns the struct bcma_core if
it found the wanted one. Then we could search for chipcommon and mips
and store then in arch code in arch/mips/bcm47xx and use them. When boot
is ready and we are searching the complete bus there is probably
something differences in the init process from normal init as we already
initialized chipcommon sometime earlier. I Would prefer to scan the bus
completely and initialize chipcommon and mips in early boot.

Hauke
