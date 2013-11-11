Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34861 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3KKJn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 04:43:56 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DEDBCB@HASMSX103.ger.corp.intel.com>
References: <5276134B.8070808@wzyboy.org>
	<CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
	<CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com>
	<CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
	<CALkVjQaLx2spaOqUPcs_EwMkU7npMki1Reo1MeZwxB7m=c24=g@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
	<CALkVjQZDNSgUUFyi94Y8da_NDzW61rCvaMrZpUugFKW_LRNFFA@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
	<CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
	<CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
	<CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
	<527A8166.6000701@gmail.com>
	<CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
	<CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
	<CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
	<CAErSpo6ry6cUaVngozS8-P44=LPJN6cbsZ_mfWkJv9Rn85YXUQ@mail.gmail.com>
	<CALkVjQZEs1CqMEVApDDGZ6FDugPZ+-F5wzvE45+jB5Xrhv_N2A@mail.gmail.com>
	<CANUX_P33UqkCsfHrJW+gx-ZbEQduJ1EZ59fpx6T6wQWOLufSqg@mail.gmail.com>
	<CALkVjQYNPXpTjUpR9NZU6MTJhUmYeO1jXWvOOxk8-Pm=xdKZLg@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DEDB31@HASMSX103.ger.corp.intel.com>
	<CALkVjQbkZSvhbEAwEK-LQGjKX6kdvAMB1UUuFuW3GGO60r0wKQ@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DEDBCB@HASMSX103.ger.corp.intel.com>
Date: Mon, 11 Nov 2013 11:43:55 +0200
Message-ID: <CANUX_P1O_GOZB20m0-hcSgs8-pSDzXKJ=2_MVjVfsYLO9aSgBA@mail.gmail.com> (sfid-20131111_104401_317591_C95648AB)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: wzyboy <wzyboy@wzyboy.org>, Bjorn Helgaas <bhelgaas@google.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> 2013/11/10 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>> > It is really called L1 PM Substate.
>> > I don't really know the BIOS of ThinkPad... But we can try...
>>
>>
>> I have booted into BIOS and write down almost all the options, as attached.
>>
>> By the way, I always attach my laptop to an AC adaptor.
>>
>
> Cool.... they mask all the interesting options... oh well...

Can you please try this?

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c
b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ebe351d..f8fbe08 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -131,7 +131,7 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
         *    power savings, even without L1.
         */
        pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_LNKCTL, &lctl);
-       if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
+       if (0) {
                /* L1-ASPM enabled; disable(!) L0S */
                iwl_set_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
                dev_info(trans->dev, "L1 Enabled; Disabling L0S\n");
