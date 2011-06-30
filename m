Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48935 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1F3Okk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 10:40:40 -0400
Received: by ewy4 with SMTP id 4so793420ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 07:40:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110629190209.GB14425@tuxdriver.com>
References: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
	<20110629190209.GB14425@tuxdriver.com>
Date: Thu, 30 Jun 2011 09:40:38 -0500
Message-ID: <BANLkTi=8o18UqeSxvT6=AUv=aCndmTKkSQ@mail.gmail.com> (sfid-20110630_164044_640750_AEB71F4B)
Subject: Re: [PATCH 18/19] iwlwifi: remove unnecessary read of PCI_CAP_ID_EXP
From: Jon Mason <jdmason@kudzu.us>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 2:02 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Jun 27, 2011 at 12:49:29PM -0500, Jon Mason wrote:
>> The PCIE capability offset is saved during PCI bus walking.  It will
>> remove an unnecessary search in the PCI configuration space if this
>> value is referenced instead of reacquiring it.
>>
>> Signed-off-by: Jon Mason <jdmason@kudzu.us>
>> ---
>>  drivers/net/wireless/iwlwifi/iwl-pci.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
>> index 7328fbf..60d9140 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
>> @@ -93,7 +93,7 @@ static u16 iwl_pciexp_link_ctrl(struct iwl_bus *bus)
>>       u16 pci_lnk_ctl;
>>       struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
>>
>> -     pos = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
>> +     pos = pci_pcie_cap(priv->pci_dev);
>>       pci_read_config_word(pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
>>       return pci_lnk_ctl;
>>  }
>> --
>> 1.7.5.4
>
>  CC [M]  drivers/net/wireless/iwlwifi/iwl-pci.o
> drivers/net/wireless/iwlwifi/iwl-pci.c: In function ‘iwl_pciexp_link_ctrl’:
> drivers/net/wireless/iwlwifi/iwl-pci.c:96:21: error: ‘priv’ undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-pci.c:96:21: note: each undeclared identifier is reported only once for each function it appears in
> make[2]: *** [drivers/net/wireless/iwlwifi/iwl-pci.o] Error 1
> make[1]: *** [drivers/net/wireless/iwlwifi] Error 2
> make: *** [drivers/net/wireless/] Error 2
>
> Please do make sure to compile patches before sending them to the list.

My apologies.  The underlying code changed between when I did the
original version and when it was time to submit.  Still, its no excuse
for not at least compiling it.

The fix is an easy one.

-       pos = pci_pcie_cap(priv->pci_dev);
+       pos = pci_pcie_cap(pci_dev);

I'll resubmit the whole thing with the proper fix.

Thanks,
Jon

>
> JOhn
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
