Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42082 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab2FGNBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:01:01 -0400
Message-ID: <4FD0A606.4090204@hauke-m.de> (sfid-20120607_150105_404167_44AF6985)
Date: Thu, 07 Jun 2012 15:00:54 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/18] brcmsmac: handle non PCI devices in the phy code
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-19-git-send-email-hauke@hauke-m.de> <4FCF4250.7080904@broadcom.com>
In-Reply-To: <4FCF4250.7080904@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:43 PM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
>> @@ -209,9 +211,11 @@ void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
>>  		bcma_write16(pi->d11core, D11REGOFFS(phy4wdatalo), val);
>>  	}
>>  
>> -	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
>> -		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
>> -		pi->phy_wreg = 0;
>> +	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) {
>> +		if (++pi->phy_wreg >= pi->phy_wreg_limit) {
>> +			(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
>> +			pi->phy_wreg = 0;
>> +		}
>>  	}
> 
> You can loose the outer curly braces or combine into one if statement.
> Same for the other code fragment in this patch.
Combining them sounds good.
> 
> Gr. AvS
> 

