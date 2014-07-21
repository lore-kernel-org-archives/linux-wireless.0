Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64612 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaGUG4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 02:56:11 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so5901838wgh.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 23:56:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405689992-8538-3-git-send-email-sw@simonwunderlich.de>
References: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de>
	<1405689992-8538-3-git-send-email-sw@simonwunderlich.de>
Date: Mon, 21 Jul 2014 08:56:09 +0200
Message-ID: <CA+BoTQmrn0ddGe=p_d9+vCpMUMQ6dKhL+DmZ76OicacmxoYVMA@mail.gmail.com> (sfid-20140721_085615_400983_AF30DAED)
Subject: Re: [PATCH 2/2] ath10k: add spectral scan feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 July 2014 15:26, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
> configuring a mode through a debugfs control file. Samples can be gathered via
> another relay debugfs file.
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 80aa5a4..5fc7ff5 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -31,6 +31,7 @@
>  #include "../ath.h"
>  #include "../regd.h"
>  #include "../dfs_pattern_detector.h"
> +#include "spectral.h"
>
>  #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
>  #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
> @@ -230,6 +231,7 @@ struct ath10k_vif {
>
>         bool is_started;
>         bool is_up;
> +       bool spectral_enabled;
>         u32 aid;
>         u8 bssid[ETH_ALEN];
>
> @@ -469,6 +471,11 @@ struct ath10k {
>  #ifdef CONFIG_ATH10K_DEBUGFS
>         struct ath10k_debug debug;
>  #endif
> +
> +       /* relay(fs) channel for spectral scan */
> +       struct rchan *rfs_chan_spec_scan;
> +       enum ath10k_spectral_mode spectral_mode;
> +       struct ath10k_spec_scan spec_config;

It's probably a good idea to add a comment stating that spectral_mode
and spec_config are conf_mutex protected.


>  };
>
>  struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index a84691e..e39aa96 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -827,12 +827,15 @@ int ath10k_debug_create(struct ath10k *ar)
>                                     &fops_dfs_stats);
>         }
>
> +       ath10k_spectral_init_debug(ar);
> +
>         return 0;
>  }
>
>  void ath10k_debug_destroy(struct ath10k *ar)
>  {
>         cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
> +       ath10k_spectral_deinit_debug(ar);
>  }
>
>  #endif /* CONFIG_ATH10K_DEBUGFS */
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 348a639..c369ac1 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2671,8 +2671,16 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
>                 dev_kfree_skb_any(arvif->beacon);
>                 arvif->beacon = NULL;
>         }
> +
>         spin_unlock_bh(&ar->data_lock);
>
> +       if (arvif->spectral_enabled) {
> +               ret = ath10k_interface_disable_spectral(arvif);
> +               if (ret)
> +                       ath10k_warn("spectral disable for vdev %i failed\n",
> +                                   arvif->vdev_id);

We tend to put verbs first, e.g. "failed to disable spectral scan for
vdev %i: %d\n". Also, your warning is missing "ret" here.


[...]
> +#include <linux/relay.h>
> +#include "core.h"
> +#include "debug.h"
> +
> +static void ath10k_debug_send_fft_sample(struct ath10k *ar,
> +                                        struct fft_sample_tlv *fft_sample_tlv)

I guess fft_sample_tlv could be const. Other functions could also have
const arguments. But I'm just being picky now :-)


> +int ath10k_process_fft(struct ath10k *ar,
> +                      struct wmi_single_phyerr_rx_event *event,
> +                      struct phyerr_fft_report *fftr, size_t bin_len, u64 tsf)
> +{
[...]
> +       nf_list1 = __le32_to_cpu(event->hdr.nf_list_1);
> +       nf_list2 = __le32_to_cpu(event->hdr.nf_list_2);
> +       chain_idx = MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX);
> +       switch (chain_idx) {
> +       case 0:
> +               fft_sample->noise = __cpu_to_be16(nf_list1 & 0xffffu);

Are you sure you want to & nf_list1 itself *before* the byte swap? You
probably won't see a difference with an intel host system which is
little-endian just like the target device.


> +               break;
> +       case 1:
> +               fft_sample->noise = __cpu_to_be16((nf_list1 >> 16) & 0xffffu);
> +               break;
> +       case 2:
> +               fft_sample->noise = __cpu_to_be16(nf_list2 & 0xffffu);
> +               break;
> +       case 3:
> +               fft_sample->noise = __cpu_to_be16((nf_list2 >> 16) & 0xffffu);
> +               break;
> +       }

Ditto for the above.


> +static int ath10k_spectral_scan_trigger(struct ath10k *ar)
> +{
> +       struct ath10k_vif *arvif;
> +       int res;
> +       int vdev_id;
> +

You access ar->spectral_mode here which requires conf_mutex to be
held. I suggest lockdep_assert_held() to be put here.


> +       arvif = ath10k_get_spectral_vdev(ar);
> +       if (!arvif)
> +               return -ENODEV;
> +       vdev_id = arvif->vdev_id;
> +
> +       if (ar->spectral_mode == SPECTRAL_DISABLED)
> +               return 0;
> +
> +       res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
> +                                             WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
> +                                             WMI_SPECTRAL_ENABLE_CMD_ENABLE);
> +       if (res < 0)
> +               return res;
> +
> +       res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
> +                                             WMI_SPECTRAL_TRIGGER_CMD_TRIGGER,
> +                                             WMI_SPECTRAL_ENABLE_CMD_ENABLE);
> +       if (res < 0)
> +               return res;
> +
> +       return 0;
> +}
> +static int ath10k_spectral_scan_config(struct ath10k *ar,
> +                                      enum ath10k_spectral_mode mode)
> +{
> +       struct wmi_vdev_spectral_conf_arg arg;
> +       struct ath10k_vif *arvif;
> +       int vdev_id, count, res = 0;
> +

Ditto. lockdep_assert_held().


> +       arvif = ath10k_get_spectral_vdev(ar);
> +       if (!arvif)
> +               return -ENODEV;
> +
> +       vdev_id = arvif->vdev_id;
> +
> +       arvif->spectral_enabled = (mode != SPECTRAL_DISABLED);
> +       ar->spectral_mode = mode;
> +
> +       res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
> +                                             WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
> +                                             WMI_SPECTRAL_ENABLE_CMD_DISABLE);
> +       if (res < 0) {
> +               ath10k_warn("failed to enable spectral scan: %d\n", res);
> +               return res;
> +       }
> +
> +       if (mode == SPECTRAL_DISABLED)
> +               return 0;
> +
> +       if (mode == SPECTRAL_BACKGROUND)
> +               count = WMI_SPECTRAL_COUNT_DEFAULT;
> +       else
> +               count = max_t(u8, 1, ar->spec_config.count);
> +
> +       arg.vdev_id              = vdev_id;
> +       arg.scan_count           = count;
> +       arg.scan_period          = WMI_SPECTRAL_PERIOD_DEFAULT;
> +       arg.scan_priority        = WMI_SPECTRAL_PRIORITY_DEFAULT;
> +       arg.scan_fft_size        = ar->spec_config.fft_size;
> +       arg.scan_gc_ena          = WMI_SPECTRAL_GC_ENA_DEFAULT;
> +       arg.scan_restart_ena     = WMI_SPECTRAL_RESTART_ENA_DEFAULT;
> +       arg.scan_noise_floor_ref = WMI_SPECTRAL_NOISE_FLOOR_REF_DEFAULT;
> +       arg.scan_init_delay      = WMI_SPECTRAL_INIT_DELAY_DEFAULT;
> +       arg.scan_nb_tone_thr     = WMI_SPECTRAL_NB_TONE_THR_DEFAULT;
> +       arg.scan_str_bin_thr     = WMI_SPECTRAL_STR_BIN_THR_DEFAULT;
> +       arg.scan_wb_rpt_mode     = WMI_SPECTRAL_WB_RPT_MODE_DEFAULT;
> +       arg.scan_rssi_rpt_mode   = WMI_SPECTRAL_RSSI_RPT_MODE_DEFAULT;
> +       arg.scan_rssi_thr        = WMI_SPECTRAL_RSSI_THR_DEFAULT;
> +       arg.scan_pwr_format      = WMI_SPECTRAL_PWR_FORMAT_DEFAULT;
> +       arg.scan_rpt_mode        = WMI_SPECTRAL_RPT_MODE_DEFAULT;
> +       arg.scan_bin_scale       = WMI_SPECTRAL_BIN_SCALE_DEFAULT;
> +       arg.scan_dbm_adj         = WMI_SPECTRAL_DBM_ADJ_DEFAULT;
> +       arg.scan_chn_mask        = WMI_SPECTRAL_CHN_MASK_DEFAULT;
> +
> +       res = ath10k_wmi_vdev_spectral_conf(ar, &arg);
> +       if (res < 0) {
> +               ath10k_warn("failed to configure spectral scan: %d\n", res);
> +               return res;
> +       }
> +
> +       return 0;
> +}


Did you test this against a firmware crash while spectral scan is
enabled? ar->spectral_mode will be left as-is when restart is
performed but no spectral scan will be actually configured. You either
need to restart spectral scan (better from user perspective) or clear
out the old mode (easier to code, but bad from user perspective
because suddenly spectral scan would be stopped implicitly by device
crash).


Michał
