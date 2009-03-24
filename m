Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:55677 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZCXRvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 13:51:22 -0400
Received: by fg-out-1718.google.com with SMTP id 16so591976fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 10:51:19 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: TJ <ubuntu@tjworld.net>
Subject: Re: iwl3945: Don't queue rfkill_poll work when module is exiting
Date: Tue, 24 Mar 2009 18:51:11 +0100
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
References: <1237909459.5365.16.camel@hephaestion>
In-Reply-To: <1237909459.5365.16.camel@hephaestion>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903241851.11949.helmut.schaa@gmail.com> (sfid-20090324_185126_285363_7F36121F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 24. M=E4rz 2009 schrieb TJ:
> Tim Gardner suggested I forward this as a possible stable-release
> update. I found the problem in our current Ubuntu Jaunty tree - iwlwi=
fi
> version 1.2.26k. What follows is a copy of the patch for Jaunty
> (2.6.28).

The patch that introduced the rfkill polling did not hit mainline yet. =
It
should pop up in 2.6.30, hence this patch is not needed for any stable
series.

I wasn't able to reproduce the issue by unloading iwl3945 here. Any hin=
ts
on how to reproduce this issue?

Thanks,
Helmut

> ----------
> Bug: #345710
>=20
> When the wireless interface is active and the iwl3945 module is unloa=
ded the
> call to ieee80211_unregister_hw() would call iwl3945_mac_stop() which=
 would
> restart the delayed workqueue for rfkill_poll. That workqueue had alr=
eady been
> cancelled so when the next work item was run (2 seconds later) the sy=
stem would
> suffer a hard lock-up because the module had been unloaded by then.
>=20
> This patch implements STATUS_EXIT_PENDING checks in places where the =
rfkill_poll
> work is scheduled, and moves the final workqueue cancellation to occu=
r after the
> call to ieee80211_unregister_hw().
>=20
> Bug discovered, experienced and fix tested on my PC.
>=20
> Signed-off-by: TJ <ubuntu@tjworld.net>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/ne=
t/wireless/iwlwifi/iwl3945-base.c
> index bb92db2..acaf038 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -6062,7 +6062,9 @@ static void iwl3945_rfkill_poll(struct work_str=
uct *data)
>  	if (test_bit(STATUS_RF_KILL_HW, &status) !=3D test_bit(STATUS_RF_KI=
LL_HW, &priv->status))
>  	   queue_work(priv->workqueue, &priv->rf_kill);
> =20
> -	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
> +	/* only queue if module isn't exiting */
> +	if (! test_bit(STATUS_EXIT_PENDING, &priv->status))
> +		queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
>  						   round_jiffies_relative(2 * HZ));
> =20
>  }
> @@ -6588,7 +6590,10 @@ static void iwl3945_mac_stop(struct ieee80211_=
hw *hw)
>  	flush_workqueue(priv->workqueue);
> =20
>  	/* start polling the killswitch state again */
> -	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
> +
> +	/* only queue if module isn't exiting */
> +	if (! test_bit(STATUS_EXIT_PENDING, &priv->status))
> +		queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
>  						   round_jiffies_relative(2 * HZ));
> =20
>  	IWL_DEBUG_MAC80211("leave\n");
> @@ -8166,7 +8171,6 @@ static void __devexit iwl3945_pci_remove(struct=
 pci_dev *pdev)
>  	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
> =20
>  	iwl3945_rfkill_unregister(priv);
> -	cancel_delayed_work(&priv->rfkill_poll);
>  	iwl3945_dealloc_ucode_pci(priv);
> =20
>  	if (priv->rxq.bd)
> @@ -8182,6 +8186,12 @@ static void __devexit iwl3945_pci_remove(struc=
t pci_dev *pdev)
>  	/*netif_stop_queue(dev); */
>  	flush_workqueue(priv->workqueue);
> =20
> +	/* ieee80211_unregister_hw calls iwl3945_mac_stop which used to res=
tart the rfkill
> +	   polling. Although that now checks STATUS_EXIT_PENDING do cancel =
and wait for any
> +	   pending work to complete */
> +	cancel_delayed_work(&priv->rfkill_poll);
> +	cancel_work_sync(&priv->rfkill_poll);
> +
>  	/* ieee80211_unregister_hw calls iwl3945_mac_stop, which flushes
>  	 * priv->workqueue... so we can't take down the workqueue
>  	 * until now... */


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
