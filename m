Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:58502 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaEABTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 21:19:48 -0400
Received: by mail-la0-f43.google.com with SMTP id c6so1840062lan.30
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 18:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535363D5.4070708@gmail.com>
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>
	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>
	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>
	<CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com>
	<5350B340.9020201@gmail.com>
	<53512D04.5070808@gmail.com>
	<CABtfrpB440bsy7xDu1pdTu2zM+ZJHLDQKb4MLaMRf4hnVXBsNQ@mail.gmail.com>
	<53513BC4.7020502@gmail.com>
	<CABtfrpDcZq=Ss=Zv9u0P3vz1D8rmgJ_jXGut-kZ0tkOmDZq9aw@mail.gmail.com>
	<535363D5.4070708@gmail.com>
Date: Wed, 30 Apr 2014 18:19:47 -0700
Message-ID: <CANUX_P3=vC26x-EotmprmsnnpXwO+uDWUoVMohwsf2iO+zW8nQ@mail.gmail.com> (sfid-20140501_031952_184589_0C47FF35)
Subject: Re: iwlwifi null pointer dereference
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Alexander Monakov <amonakov@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

On Sat, Apr 19, 2014 at 11:06 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Hi,
>
>

>>
>> It bisects to
>>
>> commit 2dbc368d7fded35ed221a3751405b15e06eb8925
>> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> Date:   Mon Dec 9 11:09:47 2013 +0200
>>
>>     iwlwifi: pcie: track interrupt mask in SW
>>
>
> Yeah - ok.
> Thank you for this information.
> I'll check again later.

Can you try this? I guess it won't work, but I want to be sure about it.

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c
b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 37f7acc..b3134f6 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1803,6 +1803,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct
pci_dev *pdev,
         * PCI Tx retries from interfering with C3 CPU state */
        pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);

+       trans->dev = &pdev->dev;
+       trans_pcie->pci_dev = pdev;
+
        err = pci_enable_msi(pdev);
        if (err) {
                dev_err(&pdev->dev, "pci_enable_msi failed(0X%x)\n", err);
@@ -1814,8 +1817,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct
pci_dev *pdev,
                }
        }

-       trans->dev = &pdev->dev;
-       trans_pcie->pci_dev = pdev;
        trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
        trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
        snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),

Thanks!
