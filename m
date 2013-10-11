Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:34727 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3JKLdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 07:33:50 -0400
Received: by mail-vb0-f50.google.com with SMTP id x14so2616281vbb.23
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 04:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131010133118.GA32128@pandem0nium>
References: <1381007769-11800-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1381007769-11800-3-git-send-email-lorenzo.bianconi83@gmail.com>
	<20131010133118.GA32128@pandem0nium>
Date: Fri, 11 Oct 2013 13:33:49 +0200
Message-ID: <CAA2SeNJk2JxRfMzZd1VR=nA+e3gNoa+jdfcU8rZAUbsdGrHJ2g@mail.gmail.com> (sfid-20131011_133353_646315_529D3FD8)
Subject: Re: [PATCH 2/2] ath9k: add HT40 spectral scan capability
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

> Hello Lorenzo,
>
> I've reviewed and tested your patch, this looks good! The old format still works, and
> for a HT40+ channel I get your new format. Please find a few minor comments inline,
> and feel free to add my Tested-by/Reviewed-by in the next round.
>

Perfect, I will send a new patchset with changes you suggested me

> BTW, i failed to compile your UI[1]. I'm not familiar with QT, maybe you can add some
> installation document (or Makefile or whatever)? :)

Sorry, I forgot to commit main.c :)
You should install Qwt libraries (http://qwt.sourceforge.net/) since
they are not compiled statically into the program and then run qmake
and make. I tested UI with Qwt-6.1.0 and Qt-5.0.1
Anyway, I will write a README

>
> [1] https://github.com/LorenzoBianconi/ath_spectral
>
> On Sat, Oct 05, 2013 at 11:16:09PM +0200, Lorenzo Bianconi wrote:
>> @@ -905,6 +906,33 @@ struct fft_sample_ht20 {
>>       u8 data[SPECTRAL_HT20_NUM_BINS];
>>  } __packed;
>>
>> +struct fft_sample_ht20_40 {
>> +     struct fft_sample_tlv tlv;
>> +
>> +     u8 max_exp;
>> +
>> +     __be16 freq;
>
> What does the frequency tell us? This is just the frequency of the primary
> channel, isn't it? You could either:
>  1) make this the center frequency of both channels (e.g. for 2412 HT40+ this would be 2422)
>  2) add a field to indicate HT40+ or HT40- or
>  3) use lower_freq and upper_freq
>
> Option 2 would have the advantage that the channel type is clear, not sure if this matters. :)
>

Yes, it is control channel. I prefer option 2 too. I will add a
channel type filed into fft_sample_ht20_40 structure.

>> +
>> +     s8 lower_rssi;
>> +     s8 upper_rssi;
>> +
>> +     __be64 tsf;
>> +
>> +     s8 lower_noise;
>> +     s8 upper_noise;
>> +
>> +     __be16 lower_max_magnitude;
>> +     __be16 upper_max_magnitude;
>> +
>> +     u8 lower_max_index;
>> +     u8 upper_max_index;
>> +
>> +     u8 lower_bitmap_weight;
>> +     u8 upper_bitmap_weight;
>> +
>> +     u8 data[SPECTRAL_HT20_40_NUM_BINS];
>> +} __packed;
>> +
>>  void ath9k_tasklet(unsigned long data);
>>  int ath_cabq_update(struct ath_softc *);
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index ab9e3a8..b49fd13 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -972,14 +972,14 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
>>  {
>>  #ifdef CONFIG_ATH9K_DEBUGFS
>>       struct ath_hw *ah = sc->sc_ah;
>> -     u8 bins[SPECTRAL_HT20_NUM_BINS];
>> -     u8 *vdata = (u8 *)hdr;
>> -     struct fft_sample_ht20 fft_sample;
>> +     u8 num_bins, *bins, *sample, *vdata = (u8 *)hdr;
>> +     struct fft_sample_ht20 fft_sample_20;
>> +     struct fft_sample_ht20_40 fft_sample_40;
>>       struct ath_radar_info *radar_info;
>> -     struct ath_ht20_mag_info *mag_info;
>>       int len = rs->rs_datalen;
>>       int dc_pos;
>> -     u16 length, max_magnitude;
>> +     u16 fft_len, length, freq = ah->curchan->chan->center_freq;
>> +     enum nl80211_channel_type chan_type;
>>
>>       /* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
>>        * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
>> @@ -997,45 +997,44 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
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
>> -             return 1;
>> -
>> -     fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
>> -     length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
>> -     fft_sample.tlv.length = __cpu_to_be16(length);
>> +     chan_type = cfg80211_get_chandef_type(&sc->hw->conf.chandef);
>> +     if ((chan_type == NL80211_CHAN_HT40MINUS) ||
>> +         (chan_type == NL80211_CHAN_HT40PLUS)) {
>> +             fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
>> +             num_bins = SPECTRAL_HT20_40_NUM_BINS;
>> +             bins = (u8 *) fft_sample_40.data;
>
> I get a few checkpatch errors here, like:
>
> 0002-ath9k-add-HT40-spectral-scan-capability.patch
> CHECK: No space is necessary after a cast
> #101: FILE: drivers/net/wireless/ath/ath9k/recv.c:1005:
> +               num_bins = SPECTRAL_HT20_40_NUM_BINS;
> +               bins = (u8 *) fft_sample_40.data;
>
> CHECK: No space is necessary after a cast
> #105: FILE: drivers/net/wireless/ath/ath9k/recv.c:1009:
> +               num_bins = SPECTRAL_HT20_NUM_BINS;
> +               bins = (u8 *) fft_sample_20.data;
>
> There are a few more, please check using ./scripts/checkpatch.pl --strict.
>
> (I think you can ignore the camelcase errors though).
>
> Thanks,
>         Simon

Fixed

Regards
Lorenzo



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
