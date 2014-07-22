Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19617 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaGVS1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 14:27:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <ath10k@lists.infradead.org>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	<kgiori@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<sven@narfation.org>
Subject: Re: [PATCHv2 2/2] ath10k: add spectral scan feature
References: <1405945943-8303-1-git-send-email-sw@simonwunderlich.de>
	<1405945943-8303-3-git-send-email-sw@simonwunderlich.de>
Date: Tue, 22 Jul 2014 21:27:34 +0300
In-Reply-To: <1405945943-8303-3-git-send-email-sw@simonwunderlich.de> (Simon
	Wunderlich's message of "Mon, 21 Jul 2014 14:32:23 +0200")
Message-ID: <87zjg1tfjd.fsf@kamboji.qca.qualcomm.com> (sfid-20140722_202746_504484_51DEEFD2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
> configuring a mode through a debugfs control file. Samples can be gathered via
> another relay debugfs file.
>
> Essentially, to try it out:
>
> ip link set dev wlan0 up
> echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> iw dev wlan0 scan
> echo disable > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 > samples
>
> This feature is still experimental. Based on the original RFC patch of
> Sven Eckelmann.
>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

Quick comments about the style.

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -699,6 +699,10 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
>  	ar->hif.priv = hif_priv;
>  	ar->hif.ops = hif_ops;
>  
> +	ar->spectral_mode = SPECTRAL_DISABLED;
> +	ar->spec_config.count = WMI_SPECTRAL_COUNT_DEFAULT;
> +	ar->spec_config.fft_size = WMI_SPECTRAL_FFT_SIZE_DEFAULT;

I would rather have ath10k_spectral_init() or similar to avoid
sprinkling this stuff all over the driver.

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -230,6 +231,7 @@ struct ath10k_vif {
>  
>  	bool is_started;
>  	bool is_up;
> +	bool spectral_enabled;
>  	u32 aid;
>  	u8 bssid[ETH_ALEN];
>  
> @@ -469,6 +471,12 @@ struct ath10k {
>  #ifdef CONFIG_ATH10K_DEBUGFS
>  	struct ath10k_debug debug;
>  #endif
> +
> +	/* relay(fs) channel for spectral scan */
> +	struct rchan *rfs_chan_spec_scan;
> +	/* spectral_mode and spec_config are protected by conf_mutex */
> +	enum ath10k_spectral_mode spectral_mode;
> +	struct ath10k_spec_scan spec_config;
>  };

For all spectral stuff I would prefer to have a "substructure", just
like mac has. That way it's easier to know who owns what fields.

I know this structure is a mess now, I have been sloppy on review...

> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 348a639..14d6234 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2201,6 +2201,7 @@ void ath10k_halt(struct ath10k *ar)
>  	ath10k_peer_cleanup_all(ar);
>  	ath10k_core_stop(ar);
>  	ath10k_hif_power_down(ar);
> +	ath10k_disable_spectral(ar);

Maybe ath10k_spectral_stop()?

>  
>  	spin_lock_bh(&ar->data_lock);
>  	if (ar->scan.in_progress) {
> @@ -2671,8 +2672,16 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
>  		dev_kfree_skb_any(arvif->beacon);
>  		arvif->beacon = NULL;
>  	}
> +
>  	spin_unlock_bh(&ar->data_lock);
>  
> +	if (arvif->spectral_enabled) {
> +		ret = ath10k_disable_spectral(ar);
> +		if (ret)
> +			ath10k_warn("Failed to disable spectral for vdev %i: %d\n",
> +				    arvif->vdev_id, ret);
> +	}

And here as well? And move the check for arvif->spectral_enabled inside
spectral.c?

> diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
> new file mode 100644
> index 0000000..4179efb
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/spectral.c
> @@ -0,0 +1,563 @@
> +/*
> + * Copyright (c) 2013 Qualcomm Atheros, Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#include <linux/relay.h>
> +#include "core.h"
> +#include "debug.h"
> +
> +static void
> +ath10k_debug_send_fft_sample(struct ath10k *ar,
> +			     const struct fft_sample_tlv *fft_sample_tlv)
> +{
> +	int length;
> +
> +	if (!ar->rfs_chan_spec_scan)
> +		return;
> +
> +	length = __be16_to_cpu(fft_sample_tlv->length) +
> +		 sizeof(*fft_sample_tlv);
> +	relay_write(ar->rfs_chan_spec_scan, fft_sample_tlv, length);
> +}
> +
> +static uint8_t get_max_exp(s8 max_index, u16 max_magnitude, size_t bin_len,
> +			   u8 *data)
> +{
> +	int dc_pos;
> +	u8 max_exp;
> +
> +	dc_pos = bin_len / 2;
> +	/* peak index outside of bins */
> +	if (dc_pos < max_index || -dc_pos >= max_index)
> +		return 0;

Empty line before the comment, please.

> +int ath10k_process_fft(struct ath10k *ar,
> +		       struct wmi_single_phyerr_rx_event *event,
> +		       struct phyerr_fft_report *fftr, size_t bin_len, u64 tsf)
> +{
> +	struct fft_sample_ath10k *fft_sample;
> +	u8 buf[sizeof(*fft_sample) + SPECTRAL_ATH10K_MAX_NUM_BINS];
> +	int dc_pos;
> +	u32 reg0, reg1;
> +	u16 peak_mag;
> +	u8 *bins;
> +	u16 freq1;
> +	u16 freq2;
> +	u16 total_gain_db;
> +	u16 base_pwr_db;
> +	u8 chain_idx;
> +	u32 nf_list1;
> +	u32 nf_list2;
> +	u16 length;

You could combine the variable declarations, for example:

u16 freq1, freq2, total_gain_db, and_so_on;

> +	fft_sample = (struct fft_sample_ath10k *)&buf;
> +
> +	if (bin_len < 64 || bin_len > SPECTRAL_ATH10K_MAX_NUM_BINS)
> +		return -EINVAL;
> +
> +	reg0 = __le32_to_cpu(fftr->reg0);
> +	reg1 = __le32_to_cpu(fftr->reg1);
> +
> +	length = sizeof(*fft_sample) - sizeof(struct fft_sample_tlv) + bin_len;
> +	fft_sample->tlv.type = ATH_FFT_SAMPLE_ATH10K;
> +	fft_sample->tlv.length = __cpu_to_be16(length);
> +
> +	/* TODO: there might be a reason why the hardware reports 20/40/80 MHz,
> +	 * but the results/plots suggest that its actually 22/44/88 MHz.
> +	 */
> +	switch (event->hdr.chan_width_mhz) {
> +	case 20:
> +		fft_sample->chan_width_mhz = 22;
> +		break;
> +	case 40:
> +		fft_sample->chan_width_mhz = 44;
> +		break;
> +	case 80:
> +		/* TODO: As experiments with an analogue sender and various
> +		 * configuaritions (fft-sizes of 64/128/256 and 20/40/80 Mhz)
> +		 * show, the particular configuration of 80 MHz/64 bins does
> +		 * not match with the other smaples at all. Until the reason
> +		 * for that is found, don't report these samples.
> +		 */
> +		if (bin_len == 64)
> +			return -EINVAL;
> +		fft_sample->chan_width_mhz = 88;
> +		break;
> +	default:
> +		fft_sample->chan_width_mhz = event->hdr.chan_width_mhz;
> +	}

Empty line here.

> +	fft_sample->relpwr_db = MS(reg1, SEARCH_FFT_REPORT_REG1_RELPWR_DB);
> +	fft_sample->avgpwr_db = MS(reg1, SEARCH_FFT_REPORT_REG1_AVGPWR_DB);
> +
> +	peak_mag = MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG);
> +	fft_sample->max_magnitude = __cpu_to_be16(peak_mag);
> +	fft_sample->max_index = MS(reg0, SEARCH_FFT_REPORT_REG0_PEAK_SIDX);
> +	fft_sample->rssi = event->hdr.rssi_combined;
> +
> +	total_gain_db = MS(reg0, SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB);
> +	base_pwr_db = MS(reg0, SEARCH_FFT_REPORT_REG0_BASE_PWR_DB);
> +	fft_sample->total_gain_db = __cpu_to_be16(total_gain_db);
> +	fft_sample->base_pwr_db = __cpu_to_be16(base_pwr_db);
> +
> +	freq1 = __le16_to_cpu(event->hdr.freq1);
> +	freq2 = __le16_to_cpu(event->hdr.freq2);
> +	fft_sample->freq1 = __cpu_to_be16(freq1);
> +	fft_sample->freq2 = __cpu_to_be16(freq2);
> +
> +	nf_list1 = __le32_to_cpu(event->hdr.nf_list_1);
> +	nf_list2 = __le32_to_cpu(event->hdr.nf_list_2);
> +	chain_idx = MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX);

Empty line here.

> +	switch (chain_idx) {
> +	case 0:
> +		fft_sample->noise = __cpu_to_be16(nf_list1 & 0xffffu);
> +		break;
> +	case 1:
> +		fft_sample->noise = __cpu_to_be16((nf_list1 >> 16) & 0xffffu);
> +		break;
> +	case 2:
> +		fft_sample->noise = __cpu_to_be16(nf_list2 & 0xffffu);
> +		break;
> +	case 3:
> +		fft_sample->noise = __cpu_to_be16((nf_list2 >> 16) & 0xffffu);
> +		break;
> +	}
> +
> +	bins = (u8 *)fftr;
> +	bins += sizeof(*fftr);
> +
> +	fft_sample->tsf = __cpu_to_be64(tsf);

Empty line here.

> +	arg.vdev_id              = vdev_id;
> +	arg.scan_count           = count;
> +	arg.scan_period          = WMI_SPECTRAL_PERIOD_DEFAULT;
> +	arg.scan_priority        = WMI_SPECTRAL_PRIORITY_DEFAULT;
> +	arg.scan_fft_size        = ar->spec_config.fft_size;
> +	arg.scan_gc_ena          = WMI_SPECTRAL_GC_ENA_DEFAULT;
> +	arg.scan_restart_ena     = WMI_SPECTRAL_RESTART_ENA_DEFAULT;
> +	arg.scan_noise_floor_ref = WMI_SPECTRAL_NOISE_FLOOR_REF_DEFAULT;
> +	arg.scan_init_delay      = WMI_SPECTRAL_INIT_DELAY_DEFAULT;
> +	arg.scan_nb_tone_thr     = WMI_SPECTRAL_NB_TONE_THR_DEFAULT;
> +	arg.scan_str_bin_thr     = WMI_SPECTRAL_STR_BIN_THR_DEFAULT;
> +	arg.scan_wb_rpt_mode     = WMI_SPECTRAL_WB_RPT_MODE_DEFAULT;
> +	arg.scan_rssi_rpt_mode   = WMI_SPECTRAL_RSSI_RPT_MODE_DEFAULT;
> +	arg.scan_rssi_thr        = WMI_SPECTRAL_RSSI_THR_DEFAULT;
> +	arg.scan_pwr_format      = WMI_SPECTRAL_PWR_FORMAT_DEFAULT;
> +	arg.scan_rpt_mode        = WMI_SPECTRAL_RPT_MODE_DEFAULT;
> +	arg.scan_bin_scale       = WMI_SPECTRAL_BIN_SCALE_DEFAULT;
> +	arg.scan_dbm_adj         = WMI_SPECTRAL_DBM_ADJ_DEFAULT;
> +	arg.scan_chn_mask        = WMI_SPECTRAL_CHN_MASK_DEFAULT;

Please don't indent the '=':

        arg.scan_dbm_adj = WMI_SPECTRAL_DBM_ADJ_DEFAULT
        arg.scan_chn_mask = WMI_SPECTRAL_CHN_MASK_DEFAULT;

> +/******************/
> +/* spectral_count */
> +/******************/

I don't think there's any point of adding these comments for each
debugfs file. I don't see how spectral.c even needs these kind of
comments, it's only 500 lines long.

> +void ath10k_spectral_deinit_debug(struct ath10k *ar)
> +{
> +	if (config_enabled(CONFIG_ATH10K_DEBUGFS) && ar->rfs_chan_spec_scan) {
> +		relay_close(ar->rfs_chan_spec_scan);
> +		ar->rfs_chan_spec_scan = NULL;
> +	}
> +}
> +
> +void ath10k_spectral_init_debug(struct ath10k *ar)
> +{
> +#ifdef CONFIG_ATH10K_DEBUGFS
> +	ar->rfs_chan_spec_scan = relay_open("spectral_scan",
> +					    ar->debug.debugfs_phy,
> +					    1024, 256, &rfs_spec_scan_cb,
> +					    NULL);
> +	debugfs_create_file("spectral_scan_ctl",
> +			    S_IRUSR | S_IWUSR,
> +			    ar->debug.debugfs_phy, ar,
> +			    &fops_spec_scan_ctl);
> +	debugfs_create_file("spectral_count",
> +			    S_IRUSR | S_IWUSR,
> +			    ar->debug.debugfs_phy, ar,
> +			    &fops_spectral_count);
> +	debugfs_create_file("spectral_bins",
> +			    S_IRUSR | S_IWUSR,
> +			    ar->debug.debugfs_phy, ar,
> +			    &fops_spectral_bins);
> +#endif
> +}

Do we even bother compiling spectral.c when ATH10K_DEBUGFS is disabled?
Should we instead just do this:

ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o


> diff --git a/drivers/net/wireless/ath/ath10k/spectral.h b/drivers/net/wireless/ath/ath10k/spectral.h
> new file mode 100644
> index 0000000..ee10ad2
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/spectral.h

[...]

> +void ath10k_spectral_init_debug(struct ath10k *ar);
> +void ath10k_spectral_deinit_debug(struct ath10k *ar);
> +int ath10k_disable_spectral(struct ath10k *ar);
> +
> +#ifdef CONFIG_ATH10K_DEBUGFS
> +int ath10k_process_fft(struct ath10k *ar,
> +		       struct wmi_single_phyerr_rx_event *event,
> +		       struct phyerr_fft_report *fftr, size_t bin_len, u64 tsf);
> +#else
> +static inline int
> +ath10k_process_fft(struct ath10k *ar,
> +		   struct wmi_single_phyerr_rx_event *event,
> +		   struct phyerr_fft_report *fftr, size_t bin_len, u64 tsf)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_ATH10K_DEBUGFS */

Why ath10k_spectral_init_debug() are not within the ifdef?

> +int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
> +				  const struct wmi_vdev_spectral_conf_arg *arg)
> +{
> +	struct wmi_vdev_spectral_conf_cmd *cmd;
> +	struct sk_buff *skb;
> +	u32 cmdid;
> +
> +	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cmd = (struct wmi_vdev_spectral_conf_cmd *)skb->data;
> +	cmd->vdev_id              = __cpu_to_le32(arg->vdev_id);
> +	cmd->scan_count           = __cpu_to_le32(arg->scan_count);
> +	cmd->scan_period          = __cpu_to_le32(arg->scan_period);
> +	cmd->scan_priority        = __cpu_to_le32(arg->scan_priority);

Please do not indent the '='.

> +int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
> +				    u32 enable)
> +{
> +	struct wmi_vdev_spectral_enable_cmd *cmd;
> +	struct sk_buff *skb;
> +	u32 cmdid;
> +
> +	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cmd = (struct wmi_vdev_spectral_enable_cmd *)skb->data;
> +	cmd->vdev_id     = __cpu_to_le32(vdev_id);
> +	cmd->trigger_cmd = __cpu_to_le32(trigger);
> +	cmd->enable_cmd  = __cpu_to_le32(enable);

Here as well.

> +/* TODO: please add more comments if you have in-depth information */
> +struct wmi_vdev_spectral_conf_cmd {
> +	__le32 vdev_id;
> +	/* number of fft samples to send (0 for infinite) */
> +	__le32 scan_count;
> +	__le32 scan_period;
> +	__le32 scan_priority;
> +	/* number of bins in the FFT: 2^(fft_size - bin_scale) */
> +	__le32 scan_fft_size;
> +	__le32 scan_gc_ena;
> +	__le32 scan_restart_ena;
> +	__le32 scan_noise_floor_ref;
> +	__le32 scan_init_delay;
> +	__le32 scan_nb_tone_thr;
> +	__le32 scan_str_bin_thr;
> +	__le32 scan_wb_rpt_mode;
> +	__le32 scan_rssi_rpt_mode;
> +	__le32 scan_rssi_thr;
> +	__le32 scan_pwr_format;
> +	/* rpt_mode: Format of FFT report to software for spectral scan
> +	 * triggered FFTs:
> +	 *	0: No FFT report (only spectral scan summary report)
> +	 *	1: 2-dword summary of metrics for each completed FFT + spectral
> +	 *	   scan	summary report
> +	 *	2: 2-dword summary of metrics for each completed FFT +
> +	 *	   1x- oversampled bins(in-band) per FFT + spectral scan summary
> +	 *	   report
> +	 *	3: 2-dword summary of metrics for each completed FFT +
> +	 *	   2x- oversampled bins	(all) per FFT + spectral scan summary
> +	 */
> +	__le32 scan_rpt_mode;
> +	__le32 scan_bin_scale;
> +	__le32 scan_dbm_adj;
> +	__le32 scan_chn_mask;
> +} __packed;

Empty lines before the comments.

> --- a/drivers/net/wireless/ath/spectral_common.h
> +++ b/drivers/net/wireless/ath/spectral_common.h
> @@ -19,6 +19,10 @@
>  
>  #define SPECTRAL_HT20_NUM_BINS		56
>  #define SPECTRAL_HT20_40_NUM_BINS		128
> +/* TODO: could possibly be 512, but no samples this large
> + * could be acquired so far.
> + */
> +#define SPECTRAL_ATH10K_MAX_NUM_BINS		256

Empty line before the comment.

> +struct fft_sample_ath10k {
> +	struct fft_sample_tlv tlv;
> +	u8 chan_width_mhz;
> +	__be16 freq1;
> +	__be16 freq2;
> +	__be16 noise;
> +	__be16 max_magnitude;
> +	__be16 total_gain_db;
> +	__be16 base_pwr_db;
> +	__be64 tsf;
> +	s8 max_index;
> +	u8 rssi;
> +	u8 relpwr_db;
> +	u8 avgpwr_db;
> +	u8 max_exp;
> +
> +	u8 data[0];
> +} __packed;

__be16, that's a first. Just making sure that this really is big endian?

-- 
Kalle Valo
