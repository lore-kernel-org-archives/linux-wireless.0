Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:36991 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0EJWYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:24:43 -0400
Received: by pzk42 with SMTP id 42so399730pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 15:24:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273526650-26282-1-git-send-email-hauke@hauke-m.de>
References: <1273526650-26282-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 10 May 2010 15:24:22 -0700
Message-ID: <AANLkTillq8q7f38C9CGtz6GSnULpzsyzZxuihn02DNEI@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat-wireless: backport pm_qos_{add,remove,update}_request
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You rock dude, thanks a lot! All 4 patches applied and pushed.

  Luis

On Mon, May 10, 2010 at 2:24 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> I have not found a way to backport these changes without using these ifdef.
>  patches/28-pm-qos-params.patch |   89 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 89 insertions(+), 0 deletions(-)
>  create mode 100644 patches/28-pm-qos-params.patch
>
> diff --git a/patches/28-pm-qos-params.patch b/patches/28-pm-qos-params.patch
> new file mode 100644
> index 0000000..4c3966a
> --- /dev/null
> +++ b/patches/28-pm-qos-params.patch
> @@ -0,0 +1,89 @@
> +--- a/drivers/net/wireless/ipw2x00/ipw2100.c
> ++++ b/drivers/net/wireless/ipw2x00/ipw2100.c
> +@@ -174,7 +174,9 @@ that only one external action is invoked
> + #define DRV_DESCRIPTION       "Intel(R) PRO/Wireless 2100 Network Driver"
> + #define DRV_COPYRIGHT "Copyright(c) 2003-2006 Intel Corporation"
> +
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> + struct pm_qos_request_list *ipw2100_pm_qos_req;
> ++#endif
> +
> + /* Debugging stuff */
> + #ifdef CONFIG_IPW2100_DEBUG
> +@@ -1741,7 +1743,11 @@ static int ipw2100_up(struct ipw2100_pri
> +       /* the ipw2100 hardware really doesn't want power management delays
> +        * longer than 175usec
> +        */
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> +       pm_qos_update_request(ipw2100_pm_qos_req, 175);
> ++#else
> ++      pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100", 175);
> ++#endif
> +
> +       /* If the interrupt is enabled, turn it off... */
> +       spin_lock_irqsave(&priv->low_lock, flags);
> +@@ -1889,7 +1895,12 @@ static void ipw2100_down(struct ipw2100_
> +       ipw2100_disable_interrupts(priv);
> +       spin_unlock_irqrestore(&priv->low_lock, flags);
> +
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> +       pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
> ++#else
> ++      pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
> ++                      PM_QOS_DEFAULT_VALUE);
> ++#endif
> +
> +       /* We have to signal any supplicant if we are disassociating */
> +       if (associated)
> +@@ -6674,7 +6685,11 @@ static int __init ipw2100_init(void)
> +       if (ret)
> +               goto out;
> +
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> +       ipw2100_pm_qos_req = pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
> ++#else
> ++      pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
> ++#endif
> +                       PM_QOS_DEFAULT_VALUE);
> + #ifdef CONFIG_IPW2100_DEBUG
> +       ipw2100_debug_level = debug;
> +@@ -6697,7 +6712,11 @@ static void __exit ipw2100_exit(void)
> +                          &driver_attr_debug_level);
> + #endif
> +       pci_unregister_driver(&ipw2100_pci_driver);
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> +       pm_qos_remove_request(ipw2100_pm_qos_req);
> ++#else
> ++      pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
> ++#endif
> + }
> +
> + module_init(ipw2100_init);
> +--- a/net/mac80211/mlme.c
> ++++ b/net/mac80211/mlme.c
> +@@ -509,7 +509,11 @@ void ieee80211_recalc_ps(struct ieee8021
> +               s32 beaconint_us;
> +
> +               if (latency < 0)
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> +                       latency = pm_qos_request(PM_QOS_NETWORK_LATENCY);
> ++#else
> ++                      latency = pm_qos_requirement(PM_QOS_NETWORK_LATENCY);
> ++#endif
> +
> +               beaconint_us = ieee80211_tu_to_usec(
> +                                       found->vif.bss_conf.beacon_int);
> +--- a/net/mac80211/scan.c
> ++++ b/net/mac80211/scan.c
> +@@ -510,7 +510,11 @@ static int ieee80211_scan_state_decision
> +               bad_latency = time_after(jiffies +
> +                               ieee80211_scan_get_channel_time(next_chan),
> +                               local->leave_oper_channel_time +
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> +                               usecs_to_jiffies(pm_qos_request(PM_QOS_NETWORK_LATENCY)));
> ++#else
> ++                              usecs_to_jiffies(pm_qos_requirement(PM_QOS_NETWORK_LATENCY)));
> ++#endif
> +
> +               listen_int_exceeded = time_after(jiffies +
> +                               ieee80211_scan_get_channel_time(next_chan),
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
