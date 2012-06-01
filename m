Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52833 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759247Ab2FAUUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 16:20:02 -0400
Message-ID: <4FC923EA.7030008@hauke-m.de> (sfid-20120601_222007_247746_9490E6C7)
Date: Fri, 01 Jun 2012 22:19:54 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: make some functions static
References: <1338496859-16436-1-git-send-email-hauke@hauke-m.de> <4FC8762D.8090807@broadcom.com>
In-Reply-To: <4FC8762D.8090807@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2012 09:58 AM, Arend van Spriel wrote:
> On 05/31/2012 10:40 PM, Hauke Mehrtens wrote:
>> The functions and structs are not used in an other file and the
>> prototypes are in no header file, just make them static so the compiler
>> is able to optimize them better.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
>> index 6c05cf4..f7fbae7 100644
>> --- a/drivers/bcma/host_pci.c
>> +++ b/drivers/bcma/host_pci.c
>> @@ -77,8 +77,8 @@ static void bcma_host_pci_write32(struct bcma_device *core, u16 offset,
>>  }
>>  
>>  #ifdef CONFIG_BCMA_BLOCKIO
>> -void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
>> -			      size_t count, u16 offset, u8 reg_width)
>> +static void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
>> +				     size_t count, u16 offset, u8 reg_width)
> 
> align this with struct keyword above.
This is about formating? The s from struct and the s from size_t are in
the same column, in this patch it is a little bit shifted because the
first tab is just 7 spaces long because of the + in front of it, if you
apply it it is in the same line.
> 
>>  {
>>  	void __iomem *addr = core->bus->mmio + offset;
>>  	if (core->bus->mapped_core != core)
>> @@ -100,8 +100,9 @@ void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
>>  	}
>>  }
>>  
>> -void bcma_host_pci_block_write(struct bcma_device *core, const void *buffer,
>> -			       size_t count, u16 offset, u8 reg_width)
>> +static void bcma_host_pci_block_write(struct bcma_device *core,
>> +				      const void *buffer, size_t count,
>> +				      u16 offset, u8 reg_width)
> 
> same here. checkpatch also spews warnings about DOS line endings.
When I run this mail thought checkpatch I also get these DOS line ending
messages. I do not have the original mail many more, but when I generate
the same file I send with git send mail it doe snot contain any DOS line
endings, checkpatch does not complain at all. Either the mail I
generated yesterday was somehow different or something added these DOS
line endings.

Hauke
