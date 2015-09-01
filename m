Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36684 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbbIAHg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 03:36:57 -0400
Received: by labnh1 with SMTP id nh1so61668436lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 00:36:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1441088612-9517-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1441088612-9517-1-git-send-email-c_traja@qti.qualcomm.com>
Date: Tue, 1 Sep 2015 09:36:55 +0200
Message-ID: <CA+BoTQ=VrhjJCCb9wWTQ59MJmFJjf5PAboJH=Sp00y83xB2byw@mail.gmail.com> (sfid-20150901_093700_536016_73B7DB52)
Subject: Re: [PATCH] ath10k: Disable PCI power save for QCA99X0
From: Michal Kazior <michal.kazior@tieto.com>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 September 2015 at 08:23,  <c_traja@qti.qualcomm.com> wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> Frequent failures in waking up the target is observed during
> interface (mostly observed with AP and Monitor mode) bring up
> on x86, this failures lead to firmware crash. Disabling PCI
> power save fixes this issue. Disabling ASPM also does not help,
> as a work around disable PCI power save for QCA99X0.
>
> The following kernel log is seen when this issue happens
>
> kworker/dying (667) used greatest stack depth: 12208 bytes left
> ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x00040050: -110
> ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a02c: -110
> ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xfffffffe at 0x0004a02c: -110
> ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a034: -110
> ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xfffff81f at 0x0004a034: -110
> ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a02c: -110
> ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xffffffe1 at 0x0004a02c: -110
> ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a42c: -110
> ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xfffffffe at 0x0004a42c: -110
> ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a434: -110
> ath10k_pci 0000:07:00.0: firmware crashed! (uuid 40b345f1-db3d-4b97-bc54-6572994e02d5)
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 1046ab6..1ab4ee7 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1640,6 +1640,10 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
>         ath10k_pci_safe_chip_reset(ar);
>
>         ath10k_pci_irq_disable(ar);
> +
> +       if (QCA_REV_99X0(ar))
> +               ath10k_pci_sleep(ar);
> +

This re-introduces an issue that was originally fixed once
320e14b8db51 ("ath10k: fix some pci wake/sleep issues").

E.g. if you have shared irqs between ath10k and another NIC and ath10k
is put down then if the other NIC generates an interrupt ath10k will
read out its interrupt CSR as 0xdeadbeef which in turn will confuse
the driver and consume the interrupt preventing the other NIC driver
from working properly.

Also think of WoWLAN.


Michał
