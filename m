Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38450 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbcG0JPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 05:15:14 -0400
Received: by mail-wm0-f41.google.com with SMTP id o80so52263982wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2016 02:15:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1469608424-11370-1-git-send-email-benjamin@sipsolutions.net>
References: <1469608424-11370-1-git-send-email-benjamin@sipsolutions.net>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 27 Jul 2016 11:15:11 +0200
Message-ID: <CA+BoTQmLdfLaANVBqoSW8WQwZSSNz0WrJNvA0fji4i9XOd1D9w@mail.gmail.com> (sfid-20160727_111520_511407_12F3CDCF)
Subject: Re: [PATCH] ath10k: Allow setting coverage class
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 July 2016 at 10:33, Benjamin Berg <benjamin@sipsolutions.net> wrote:
> Unfortunately ath10k does not generally allow modifying the coverage class
> with the stock firmware and Qualcomm has so far refused to implement this
> feature so that it can be properly supported in ath10k. If we however know
> the registers that need to be modified for proper operation with a higher
> coverage class, then we can do these modifications from the driver.
>
> This patch implements this hack for first generation cards which are based
> on a core that is similar to ath9k. The registers are modified in place and
> need to be re-written every time the firmware sets them. To achieve this
> the register status is verified after any event from the firmware.

"After any event from firmware" would also need to include HTT events
which your patch doesn't consider.


> The coverage class may not be modified temporarily right after the card
> re-initializes the registers. This is for example the case during scanning.
>
> A warning will be generated if the hack is not supported on the card or
> unexpected values are hit. There is no error reporting for userspace
> applications though (this is a limitation in the mac80211 driver
> interface).

With a recent change in ath10k the ieee80211_ops can be updated in
ar->ops so you can NULL-ify .set_coverage_class before registering to
mac80211. See how wake_tx_queue() is masked. You could use this to
mask it for WAVE2 devices that haven't been verified.


[...]
> @@ -257,6 +258,12 @@ extern const struct ath10k_hw_regs qca6174_regs;
>  extern const struct ath10k_hw_regs qca99x0_regs;
>  extern const struct ath10k_hw_regs qca4019_regs;
>
> +enum ath10k_hw_mac_core_rev {
> +       ATH10K_HW_MAC_CORE_UNKNOWN = 0,
> +       ATH10K_HW_MAC_CORE_ATH9K,

WAVE1 would be more appropriate.


> +       ATH10K_HW_MAC_CORE_WAVE2,
> +};
> +
[...]
> +#define ATH9K_MAC_TIME_OUT             0x8014
> +#define ATH9K_MAC_TIME_OUT_MAX         0x00003FFF
> +#define ATH9K_MAC_TIME_OUT_ACK         0x00003FFF
> +#define ATH9K_MAC_TIME_OUT_ACK_S       0
> +#define ATH9K_MAC_TIME_OUT_CTS         0x3FFF0000
> +#define ATH9K_MAC_TIME_OUT_CTS_S       16
> +
> +#define ATH9K_MAC_IFS_SLOT             0x1070
> +#define ATH9K_MAC_IFS_SLOT_M           0x0000FFFF
> +#define ATH9K_MAC_IFS_SLOT_RESV0       0xFFFF0000

The prefix is wrong. It shouldn't be ATH9K.

Moreover FW refers to these register as PCU_ACK_CTS_TIMEOUT and
PCU_GBL_IFS_SLOT.


> +
>  #endif /* _HW_H_ */
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 55c823f..a9b587e 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5372,6 +5372,15 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
>         mutex_unlock(&ar->conf_mutex);
>  }
>
> +static void ath10k_set_coverage_class(struct ieee80211_hw *hw,
> +                                     s16 value)

Wrong function prefix/name. Should be: ath10k_mac_op_set_coverage_class


