Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:33972 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbaGPJaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 05:30:14 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so604203wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 02:30:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405441966-32681-3-git-send-email-sw@simonwunderlich.de>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
	<1405441966-32681-3-git-send-email-sw@simonwunderlich.de>
Date: Wed, 16 Jul 2014 11:30:12 +0200
Message-ID: <CA+BoTQm1i2UoTtPBf7Z3QLQDBs_1uXwdG8gYOkP556+a7AqcpQ@mail.gmail.com> (sfid-20140716_113020_502542_8B580DB8)
Subject: Re: [RFC 2/2] ath10k: add spectral scan feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	Sven Eckelmann <sven@narfation.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 July 2014 18:32, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> From: Sven Eckelmann <sven@narfation.org>
>
> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
> configuring a mode through a debugfs control file. Samples can be gathered via
> another relay debugfs file.
>
> Essentially, to try it out:
>
> ip link dev wlan0 set up
> echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> iw dev wlan0 scan
> echo disable > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 > samples
>
> This feature is still experimental.
>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> ---
>  drivers/net/wireless/ath/ath10k/Kconfig    |   1 +
>  drivers/net/wireless/ath/ath10k/Makefile   |   3 +-
>  drivers/net/wireless/ath/ath10k/core.h     |   6 +
>  drivers/net/wireless/ath/ath10k/debug.c    |   3 +
>  drivers/net/wireless/ath/ath10k/spectral.c | 368 +++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/spectral.h |  66 ++++++
>  drivers/net/wireless/ath/ath10k/wmi.c      |  98 +++++++-
>  drivers/net/wireless/ath/ath10k/wmi.h      |  80 +++++++
>  drivers/net/wireless/ath/spectral_common.h |  20 ++
>  9 files changed, 643 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath10k/spectral.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/spectral.h
>
[...]
> +static void ath_debug_send_fft_sample(struct ath10k *ar,
> +                                     struct fft_sample_tlv *fft_sample_tlv)
> +{

Why ath_debug_... instead of ath10k_debug_.. ?


[...]
> +static int ath_get_spectral_vdevid(struct ath10k *ar)

ath_get_..? Shouldn't this be ath10k_get?


> +{
> +       struct ath10k_vif *arvif;
> +
> +       if (list_empty(&ar->arvifs))
> +               return -ENODEV;
> +
> +       arvif = list_first_entry(&ar->arvifs, typeof(*arvif), list);
> +       return arvif->vdev_id;
> +}

No locks? Access to arvifs must be protected with conf_mutex.

What happens when an interface is removed without spectral scan being stopped?


> +int ath10k_spectral_scan_trigger(struct ath10k *ar)
> +{
> +       int ret;
> +       int vdev_id;
> +
> +       vdev_id = ath_get_spectral_vdevid(ar);
> +       if (vdev_id < 0)
> +               return vdev_id;
> +
> +       if (ar->spectral_mode == SPECTRAL_DISABLED)
> +               return 0;
> +
> +       ret = ath10k_vdev_spectral_enable(ar, vdev_id,
> +                                         WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
> +                                         WMI_SPECTRAL_ENABLE_CMD_ENABLE);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = ath10k_vdev_spectral_enable(ar, vdev_id,
> +                                         WMI_SPECTRAL_TRIGGER_CMD_TRIGGER,
> +                                         WMI_SPECTRAL_ENABLE_CMD_ENABLE);
> +       if (ret < 0)
> +               return ret;
> +
> +       return 0;
> +}
> +
> +int ath10k_spectral_scan_config(struct ath10k *ar, enum spectral_mode mode)
> +{
> +       int count, ret;

We tend to use `res` in ath10k.


> +       struct wmi_vdev_spectral_configure_arg arg;
> +       int vdev_id;
> +
> +       vdev_id = ath_get_spectral_vdevid(ar);
> +       if (vdev_id < 0)
> +               return vdev_id;
> +
> +       ar->spectral_mode = mode;
> +
> +       ath10k_vdev_spectral_enable(ar, vdev_id,
> +                                   WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
> +                                   WMI_SPECTRAL_ENABLE_CMD_DISABLE);
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
> +       arg.scan_fft_size        = WMI_SPECTRAL_FFT_SIZE_DEFAULT;
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
> +       arg.scan_dBm_adj         = WMI_SPECTRAL_DBM_ADJ_DEFAULT;
> +       arg.scan_chn_mask        = WMI_SPECTRAL_CHN_MASK_DEFAULT;
> +
> +       ret = ath10k_vdev_spectral_configure(ar, &arg);
> +       if (ret < 0)

+ ath10k_warn("failed to configure spectral scan: %d\n", ret);


> +               return ret;
> +
> +       if (mode == SPECTRAL_BACKGROUND)
> +               ath10k_spectral_scan_trigger(ar);

Why isn't ath10k_spectral_scan_trigger() return value not checked?
Also +ath10k_warn.


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 6f83cae..7ad9c71 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1659,7 +1659,47 @@ static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
>                                 struct wmi_single_phyerr_rx_event *event,
>                                 u64 tsf)
>  {
> -       ath10k_dbg(ATH10K_DBG_WMI, "wmi event spectral scan\n");
> +       int buf_len, tlv_len, res, i = 0;
> +       struct phyerr_tlv *tlv;
> +       u8 *tlv_buf;
> +       struct phyerr_fft_report *fftr;
> +       size_t fftr_len;
> +
> +       buf_len = __le32_to_cpu(event->hdr.buf_len);
> +
> +       while (i < buf_len) {
> +               if (i + sizeof(*tlv) > buf_len) {
> +                       ath10k_warn("too short buf for tlv header (%d)\n", i);

"failed to parse phyerr tlv header at byte %d\n", i


> +                       return;
> +               }
> +
> +               tlv = (struct phyerr_tlv *)&event->bufp[i];
> +               tlv_len = __le16_to_cpu(tlv->len);
> +               tlv_buf = &event->bufp[i + sizeof(*tlv)];
> +
> +               if (i + sizeof(*tlv) + tlv_len > buf_len) {
> +                       ath10k_warn("too short buf for tlv (%d)\n", i);

"failed to parse phyerr tlv payload at byte %d\n", i


> +                       return;
> +               }
> +
> +               switch (tlv->tag) {
> +               case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
> +                       if (sizeof(*fftr) > tlv_len) {
> +                               ath10k_warn("too short fft report (%d)\n", i);

"failed to parse fft report at byte %d\n", i


> +                               return;
> +                       }
> +
> +                       fftr_len = tlv_len - sizeof(*fftr);
> +                       fftr = (struct phyerr_fft_report *)tlv_buf;
> +                       res = ath10k_process_fft(ar, event, fftr, fftr_len,
> +                                                tsf);
> +                       if (res)

+ ath10k_warn("failed to process fft report: %d\n", res)


[...]
> +int ath10k_vdev_spectral_configure(struct ath10k *ar,
> +                             const struct wmi_vdev_spectral_configure_arg *arg)

ath10k_wmi_vdev_spectral_configure


[...]
> +int ath10k_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
> +                               u32 enable)

ath10k_wmi_vdev_spectral_enable


[...]
> +struct wmi_vdev_spectral_configure_arg {
> +       u32 vdev_id;
> +       u32 scan_count;
> +       u32 scan_period;
> +       u32 scan_priority;
> +       u32 scan_fft_size;
> +       u32 scan_gc_ena;
> +       u32 scan_restart_ena;
> +       u32 scan_noise_floor_ref;
> +       u32 scan_init_delay;
> +       u32 scan_nb_tone_thr;
> +       u32 scan_str_bin_thr;
> +       u32 scan_wb_rpt_mode;
> +       u32 scan_rssi_rpt_mode;
> +       u32 scan_rssi_thr;
> +       u32 scan_pwr_format;
> +       u32 scan_rpt_mode;
> +       u32 scan_bin_scale;
> +       u32 scan_dBm_adj;
> +       u32 scan_chn_mask;

Some stuff isn't self-explanatory. I'd love to see some of these
fields documented to account for possible values (wb_rpt_mode?) and
units (init_delay?).


[...]
> +struct fft_sample_ath10k_ht20 {
> +       struct fft_sample_tlv tlv;
> +       u8 mhz;

A more suitable name would be "chan_width_mhz" I guess?


> +       __be16 freq1;
> +       __be16 freq2;
> +       __be16 noise;
> +       __be16 max_magnitude;
> +       __be16 total_gain_db;
> +       __be16 base_pwr_db;
> +       __be64 tsf;
> +       s8 max_index;
> +       u8 rssi;
> +       u8 relpwr_db;
> +       u8 avgpwr_db;
> +
> +       u8 data[SPECTRAL_ATH10K_HT20_NUM_BINS];

And as pointed out the size/count of bins is most likely not
bandwidth-dependant. It's just a matter of resolution configured with
fft_size + bin_scale. Maybe this should be a variable-sized array?


Generally this seems to be missing locking (does debugfs guarantee
serialized read/write calls?).


Michał
