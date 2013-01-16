Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48251 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3APVjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 16:39:36 -0500
From: "Chadd, Adrian" <achadd@qca.qualcomm.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Sven Eckelmann <sven@open-mesh.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	"tobias.steinicke@net.t-labs.tu-berlin.de"
	<tobias.steinicke@net.t-labs.tu-berlin.de>,
	"mathias.kretschmer@fokus.fraunhofer.de"
	<mathias.kretschmer@fokus.fraunhofer.de>
Subject: RE: [PATCH] ath9k: Save spectral scan data in network byteorder
Date: Wed, 16 Jan 2013 21:39:35 +0000
Message-ID: <48EC4E8D43A28947B1AB2639FA97CDB920AD4657@nasanexd02a.na.qualcomm.com> (sfid-20130116_223941_551593_E4681284)
References: <1358251363-14385-1-git-send-email-sven@open-mesh.com>
 <20130116085931.GA13648@pandem0nium>,<50F6788B.9050409@neratec.com>
In-Reply-To: <50F6788B.9050409@neratec.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Yes, I advocate doing it all in userspace.

I'm just exporting the raw PHY errors via bpf, so I can just expose all PHY errors this way and let the userland application do what it wants with this.

I do the same with radar data too, fwiw.



Adrian

________________________________________
From: Zefir Kurtisi [zefir.kurtisi@neratec.com]
Sent: Wednesday, 16 January 2013 1:53 AM
To: Simon Wunderlich
Cc: Sven Eckelmann; linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org; Simon Wunderlich; tobias.steinicke@net.t-labs.tu-berlin.de; mathias.kretschmer@fokus.fraunhofer.de; Chadd, Adrian
Subject: Re: [PATCH] ath9k: Save spectral scan data in network byteorder

On 01/16/2013 09:59 AM, Simon Wunderlich wrote:
> On Tue, Jan 15, 2013 at 01:02:43PM +0100, Sven Eckelmann wrote:
>> The sample data received through the spectral scan can be either in big or
>> little endian byteorder. This information isn't stored in the output file.
>> Therefore it is not possible for the analyzer software to find the correct byte
>> order.
>>
>> It is relative common to get the data from a low end AP in big endian mode and
>> transfer it to another computer in little endian mode to analyze it. Therefore,
>> it would be better to store it in network (big endian) byte order.
>
> I'd agree that changing the byteorder to the "general" network order format is
> a good idea, although we will break compatibility again - which should hopefully
> be no problem as the original patch is pretty new anyway.
>
> I was pondering about performance loss when we run spectral on the same machine
> (i.e. maybe adding two useless byteswaps per value). OTOH the byteswaps are pretty
> cheap and we do some computations anyway, so the performance difference should be quite
> small.
>
> Therefore,
>
> Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
>
> (I've CCd some more people in the reply so they can scream if they don't like it. ;])
>
> Thanks,
>       Simon
>
Hi Simon,

at this point, I'd like to advocate the approach I am currently using that does
the conversion fully in user space. There, each sample provided consists of the
fft data as bytes plus the values required to scale the magnitude values back to
absolute power numbers (i.e. the 'bug-fixed' raw data).

Since for the scaling an user space component is mandatory (FP calculations), I
miss to see the benefit of splitting post-processing in the kernel (shifting bins)
and user space. This step doubles fft data size and introduces endianess issues
for no (at least to me) evident reason.

Maybe you have a host application in mind where it does not really matter where
the processing is done. Whereas, if you operate an AP as continuous spectral
scanner, shifting the post-processing to the point where it is evaluated /
displayed (usually your fat PC) significantly impacts your AP's load and its
capability to provide higher sampling rates.

I'd assume Adrian's proposal to just push out the raw spectral data to user-space
is also targeting at that, which I fully support. The only thing I would keep in
the driver is fixing the fft data corruption caused by known chip bugs.


Cheers,
Zefir
>>
>> Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
>> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
>> ---
>> A patch for FFT_eval was also sent to the author.
>>
>>  drivers/net/wireless/ath/ath9k/recv.c |   10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index d7c129b..2fac787 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -1064,8 +1064,9 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
>>
>>      fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
>>      fft_sample.tlv.length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
>> +    fft_sample.tlv.length = __cpu_to_be16(fft_sample.tlv.length);
>>
>> -    fft_sample.freq = ah->curchan->chan->center_freq;
>> +    fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
>>      fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
>>      fft_sample.noise = ah->noise;
>>
>> @@ -1106,13 +1107,16 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
>>      mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
>>
>>      /* Apply exponent and grab further auxiliary information. */
>> -    for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++)
>> +    for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++) {
>>              fft_sample.data[i] = bins[i] << mag_info->max_exp;
>> +            fft_sample.data[i] = __cpu_to_be16(fft_sample.data[i]);
>> +    }
>>
>>      fft_sample.max_magnitude = spectral_max_magnitude(mag_info->all_bins);
>> +    fft_sample.max_magnitude = __cpu_to_be16(fft_sample.max_magnitude);
>>      fft_sample.max_index = spectral_max_index(mag_info->all_bins);
>>      fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
>> -    fft_sample.tsf = tsf;
>> +    fft_sample.tsf = __cpu_to_be64(tsf);
>>
>>      ath_debug_send_fft_sample(sc, &fft_sample.tlv);
>>  #endif
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

