Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37985 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3I3QTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 12:19:49 -0400
Received: by mail-oa0-f53.google.com with SMTP id i7so3852214oag.40
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 09:19:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130930160437.GA15780@pandem0nium>
References: <1380206258-16452-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<20130930160437.GA15780@pandem0nium>
Date: Mon, 30 Sep 2013 18:19:49 +0200
Message-ID: <CAA2SeNL=WTYOY2x2qdCBVc6z8FEn+ngVbV=nyb7XxT6pgvJfqg@mail.gmail.com> (sfid-20130930_181953_873874_9C8FB73E)
Subject: Re: [RFC] ath9k: add HT40 spectral scan capability
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Simon for your suggestions. I will review the patch.
Cheers,

Lorenzo

2013/9/30 Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>:
> Hey Lorenzo,
>
> thanks for your work. Please find a few comments inline:
>
> On Thu, Sep 26, 2013 at 04:37:38PM +0200, Lorenzo Bianconi wrote:
>> Add spectral scan feature on HT40 channels for ath9k. This patch extends
>> previous capability added by Simon Wunderlich
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/ath9k.h |  47 +++++++----
>>  drivers/net/wireless/ath/ath9k/calib.c |  10 +--
>>  drivers/net/wireless/ath/ath9k/calib.h |   3 +-
>>  drivers/net/wireless/ath/ath9k/hw.c    |   2 +-
>>  drivers/net/wireless/ath/ath9k/link.c  |   3 +-
>>  drivers/net/wireless/ath/ath9k/recv.c  | 142 ++++++++++++++++++++++-----------
>>  6 files changed, 139 insertions(+), 68 deletions(-)
>>
>> [...]
>> diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
>> index 5e8219a..d09eaeb 100644
>> --- a/drivers/net/wireless/ath/ath9k/calib.c
>> +++ b/drivers/net/wireless/ath/ath9k/calib.c
>> @@ -63,13 +63,13 @@ static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
>>       return ath9k_hw_get_nf_limits(ah, chan)->nominal;
>>  }
>>
>> -s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
>> +s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan,
>> +                        s16 nf)
>>  {
>>       s8 noise = ATH_DEFAULT_NOISE_FLOOR;
>>
>> -     if (chan && chan->noisefloor) {
>> -             s8 delta = chan->noisefloor -
>> -                        ATH9K_NF_CAL_NOISE_THRESH -
>> +     if (nf) {
>> +             s8 delta = nf - ATH9K_NF_CAL_NOISE_THRESH -
>>                          ath9k_hw_get_default_nf(ah, chan);
>>               if (delta > 0)
>>                       noise += delta;
>> @@ -394,7 +394,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
>>       caldata->nfcal_pending = false;
>>       ath9k_hw_update_nfcal_hist_buffer(ah, caldata, nfarray);
>>       chan->noisefloor = h[0].privNF;
>> -     ah->noise = ath9k_hw_getchan_noise(ah, chan);
>> +     ah->noise = ath9k_hw_getchan_noise(ah, chan, chan->noisefloor);
>>       return true;
>>  }
>>  EXPORT_SYMBOL(ath9k_hw_getnf);
>> diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
>> index 3d70b8c..b8ed95e 100644
>> --- a/drivers/net/wireless/ath/ath9k/calib.h
>> +++ b/drivers/net/wireless/ath/ath9k/calib.h
>> @@ -116,7 +116,8 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
>>  void ath9k_hw_bstuck_nfcal(struct ath_hw *ah);
>>  void ath9k_hw_reset_calibration(struct ath_hw *ah,
>>                               struct ath9k_cal_list *currCal);
>> -s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
>> +s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan,
>> +                        s16 nf);
>
> I'm not entirely sure how these noise changes are connected to the patch. It appears you
> use it later, but maybe it would be good to put this in a separate patch?
>> [...]
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index 4ee472a..525f07c 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -972,14 +972,13 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
>>  {
>>  #ifdef CONFIG_ATH9K_DEBUGFS
>>       struct ath_hw *ah = sc->sc_ah;
>> -     u8 bins[SPECTRAL_HT20_NUM_BINS];
>> -     u8 *vdata = (u8 *)hdr;
>> -     struct fft_sample_ht20 fft_sample;
>> +     u8 type, num_bins, *data, *vdata = (u8 *) hdr;
>> +     struct fft_sample fft_data;
>
> If you keep the variable name fft_sample, you can save quite a lot renames below. And that
> would make it easier for this patch to review.
>
>>       struct ath_radar_info *radar_info;
>> -     struct ath_ht20_mag_info *mag_info;
>>       int len = rs->rs_datalen;
>>       int dc_pos;
>> -     u16 length, max_magnitude;
>> +     u16 length, fft_len;
>> +     enum nl80211_channel_type chtype;
>>
>>       /* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
>>        * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
>> @@ -997,45 +996,53 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
>>       if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
>>               return 0;
>>
>> -     /* Variation in the data length is possible and will be fixed later.
>> -      * Note that we only support HT20 for now.
>> -      *
>> -      * TODO: add HT20_40 support as well.
>> -      */
>> -     if ((len > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) ||
>> -         (len < SPECTRAL_HT20_TOTAL_DATA_LEN - 1))
>> +     chtype = cfg80211_get_chandef_type(&sc->hw->conf.chandef);
>> +     if ((chtype == NL80211_CHAN_HT40MINUS) ||
>> +         (chtype == NL80211_CHAN_HT40PLUS)) {
>> +             type = FFT_SAMPLE_HT20_40;
>> +             num_bins = SPECTRAL_HT20_40_NUM_BINS;
>> +             fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
>> +             data = (u8 *) fft_data.ht20_40.data;
>> +     } else {
>> +             type = FFT_SAMPLE_HT20;
>> +             num_bins = SPECTRAL_HT20_NUM_BINS;
>> +             fft_len = SPECTRAL_HT20_TOTAL_DATA_LEN;
>> +             data = (u8 *) fft_data.ht20.data;
>> +     }
>> +
>> +     /* variation in the data length is possible and will be fixed later */
>> +     if ((len > fft_len + 2) || (len < fft_len - 1))
>>               return 1;
>>
>> -     fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
>> -     length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
>> -     fft_sample.tlv.length = __cpu_to_be16(length);
>> +     fft_data.tlv.type = __cpu_to_be32(type);
>> +     length = sizeof(fft_data) - sizeof(fft_data.tlv);
>> +     fft_data.tlv.length = __cpu_to_be16(length);
>>
>> -     fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
>> -     fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
>> -     fft_sample.noise = ah->noise;
>> +     fft_data.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
>> +     fft_data.tsf = __cpu_to_be64(tsf);
>>
>> -     switch (len - SPECTRAL_HT20_TOTAL_DATA_LEN) {
>> +     switch (len - fft_len) {
>>       case 0:
>>               /* length correct, nothing to do. */
>> -             memcpy(bins, vdata, SPECTRAL_HT20_NUM_BINS);
>> +             memcpy(data, vdata, num_bins);
>>               break;
>>       case -1:
>>               /* first byte missing, duplicate it. */
>> -             memcpy(&bins[1], vdata, SPECTRAL_HT20_NUM_BINS - 1);
>> -             bins[0] = vdata[0];
>> +             memcpy(&data[1], vdata, num_bins - 1);
>> +             data[0] = vdata[0];
>>               break;
>>       case 2:
>>               /* MAC added 2 extra bytes at bin 30 and 32, remove them. */
>> -             memcpy(bins, vdata, 30);
>> -             bins[30] = vdata[31];
>> -             memcpy(&bins[31], &vdata[33], SPECTRAL_HT20_NUM_BINS - 31);
>> +             memcpy(data, vdata, 30);
>> +             data[30] = vdata[31];
>> +             memcpy(&data[31], &vdata[33], num_bins - 31);
>>               break;
>>       case 1:
>>               /* MAC added 2 extra bytes AND first byte is missing. */
>> -             bins[0] = vdata[0];
>> -             memcpy(&bins[0], vdata, 30);
>> -             bins[31] = vdata[31];
>> -             memcpy(&bins[32], &vdata[33], SPECTRAL_HT20_NUM_BINS - 32);
>> +             data[0] = vdata[0];
>> +             memcpy(&data[1], vdata, 30);
>> +             data[31] = vdata[31];
>> +             memcpy(&data[32], &vdata[33], num_bins - 32);
>
> I hope you tested whether this byte shuffling works as expected for HT40?
>
>>               break;
>>       default:
>>               return 1;
>> @@ -1044,23 +1051,68 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
>>       /* DC value (value in the middle) is the blind spot of the spectral
>>        * sample and invalid, interpolate it.
>>        */
>> -     dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
>> -     bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
>
> Same for the DC value here ...
>
>> -
>> -     /* mag data is at the end of the frame, in front of radar_info */
>> -     mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
>> -
>> -     /* copy raw bins without scaling them */
>> -     memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
>> -     fft_sample.max_exp = mag_info->max_exp & 0xf;
>> -
>> -     max_magnitude = spectral_max_magnitude(mag_info->all_bins);
>> -     fft_sample.max_magnitude = __cpu_to_be16(max_magnitude);
>> -     fft_sample.max_index = spectral_max_index(mag_info->all_bins);
>> -     fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
>> -     fft_sample.tsf = __cpu_to_be64(tsf);
>> +     dc_pos = num_bins / 2;
>> +     data[dc_pos] = (data[dc_pos + 1] + data[dc_pos - 1]) / 2;
>> +
>> +     if ((chtype == NL80211_CHAN_HT40MINUS) ||
>> +         (chtype == NL80211_CHAN_HT40PLUS)) {
>> +             u16 lower_max_mag, upper_max_mag;
>> +             s16 nf_ext;
>> +             struct ath_ht20_40_mag_info *mag_info;
>> +             struct ath9k_hw_cal_data *caldata = ah->caldata;
>> +
>> +             if (caldata)
>> +                     nf_ext = ath9k_hw_getchan_noise(ah, ah->curchan,
>> +                                             caldata->nfCalHist[3].privNF);
>> +             else
>> +                     nf_ext = ATH_DEFAULT_NOISE_FLOOR;
>> +
>> +             mag_info = ((struct ath_ht20_40_mag_info *)radar_info) - 1;
>> +             lower_max_mag = spectral_max_magnitude(mag_info->lower_bins);
>> +             upper_max_mag = spectral_max_magnitude(mag_info->upper_bins);
>> +
>> +             if (chtype == NL80211_CHAN_HT40PLUS) {
>> +                     fft_data.ht20_40.lower_rssi =
>> +                             fix_rssi_inv_only(rs->rs_rssi_ctl0);
>> +                     fft_data.ht20_40.upper_rssi =
>> +                             fix_rssi_inv_only(rs->rs_rssi_ext0);
>> +                     fft_data.ht20_40.lower_nf = ah->noise;
>> +                     fft_data.ht20_40.upper_nf = nf_ext;
>> +             } else {
>> +                     fft_data.ht20_40.lower_rssi =
>> +                             fix_rssi_inv_only(rs->rs_rssi_ext0);
>> +                     fft_data.ht20_40.upper_rssi =
>> +                             fix_rssi_inv_only(rs->rs_rssi_ctl0);
>> +                     fft_data.ht20_40.lower_nf = nf_ext;
>> +                     fft_data.ht20_40.upper_nf = ah->noise;
>> +             }
>> +             fft_data.ht20_40.lower_max_mag = __cpu_to_be16(lower_max_mag);
>> +             fft_data.ht20_40.lower_max_idx =
>> +                     spectral_max_index(mag_info->lower_bins);
>> +             fft_data.ht20_40.lower_bitmap_w =
>> +                     spectral_bitmap_weight(mag_info->lower_bins);
>> +             fft_data.ht20_40.upper_max_mag = __cpu_to_be16(upper_max_mag);
>> +             fft_data.ht20_40.upper_max_idx =
>> +                     spectral_max_index(mag_info->upper_bins);
>> +             fft_data.ht20_40.upper_bitmap_w =
>> +                     spectral_bitmap_weight(mag_info->upper_bins);
>> +             fft_data.ht20_40.max_exp = mag_info->max_exp & 0xf;
>
>
> Could you please try to use some local variables here? I think this could
> avoid a few of these ugly multi-line assignments ...
>
>> +     } else {
>> +             u16 max_mag;
>> +             struct ath_ht20_mag_info *mag_info;
>> +
>> +             mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
>> +             max_mag = spectral_max_magnitude(mag_info->all_bins);
>> +             fft_data.ht20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
>> +             fft_data.ht20.nf = ah->noise;
>> +             fft_data.ht20.max_mag = __cpu_to_be16(max_mag);
>> +             fft_data.ht20.max_idx = spectral_max_index(mag_info->all_bins);
>> +             fft_data.ht20.bitmap_w =
>> +                     spectral_bitmap_weight(mag_info->all_bins);
>> +             fft_data.ht20.max_exp = mag_info->max_exp & 0xf;
>> +     }
>>
>> -     ath_debug_send_fft_sample(sc, &fft_sample.tlv);
>> +     ath_debug_send_fft_sample(sc, &fft_data.tlv);
>>       return 1;
>>  #else
>>       return 0;
>> --
>> 1.8.1.2
>>
>
> Cheers,
>         Simon



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
