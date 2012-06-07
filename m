Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42204 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095Ab2FGN3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:29:44 -0400
Message-ID: <4FD0ACBF.7070906@hauke-m.de> (sfid-20120607_152947_697710_C8D945E4)
Date: Thu, 07 Jun 2012 15:29:35 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/18] brcmsmac: fix DMA on SoCs
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-16-git-send-email-hauke@hauke-m.de> <4FCF3A88.8080105@broadcom.com>
In-Reply-To: <4FCF3A88.8080105@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:10 PM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
>> @@ -633,11 +634,14 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
>>  	 */
>>  	di->ddoffsetlow = 0;
>>  	di->dataoffsetlow = 0;
>> -	/* add offset for pcie with DMA64 bus */
>> -	di->ddoffsetlow = 0;
>> -	di->ddoffsethigh = SI_PCIE_DMA_H32;
> 
>> -	di->dataoffsetlow = di->ddoffsetlow;
>> -	di->dataoffsethigh = di->ddoffsethigh;
> 
> The two statements above can move after the if statement below.
I will change that.
> 
>> +	/* for pci bus, add offset */
>> +	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) {
>> +		/* add offset for pcie with DMA64 bus */
>> +		di->ddoffsetlow = 0;
>> +		di->ddoffsethigh = SI_PCIE_DMA_H32;
>> +	}
>> +	di->dataoffsetlow = di->ddoffsetlow;
>> +	di->dataoffsethigh = di->ddoffsethigh;
>> +
>>  	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
>>  	if ((core->id.id == BCMA_CORE_SDIO_DEV)
>>  	    && ((rev > 0) && (rev <= 2)))
> 
> 

