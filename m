Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50829 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbXFNXC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 19:02:57 -0400
Message-ID: <4671C91E.4020800@garzik.org>
Date: Thu, 14 Jun 2007 19:02:54 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi MSI support (rev3)
References: <20070614114809.39106c17@localhost>	<46718E7A.6090001@garzik.org> <20070614154743.140dd6b5@localhost>
In-Reply-To: <20070614154743.140dd6b5@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Hemminger wrote:
> On Thu, 14 Jun 2007 14:52:42 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Stephen Hemminger wrote:
>>> The previous patch would crash on remove. pci_disable_msi has to be
>>> called after free_irq.  FYI - pci_disable_msi is safe if MSI hasn't been
>>> enabled.
>>>
>>> --- a/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:10:10.000000000 -0700
>>> +++ b/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-14 11:47:01.000000000 -0700
>>> @@ -8117,10 +8117,13 @@ static int iwl_pci_probe(struct pci_dev 
>>>  	/* If power management is turned on, default to AC mode */
>>>  	priv->power_mode = IWL_POWER_AC;
>>>  	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
>>> +
>>> +	pci_enable_msi(pdev);
>> The API wants fixing, if code that fails to check return value of 
>> pci_enable_msi() is being written.
>>
>> We should definitely be checking the return value there...
>>
>> 	Jeff
>>
> 
> I don't understand. pci_enable_msi() returns error if device doesn't
> do MSI, that's fine.

It also returns errors for conditions other than "doesn't do MSI", and 
therein lies the problem with not checking return values.

	Jeff


