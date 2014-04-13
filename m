Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63479 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaDMHXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 03:23:35 -0400
Received: by mail-lb0-f180.google.com with SMTP id 10so4779632lbg.11
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 00:23:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>
Date: Sun, 13 Apr 2014 10:23:33 +0300
Message-ID: <CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com> (sfid-20140413_092411_203899_12E2B063)
Subject: Re: iwlwifi null pointer dereference
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Alexander Monakov <amonakov@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 12, 2014 at 6:11 PM, Alexander Monakov <amonakov@gmail.com> wrote:
> Hello,
>
> On a laptop with Wireless-N 135 card and 3.14.0 kernel I'm getting a
> kernel oops on cold boot ans wireless seems unusable, but suprisingly
> everything works fine after a reboot:
>
> [    4.155609] Intel(R) Wireless WiFi driver for Linux, in-tree:
> [    4.155611] Copyright(c) 2003- 2014 Intel Corporation
> [    4.155745] iwlwifi 0000:05:00.0: can't disable ASPM; OS doesn't
> have ASPM control
> [    4.155810] iwlwifi 0000:05:00.0: pci_enable_msi failed(0Xffffffda)
> [    4.173755] iwlwifi 0000:05:00.0: RF_KILL bit toggled to enable radio.
> [    4.173763] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [    4.175243] IP: [<ffffffffa00057a0>]
> iwl_pcie_irq_handler+0xa10/0xb50 [iwlwifi]
> [    4.176641] PGD 0
> [    4.176874] iwlwifi 0000:05:00.0: loaded firmware version
> 18.168.6.1 op_mode iwldvm
> [    4.179239] Oops: 0000 [#1] SMP
> [    4.180623] Modules linked in: iwlwifi
>

Wow - interesting - you are getting an interrupt before we even enable them.

Does this help you?

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c
b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 37f7acc..bebab4e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1803,6 +1803,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct
pci_dev *pdev,
         * PCI Tx retries from interfering with C3 CPU state */
        pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);

+       trans->dev = &pdev->dev;
+       trans_pcie->pci_dev = pdev;
+       iwl_disable_interrupts(trans);
+
        err = pci_enable_msi(pdev);
        if (err) {
                dev_err(&pdev->dev, "pci_enable_msi failed(0X%x)\n", err);
@@ -1814,8 +1818,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct
pci_dev *pdev,
                }
        }

-       trans->dev = &pdev->dev;
-       trans_pcie->pci_dev = pdev;
        trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
        trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
        snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