> +{
> +       struct ath10k *ar = hw->priv;
> +
> +       if (ath10k_wmi_pdev_set_coverage_class(ar, value) == -EOPNOTSUPP)
> +               ath10k_warn(ar, "Modification of coverage class is not supported!\n");

Warning doesn't match the style used in ath10k. "failed to set
coverage class: not supported\n".


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
> index 64ebd30..3ebc57e 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
> @@ -52,6 +52,8 @@ struct wmi_ops {
>         int (*pull_wow_event)(struct ath10k *ar, struct sk_buff *skb,
>                               struct wmi_wow_ev_arg *arg);
>         enum wmi_txbf_conf (*get_txbf_conf_scheme)(struct ath10k *ar);
> +       void (*set_pdev_coverage_class)(struct ath10k *ar,
> +                                       s16 value);

WMI ops are used to generate and process events and command buffers.
These ops are not supposed to have side-effects but
"set_pdev_coverage_class" implies it does.


[...]
>  /* MAIN WMI cmd track */
>  static struct wmi_cmd_map wmi_cmd_map = {
> @@ -3096,6 +3097,121 @@ ath10k_wmi_op_pull_peer_kick_ev(struct ath10k *ar, struct sk_buff *skb,
>         return 0;
>  }
>
> +static void
> +ath10k_ath9k_set_pdev_coverage_class(struct ath10k *ar, s16 value)

The prefix is wrong. "ath9k" should be used here.

ath10k_wmi_ is appropriate for stuff in wmi.c


[...]
> +       /* Do some sanity checks on the slottime register. */
> +       if (unlikely(slottime_reg % counters_freq_mhz)) {
> +               ath10k_warn(ar,
> +                           "Not adjusting coverage class timeouts, expected an integer microsecond slot time in HW register\n");

Wrong message style.


> +
> +               goto store_regs;
> +       }
> +
> +       slottime = (slottime_reg & ATH9K_MAC_IFS_SLOT_M) / counters_freq_mhz;
> +       if (unlikely(slottime != 9 && slottime != 20)) {
> +               ath10k_warn(ar,
> +                           "Not adjusting coverage class timeouts, expected a slot time of 9 or 20us in HW register. It is %uus.\n",
> +                           slottime);

Wrong message style.


[...]
> +       timeout_reg = (timeout_reg & ~ATH9K_MAC_TIME_OUT_ACK) | timeout;
> +
> +       /* Update cts timeout (upper halfword). */
> +       timeout = (timeout_reg & ATH9K_MAC_TIME_OUT_CTS)
> +       timeout = timeout >> ATH9K_MAC_TIME_OUT_CTS_S;
> +       timeout += 3 * value * counters_freq_mhz;
> +       timeout = min_t(u32, timeout, ATH9K_MAC_TIME_OUT_MAX);
> +       timeout = (timeout << ATH9K_MAC_TIME_OUT_CTS_S)
> +       timeout = timeout & ATH9K_MAC_TIME_OUT_CTS;
> +       timeout_reg = (timeout_reg & ~ATH9K_MAC_TIME_OUT_CTS) | timeout;

I would really love to see Jakub's hw register helper macros get
merged and used here..


> +
> +       ath10k_hif_write32(ar, WLAN_MAC_BASE_ADDRESS + 0x1070, slottime_reg);
> +       ath10k_hif_write32(ar, WLAN_MAC_BASE_ADDRESS + 0x8014, timeout_reg);

So you're defining register offsets and then you're using literal
values to address them?..


[...]
> +static void
> +ath10k_wmi_op_set_pdev_coverage_class(struct ath10k *ar, s16 value)
> +{
> +       switch (ar->hw_values->mac_core_rev) {
> +       case ATH10K_HW_MAC_CORE_ATH9K:
> +               ath10k_ath9k_set_pdev_coverage_class(ar, value);
> +               break;
> +       default:
> +               if (value != -1)
> +                       ath10k_warn(ar, "Setting the coverage class is not supported for this chipset.");
> +               break;
> +       }
> +}

This is wrong in general. You aren't using WMI to submit coverage
class configuration so it doesn't belong here (wmi.c and wmi-ops).
You're poking HW registers directly actually.

The logic should be placed in mac.c and hw.c and abstracted away
through hw_ops which are defined/populated per-hw in pci.c. Vasanth
recently worked on something similar for rx descriptor handling
(ar->hw_rx_desc_ops). I think it should be generalized to hw_ops and
you should add the coverage-class stuff on top of that.


Michał
