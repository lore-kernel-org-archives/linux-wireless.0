Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:34371 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZBCN6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 08:58:20 -0500
MIME-Version: 1.0
In-Reply-To: <1233600555.2411.158.camel@rc-desk>
References: <d82e647a0902010634o1b4e4075m7d38365f605d3c31@mail.gmail.com>
	 <200902012208.40758.rjw@sisk.pl>
	 <d82e647a0902020614q4f772816s7a6c8d143fd58662@mail.gmail.com>
	 <1233600555.2411.158.camel@rc-desk>
Date: Tue, 3 Feb 2009 21:58:19 +0800
Message-ID: <d82e647a0902030558n262eaf35r233541d3e63e4df8@mail.gmail.com> (sfid-20090203_145826_374210_A4628B74)
Subject: Re: [possible BUG] PM suspend warning in 2.6.29-rc3-00227-gf1dd849
From: Ming Lei <tom.leiming@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/3 reinette chatre <reinette.chatre@intel.com>:
> Ming,
>
> On Mon, 2009-02-02 at 06:14 -0800, Ming Lei wrote:
>> After applying your patch, following is the dmesg output, so it is the
>> iwl3945 driver that does not save pci state.
>
> Could you please test with the patch below?

reinette,

The previous warning during pm suspending does disappear after
applying your patch.

Thanks!

>
> Thank you
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 95d0198..5b44d32 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -8143,6 +8143,7 @@ static int iwl3945_pci_suspend(struct pci_dev
> *pdev, pm_message_t state)
>                priv->is_open = 1;
>        }
>
> +       pci_save_state(pdev);
>        pci_set_power_state(pdev, PCI_D3hot);
>
>        return 0;
> @@ -8153,6 +8154,7 @@ static int iwl3945_pci_resume(struct pci_dev
> *pdev)
>        struct iwl3945_priv *priv = pci_get_drvdata(pdev);
>
>        pci_set_power_state(pdev, PCI_D0);
> +       pci_restore_state(pdev);
>
>        if (priv->is_open)
>                iwl3945_mac_start(priv->hw);
>
>
>
>
>



-- 
Lei Ming
