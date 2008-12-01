Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:36824 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYLANIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 08:08:42 -0500
Received: by yw-out-2324.google.com with SMTP id 9so917582ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 05:08:40 -0800 (PST)
Message-ID: <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com> (sfid-20081201_140848_270123_52B1F011)
Date: Mon, 1 Dec 2008 15:08:39 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: iwlwifi - rfkill only works if the interface is up
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <200812011311.17346.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200812011311.17346.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 1, 2008 at 2:11 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Hi,
>
> Since the patch "iwlwifi: delay firmware loading from pci_probe to network
> interface open" was merged, the driver's killswitch does not work anymore
> when the interface is down. The patch comment contains two arguments for
> that behaviour:
>
> 1) ... Because kernel initializes network devices subsystem before hard disk
> and SATA subsystem, it is impossible to get the firmware image from hard disk
> in the PCI probe handler. ...
>
> 2) For better power saving ...
>
> The current driver behavior is as follows:
>
> - iwl_pci_probe initializes the driver but disables the device, at this point
>  changing the killswitch state will not be noticed by the driver and thus
>  the killswitch state in sysfs will not reflect the real state
>
> - iwl_mac_start (which is called when at least one interface goes up) starts
>  the device and loads the firmware if the killswitch is disabled. Otherwise
>  the driver will just enable the interrupts and allows the interface to go
>  up.
>
> However, if the device fires the interrupt CSR_INT_BIT_RF_KILL the code in
> iwl_irq_tasklet will _not_ restart the card, although the driver already
> allowed the interface to go up. That should easily be fixable with a patch
> similar to the following (the comment should be changed too):
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index b935e9d..e2f160b 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -1504,8 +1504,11 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
>                 * the driver as well won't allow loading if RFKILL is set
>                 * therefore no need to restart the driver from this handler
>                 */
> -               if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
> +               if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
>                        clear_bit(STATUS_RF_KILL_HW, &priv->status);
> +                       if (priv->is_open)
> +                               queue_work(priv->workqueue, &priv->restart);
> +               }
>
>                handled |= CSR_INT_BIT_RF_KILL;
>        }

This is strange, this exact code is part of  patch

"""
Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun Jun 22 11:18:52 2008 +0300
 iwlwifi: clean up HW RF-kill state machine and restarts
 This patch cleans up HW RF-kill state machine.
"""
The two other hunks of this patch are in the current code, this one is
not, I've probably messed up something on they way. I will track this
down.

> Nevertheless, I'm wondering if the current behaviour (even with the patch above)
> makes much sense. I mean, the user space cannot rely on the rfkill state
> unless an appropriate interface is up. As the device is able to report the
> killswitch state without firmware being loaded the following approach could
> be feasible:
> - iwl_pci_probe enables the device and enables the interrupts
> - iwl_mac_start just loads the firmware
> - iwl_mac_stop just releases the firmware but leaves the interrupts enabled

In 3495  rfkill interrupt is not available and rfkill state is
delivered only when firmware is loaded, therefore this is not
possible to bring device down and also expect rfill switch event.
There were few threads about this subject.
In 4965 and 5000 this will work


Thanks
Tomas
