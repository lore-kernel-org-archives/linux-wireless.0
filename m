Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:42201 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYLAPMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:12:23 -0500
Received: by gxk4 with SMTP id 4so2152223gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 07:12:22 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: iwlwifi - rfkill only works if the interface is up
Date: Mon, 1 Dec 2008 16:04:05 +0100
Cc: "Helmut Schaa" <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
References: <200812011311.17346.helmut.schaa@gmail.com> <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com>
In-Reply-To: <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812011604.05700.helmut.schaa@gmail.com> (sfid-20081201_161226_626566_7CE0C3F7)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 1. Dezember 2008 schrieb Tomas Winkler:
> On Mon, Dec 1, 2008 at 2:11 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:

...

> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> > index b935e9d..e2f160b 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> > @@ -1504,8 +1504,11 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
> >                 * the driver as well won't allow loading if RFKILL is set
> >                 * therefore no need to restart the driver from this handler
> >                 */
> > -               if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
> > +               if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
> >                        clear_bit(STATUS_RF_KILL_HW, &priv->status);
> > +                       if (priv->is_open)
> > +                               queue_work(priv->workqueue, &priv->restart);
> > +               }
> >
> >                handled |= CSR_INT_BIT_RF_KILL;
> >        }
> 
> This is strange, this exact code is part of  patch
> 
> """
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Sun Jun 22 11:18:52 2008 +0300
>  iwlwifi: clean up HW RF-kill state machine and restarts
>  This patch cleans up HW RF-kill state machine.
> """
> The two other hunks of this patch are in the current code, this one is
> not, I've probably messed up something on they way. I will track this
> down.

Thanks, should I respin the above patch?

> > Nevertheless, I'm wondering if the current behaviour (even with the patch above)
> > makes much sense. I mean, the user space cannot rely on the rfkill state
> > unless an appropriate interface is up. As the device is able to report the
> > killswitch state without firmware being loaded the following approach could
> > be feasible:
> > - iwl_pci_probe enables the device and enables the interrupts
> > - iwl_mac_start just loads the firmware
> > - iwl_mac_stop just releases the firmware but leaves the interrupts enabled
> 
> In 3495  rfkill interrupt is not available and rfkill state is
> delivered only when firmware is loaded, therefore this is not
> possible to bring device down and also expect rfill switch event.

Would it be possible to poll CSR_GP_CNTRL for that information on iwl3945?

> There were few threads about this subject.

Searching for these now ...

> In 4965 and 5000 this will work

Would you agree on that behavior?
Any objections I did not think of yet?

Thanks,
Helmut
