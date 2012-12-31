Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49608 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2LaFdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 00:33:08 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so9202339wib.13
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2012 21:33:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50D04EC9.2040805@neratec.com>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50D04EC9.2040805@neratec.com>
Date: Sun, 30 Dec 2012 21:33:06 -0800
Message-ID: <CAJ-VmonRjawqBY+F_-in3sSTpen=KaW9FNrG=140q38NtFCJbw@mail.gmail.com> (sfid-20121231_063317_444224_8198FF5C)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, jonbither@gmail.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm just going through and hacking on this now for FreeBSD (and
userland decoding, rather than kernel side decoding.)

Your frame length logic is OK for the short spectral scan reports, but
not useful for the longer aggregate reports (short_rpt=0 IIRC.)

Here there's >1 FFT report in a frame, _and_ it could be corrupted,
_and_ it could be short.

I'm just writing a userland library now to start parsing and
correcting these. It's likely that I can use your logic for the short
spectral reports, but I won't be able to use them for the longer
aggregate reports. We'll need to find some other way to determine that
they've been corrupted and just toss/correct as appropriate.

Thanks for digging into this!



Adrian

On 18 December 2012 03:08, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> On 12/13/2012 03:07 PM, Simon Wunderlich wrote:
>> Hey there,
>>
>> just to bump the issue again - isn't there anyone here who can answer
>> some of these questions?
>>
>> [...]
>>
>> Thanks a lot!
>>       Simon
>>
> Note: removed John, Johannes and Juoni from CC, since this is ath9k specific
>
>
> Hi Simon,
>
> I have a spectral scanning module up and running in an AR9590 based system and can
> provide you some relevant observations and experiences I made.
>
>
> First off: forget about 40MHz for now. It is either not working at all or way too
> unstable (tested with 9280, 9380, 9580).
>
> In 20MHz mode, spectral data is provided in the following format:
>
> +#define SPECTRAL_HT20_NUM_BINS         56
> +#define SPECTRAL_HT20_DC_INDEX         (SPECTRAL_HT20_NUM_BINS / 2)
> +#define SPECTRAL_HT20_TOTAL_DATA_LEN   (sizeof(struct ht20_fft_packet) + 3)
> +
> +struct ht20_mag_data {
> +       u8 all_bins1;
> +       u8 max_mag_bits29;
> +       u8 all_bins2;
> +       u8 max_exp;
> +} __attribute__((packed));
> +
> +struct ht20_fft_packet {
> +       u8 bin[SPECTRAL_HT20_NUM_BINS];
> +       struct ht20_mag_data mag_data;
> +} __attribute__((packed));
> +
>
> When spectral data is ready, the length is sometimes reported incorrectly, valid
> values are between (SPECTRAL_HT20_TOTAL_DATA_LEN - 1) and
> (SPECTRAL_HT20_TOTAL_DATA_LEN + 2), my code snipped to check the validity is:
>
> +static s8 fix_rssi_inv_only(u8 rssi_val)
> +{
> +       if (rssi_val == 128)
> +               rssi_val = 0;
> +       return (s8) rssi_val;
> +}
> +
> +#define SPECTRAL_SCAN_BITMASK 0x10
> +
> +/*
> + * check PHY-error for spectral
> + */
> +bool process_spectral_phyerr(struct ath_softc *sc, void *data,
> +                            struct ath_rx_status *rs, u64 mactime)
> +{
> +       u16 datalen;
> +       char *vdata_end;
> +       struct ath_hw *ah = sc->sc_ah;
> +       struct ath_spectral_scanner *ass = ah->spectral_scanner;
> +       struct ath_spectral_data *sd = &ass->spectral_data;
> +       u8 pulse_bw_info;
> +       s8 rssi;
> +       struct spectral_ht20_msg *msg;
> +
> +       sd->stats.total_phy_errors++;
> +
> +       if (rs->rs_phyerr != ATH9K_PHYERR_SPECTRAL) {
> +               sd->stats.drop_non_spectral++;
> +               return false;
> +       }
> +
> +       datalen = rs->rs_datalen;
> +       if (datalen > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) {
> +               sd->stats.drop_len_overflow++;
> +               return false;
> +       }
> +       if (datalen < SPECTRAL_HT20_TOTAL_DATA_LEN - 1) {
> +               sd->stats.drop_len_underflow++;
> +               return false;
> +       }
> +
> +       vdata_end = (char *)data + datalen;
> +       pulse_bw_info = vdata_end[-1];
> +
> +       if (!(pulse_bw_info & SPECTRAL_SCAN_BITMASK)) {
> +               sd->stats.drop_non_spectral++;
> +               return false;
> +       }
> +
> +       rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
> +
> +       sd->stats.descriptors_processed++;
> +
> +       ath_process_spectraldata_ht20(ah, data, datalen, rssi, mactime, msg);
> +
> +       sd->run_stats.last_tstamp = mactime;
> +       sd->run_stats.spectral_packets++;
> +
> +       return true;
> +}
>
> As for the incorrect data, there are 4 cases to consider:
> 1) data length is correct => take the 56 bins as is
> 2) data length is 1 less => duplicate the first bin
> 3) data length is 2 more => remove bins 30 and 32
> 4) data length is 1 more => combine 2) + 3)
>
> The code snippet to handle this post-processing is:
>
> +static s8 fix_max_index(u8 max_index)
> +{
> +       s8 maxindex = max_index;
> +       if (max_index > 32)
> +               maxindex |= 0xe0;
> +       else
> +               maxindex &= ~0xe0;
> +       maxindex += 29;
> +       return maxindex;
> +}
> +
> +static void ath_process_spectraldata_ht20(struct ath_hw *ah, u8 *vdata,
> +               u16 datalen, s8 rssi, u64 fulltsf,
> +               struct spectral_ht20_msg *nl_msg)
> +{
> +       struct ath_spectral_data *sd = &ah->spectral_scanner->spectral_data;
> +       u8 *vdata_end = (char*)vdata + datalen;
> +       u8 *msg_bin = nl_msg->bin;
> +       struct ht20_mag_data *mag = (struct ht20_mag_data *) (vdata_end - 7);
> +
> +       switch(datalen - SPECTRAL_HT20_TOTAL_DATA_LEN) {
> +       case 0:
> +               // correct length
> +               memcpy(msg_bin, vdata, SPECTRAL_HT20_NUM_BINS);
> +               sd->stats.datalen_ok++;
> +               break;
> +       case -1:
> +               // missing the first byte -> duplicate first as byte 0 and 1
> +               msg_bin[0] = vdata[0];
> +               memcpy(msg_bin + 1, vdata, SPECTRAL_HT20_NUM_BINS - 1);
> +               sd->stats.datalen_m1++;
> +               break;
> +       case 2:
> +               // MAC added 2 extra bytes at bin 30 and 32
> +               memcpy(msg_bin, vdata, 30);
> +               msg_bin[30] = vdata[31];
> +               memcpy(msg_bin + 31, vdata + 33, SPECTRAL_HT20_NUM_BINS - 31);
> +               sd->stats.datalen_p2++;
> +               break;
> +       case 1:
> +               // MAC added 2 extra bytes AND first byte missing
> +               msg_bin[0] = vdata[0];
> +               memcpy(msg_bin + 1, vdata, 30);
> +               msg_bin[31] = vdata[31];
> +               memcpy(msg_bin + 32, vdata + 33, SPECTRAL_HT20_NUM_BINS - 32);
> +               sd->stats.datalen_p2m1++;
> +               break;
> +       }
> +
> +       /* global data */
> +       nl_msg->freq = sd->center_freq;
> +       nl_msg->rssi = rssi;
> +       nl_msg->noise_floor = ah->noise; //ah->caldata->nfCalHist[0].privNF;
> +       nl_msg->tstamp = fulltsf;
> +
> +       /* extract magnitude scaling data */
> +       nl_msg->max_magnitude = (mag->max_mag_bits29 << 2) |
> +                               ((mag->all_bins1 & 0xc0) >> 6) |
> +                               ((mag->all_bins2 & 0x03) << 10);
> +       nl_msg->bitmap_weight = mag->all_bins1 & 0x3f;
> +       nl_msg->max_index = fix_max_index(mag->all_bins2 & 0x3f);
> +       nl_msg->max_exp = mag->max_exp & 0x0f;
> +}
>
> In my system the post-processed FFT raw data is transferred via a netlink
> interface to a spectral_proxy, that forwards it to a connected host for real-time
> inspection and visualization.
>
> The interpretation of the data is as follows: the reported values are given as
> magnitudes, which need to be scaled and converted to absolute power values based
> on the packet's noise floor and RSSI values as follows:
> bin_sum = 10*log(sum[i=1..56](b(i)^2)
> power(i) = noise_floor + RSSI + 10*log(b(i)^2) - bin_sum
>
> The code fragment to convert magnitude to absolute power values looks like this
> (assuming you transferred the FFT and magnitude data to user space):
> bool convert_data(struct spectral_ht20_msg *msg)
> +{
> +       u_int8_t *bin_pwr = msg->bin;
> +       u_int8_t *dc_pwr = msg->bin + SPECTRAL_NUM_BINS / 2;
> +       int pwr_count = SPECTRAL_NUM_BINS;
> +       int8_t rssi = msg->rssi;
> +       int8_t max_scale = 1 << msg->max_exp;
> +       int16_t max_mag = msg->max_magnitude;
> +       int i;
> +       int nf0 = msg->noise_floor;
> +
> +       float bsum = 0.0;
> +
> +       // DC value is invalid -> interpolate
> +       *dc_pwr = (dc_pwr[-1] + dc_pwr[1]) / 2;
> +
> +       for (i = 0; i < pwr_count; i++)
> +               bsum += (bin_pwr[i] * max_scale) * (bin_pwr[i] * max_scale);
> +       bsum = log10f(bsum) * 10;
> +
> +       for (i = 0; i < pwr_count; i++) {
> +               float pwr_val;
> +               int16_t val = bin_pwr[i];
> +
> +               if (val == 0)
> +                       val = 1;
> +
> +               pwr_val = 20 * log10f((float) val * max_scale);
> +               pwr_val += nf0 + rssi - bsum;
> +
> +               val = pwr_val;
> +               bin_pwr[i] = val;
> +       }
> +       return true;
> +}
>
>
> That's it, now you should be able to feed the raw data to whatever visualization,
> statistics and classification back-ends.
>
>
> Hope this helps somewhat. My implementation is quite application specific (like
> operational only as monitor, dedicated netlink interface, proxy-forwarding, etc.)
> and not usable for the generic user. That's why I am not posting it here and
> polluting the mailing list. If you (or anybody else out there) would like to test
> it as proof-of-concept, I can provide you the complete OpenWRT integration.
>
>
> Cheers,
> Zefir
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
