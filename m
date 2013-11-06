Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33856 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3KFJra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 04:47:30 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: add phyerr/dfs handling
References: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
Date: Wed, 6 Nov 2013 11:47:11 +0200
In-Reply-To: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Tue, 29 Oct 2013 13:06:32 +0100")
Message-ID: <87bo1xuajk.fsf@kamboji.qca.qualcomm.com> (sfid-20131106_104734_104836_0B9D028C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Handle phyerr, dfs event, radar_report and fft_report.
> Add also debugfs dfs_simulate_radar and dfs_stats files.
> Use ath dfs pattern detector.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Are there any dependencies to mac80211 or cfg80211 patches? There has
been quite a lot of changes with DFS lately and it would be good to have
all those patches in ath-next branch before I apply these.

> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -21,6 +21,14 @@
>  #include "core.h"
>  #include "debug.h"
>  
> +#define ATH10K_DFS_STAT(s, p) (\
> +	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
> +			 ar->debug.dfs_stats.p))
> +
> +#define ATH10K_DFS_POOL_STAT(s, p) (\
> +	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
> +			 ar->debug.dfs_pool_stats.p))

As these are only used by ath10k_read_file_dfs() better to move those
just to top of that function.

> +static ssize_t ath10k_read_file_dfs(struct file *file, char __user *user_buf,
> +				    size_t count, loff_t *ppos)
> +{

ath10k_read_dfs_stats()?

> +	int retval = 0, size = 8000, len = 0;

Like Joe said, size can be const.

> +	struct ath10k *ar = file->private_data;
> +	char *buf;
> +
> +	buf = kzalloc(size, GFP_KERNEL);
> +	if (buf == NULL)
> +		return -ENOMEM;
> +
> +	if (!ar->dfs_detector) {
> +		len += scnprintf(buf + len, size - len, "DFS not enabled\n");
> +		goto exit;
> +	}
> +
> +	ar->debug.dfs_pool_stats = ar->dfs_detector->get_stats(ar->dfs_detector);

I think we need to take conf_mutex to make sure ar->dfs_detector is not
destroyed while we use it.

> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
> index 46e640a..cde53d6 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -33,6 +33,7 @@ enum ath10k_debug_mask {
>  	ATH10K_DBG_MGMT		= 0x00000100,
>  	ATH10K_DBG_DATA		= 0x00000200,
>  	ATH10K_DBG_BMI		= 0x00000400,
> +	ATH10K_DBG_REGULATORY	= 0x00000800,
>  	ATH10K_DBG_ANY		= 0xffffffff,
>  };
>  
> @@ -53,6 +54,7 @@ void ath10k_debug_read_service_map(struct ath10k *ar,
>  void ath10k_debug_read_target_stats(struct ath10k *ar,
>  				    struct wmi_stats_event *ev);
>  
> +#define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
>  #else

Empty line after #define

>  static inline int ath10k_debug_start(struct ath10k *ar)
>  {
> @@ -82,6 +84,7 @@ static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
>  						  struct wmi_stats_event *ev)
>  {
>  }
> +#define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
>  #endif /* CONFIG_ATH10K_DEBUGFS */

Empty line before and after #define.

>  
>  #ifdef CONFIG_ATH10K_DEBUG
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index bbb0efa..79f8bfd 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -1438,9 +1438,20 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
>  {
>  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
>  	struct ath10k *ar = hw->priv;
> +	bool result;
>  
>  	ath_reg_notifier_apply(wiphy, request, &ar->ath_common.regulatory);
>  
> +	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector) {
> +		ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs region 0x%X\n",
> +			   request->dfs_region);

"0x%x" (also applies to elsewhere in the patch)

> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1383,9 +1383,251 @@ static void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar,
>  	ath10k_dbg(ATH10K_DBG_WMI, "WMI_TBTTOFFSET_UPDATE_EVENTID\n");
>  }
>  
> +static void ath10k_dfs_radar_report(struct ath10k *ar,
> +				    struct wmi_single_phyerr_rx_event *event,
> +				    struct phyerr_radar_report *rr,
> +				    u64 tsf)
> +{
> +	u32 reg0, reg1, tsf32l;
> +	struct pulse_event pe;
> +	u64 tsf64;
> +	u8 rssi, width;

What about locking? Does this function assume that conf_mutex is held?
If yes, please document that with lockdep_assert_held(). If no, we have
a problem :)

(Reads wmi.c)

Ah, wmi events don't sleep anymore, forgot that. So we can't really use
conf_mutex here. I guess our options are bring back worker for wmi
events or use spinlock.

> +
> +	reg0 = __le32_to_cpu(rr->reg0);
> +	reg1 = __le32_to_cpu(rr->reg1);
> +
> +	ath10k_dbg(ATH10K_DBG_REGULATORY,
> +		   "wmi phyerr radar report chirp %d max_width %d agc_total_gain %d pulse_delta_diff %d\n",
> +		   MS(reg0, RADAR_REPORT_REG0_PULSE_IS_CHIRP),
> +		   MS(reg0, RADAR_REPORT_REG0_PULSE_IS_MAX_WIDTH),
> +		   MS(reg0, RADAR_REPORT_REG0_AGC_TOTAL_GAIN),
> +		   MS(reg0, RADAR_REPORT_REG0_PULSE_DELTA_DIFF));
> +	ath10k_dbg(ATH10K_DBG_REGULATORY,
> +		   "wmi phyerr radar report pulse_delta_pean %d pulse_sidx %d fft_valid %d agc_mb_gain %d subchan_mask %d\n",
> +		   MS(reg0, RADAR_REPORT_REG0_PULSE_DELTA_PEAK),
> +		   MS(reg0, RADAR_REPORT_REG0_PULSE_SIDX),
> +		   MS(reg1, RADAR_REPORT_REG1_PULSE_SRCH_FFT_VALID),
> +		   MS(reg1, RADAR_REPORT_REG1_PULSE_AGC_MB_GAIN),
> +		   MS(reg1, RADAR_REPORT_REG1_PULSE_SUBCHAN_MASK));
> +	ath10k_dbg(ATH10K_DBG_REGULATORY,
> +		   "wmi phyerr radar report pulse_tsf_offset 0x%X pulse_dur: %d\n",
> +		   MS(reg1, RADAR_REPORT_REG1_PULSE_TSF_OFFSET),
> +		   MS(reg1, RADAR_REPORT_REG1_PULSE_DUR));
> +
> +	if (!ar->dfs_detector)
> +		return;
> +
> +	/* report event to DFS pattern detector */
> +	tsf32l = __le32_to_cpu(event->hdr.tsf_timestamp);
> +	tsf64 = tsf & (~0xFFFFFFFFULL);
> +	tsf64 |= tsf32l;
> +
> +	width = MS(reg1, RADAR_REPORT_REG1_PULSE_DUR);
> +	rssi = event->hdr.rssi_combined;
> +
> +	/*
> +	 * hardware store this as 8 bit signed value,
> +	 * set to zero if negative number
> +	 */

to be consistent with rest of the comments in ath10k:

"/* hardware...."

> +	if (rssi & 0x80)
> +		rssi = 0;
> +
> +	pe.ts = tsf64;
> +	pe.freq = ar->hw->conf.chandef.chan->center_freq;
> +	pe.width = width;
> +	pe.rssi = rssi;
> +
> +	ath10k_dbg(ATH10K_DBG_REGULATORY,
> +		   "dfs add pulse freq: %d, width: %d, rssi %d, tsf: %llX\n",
> +		   pe.freq, pe.width, pe.rssi, pe.ts);
> +
> +	ATH10K_DFS_STAT_INC(ar, pulses_detected);
> +
> +	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe)) {
> +		ath10k_dbg(ATH10K_DBG_REGULATORY,
> +			   "dfs no pulse pattern detected, yet\n");
> +		return;
> +	}
> +
> +	ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs radar detected\n");
> +	ATH10K_DFS_STAT_INC(ar, radar_detected);
> +	ieee80211_radar_detected(ar->hw);
> +}
> +
> +static int ath10k_dfs_fft_report(struct ath10k *ar,
> +				 struct wmi_single_phyerr_rx_event *event,
> +				 struct phyerr_fft_report *fftr,
> +				 u64 tsf)
> +{
> +	u32 reg0, reg1;
> +	u8 rssi, peak_mag;
> +
> +	reg0 = __le32_to_cpu(fftr->reg0);
> +	reg1 = __le32_to_cpu(fftr->reg1);
> +	rssi = event->hdr.rssi_combined;

locking?

> +	ath10k_dbg(ATH10K_DBG_REGULATORY,
> +		   "wmi phyerr fft report total_gain_db %d base_pwr_db %d fft_chn_idx %d peak_sidx %d\n",
> +		   MS(reg0, SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB),
> +		   MS(reg0, SEARCH_FFT_REPORT_REG0_BASE_PWR_DB),
> +		   MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX),
> +		   MS(reg0, SEARCH_FFT_REPORT_REG0_PEAK_SIDX));
> +	ath10k_dbg(ATH10K_DBG_REGULATORY,
> +		   "wmi phyerr fft report rel_pwr_db %d avgpwr_db %d peak_mag %d num_store_bin %d\n",
> +		   MS(reg1, SEARCH_FFT_REPORT_REG1_RELPWR_DB),
> +		   MS(reg1, SEARCH_FFT_REPORT_REG1_AVGPWR_DB),
> +		   MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG),
> +		   MS(reg1, SEARCH_FFT_REPORT_REG1_NUM_STR_BINS_IB));
> +
> +	peak_mag = MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG);
> +
> +	/* false event detection */
> +	if (rssi == DFS_RSSI_POSSIBLY_FALSE &&
> +	    peak_mag < 2 * DFS_PEAK_MAG_THOLD_POSSIBLY_FALSE) {
> +		ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs false pulse detected\n");
> +		ATH10K_DFS_STAT_INC(ar, pulses_discarded);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void ath10k_wmi_event_dfs(struct ath10k *ar,
> +				 struct wmi_single_phyerr_rx_event *event,
> +				 u64 tsf)
> +{
> +	int buf_len, tlv_len, res, i = 0;
> +	struct phyerr_tlv *tlv;
> +	struct phyerr_radar_report *rr;
> +	struct phyerr_fft_report *fftr;
> +	u8 *tlv_buf;

locking?

-- 
Kalle Valo
