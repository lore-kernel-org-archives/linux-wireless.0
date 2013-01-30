Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074Ab3A3Wp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 17:45:29 -0500
Date: Thu, 31 Jan 2013 06:43:53 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [wireless-next:master 119/159]
 drivers/net/wireless/ath/ath9k/recv.c:1067:31: sparse: incorrect type in
 assignment (different base types)
Message-ID: <5109a229.zYyvFRH45EhAhNfr%fengguang.wu@intel.com> (sfid-20130130_234533_666593_7FD85869)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   c331997b6c9ad7f4b8075e6e60d3caa6e36f5938
commit: 4ab0b0aa57a794ce299b0192e924379d7353beef [119/159] ath9k: Update spectral scan output data


sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath9k/recv.c:1067:31: sparse: incorrect type in assignment (different base types)
   drivers/net/wireless/ath/ath9k/recv.c:1067:31:    expected unsigned short [unsigned] [assigned] [usertype] length
   drivers/net/wireless/ath/ath9k/recv.c:1067:31:    got restricted __be16 [usertype] <noident>
>> drivers/net/wireless/ath/ath9k/recv.c:1069:25: sparse: incorrect type in assignment (different base types)
   drivers/net/wireless/ath/ath9k/recv.c:1069:25:    expected unsigned short [unsigned] [assigned] [usertype] freq
   drivers/net/wireless/ath/ath9k/recv.c:1069:25:    got restricted __be16 [usertype] <noident>
>> drivers/net/wireless/ath/ath9k/recv.c:1114:34: sparse: incorrect type in assignment (different base types)
   drivers/net/wireless/ath/ath9k/recv.c:1114:34:    expected unsigned short [unsigned] [assigned] [usertype] max_magnitude
   drivers/net/wireless/ath/ath9k/recv.c:1114:34:    got restricted __be16 [usertype] <noident>
>> drivers/net/wireless/ath/ath9k/recv.c:1117:24: sparse: incorrect type in assignment (different base types)
   drivers/net/wireless/ath/ath9k/recv.c:1117:24:    expected unsigned long long [unsigned] [assigned] [usertype] tsf
   drivers/net/wireless/ath/ath9k/recv.c:1117:24:    got restricted __be64 [usertype] <noident>
--
>> drivers/net/wireless/ath/ath9k/debug.c:1243:18: sparse: cast to restricted __be16
>> drivers/net/wireless/ath/ath9k/debug.c:1243:18: sparse: cast to restricted __be16
>> drivers/net/wireless/ath/ath9k/debug.c:1243:18: sparse: cast to restricted __be16
>> drivers/net/wireless/ath/ath9k/debug.c:1243:18: sparse: cast to restricted __be16

vim +1067 drivers/net/wireless/ath/ath9k/recv.c

  1061		if ((len > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) ||
  1062		    (len < SPECTRAL_HT20_TOTAL_DATA_LEN - 1))
  1063			return 1;
  1064	
  1065		fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
  1066		fft_sample.tlv.length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
> 1067		fft_sample.tlv.length = __cpu_to_be16(fft_sample.tlv.length);
  1068	
  1069		fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
  1070		fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
  1071		fft_sample.noise = ah->noise;
  1072	
  1073		switch (len - SPECTRAL_HT20_TOTAL_DATA_LEN) {
  1074		case 0:
  1075			/* length correct, nothing to do. */
  1076			memcpy(bins, vdata, SPECTRAL_HT20_NUM_BINS);
  1077			break;
  1078		case -1:
  1079			/* first byte missing, duplicate it. */
  1080			memcpy(&bins[1], vdata, SPECTRAL_HT20_NUM_BINS - 1);
  1081			bins[0] = vdata[0];
  1082			break;
  1083		case 2:
  1084			/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
  1085			memcpy(bins, vdata, 30);
  1086			bins[30] = vdata[31];
  1087			memcpy(&bins[31], &vdata[33], SPECTRAL_HT20_NUM_BINS - 31);
  1088			break;
  1089		case 1:
  1090			/* MAC added 2 extra bytes AND first byte is missing. */
  1091			bins[0] = vdata[0];
  1092			memcpy(&bins[0], vdata, 30);
  1093			bins[31] = vdata[31];
  1094			memcpy(&bins[32], &vdata[33], SPECTRAL_HT20_NUM_BINS - 32);
  1095			break;
  1096		default:
  1097			return 1;
  1098		}
  1099	
  1100		/* DC value (value in the middle) is the blind spot of the spectral
  1101		 * sample and invalid, interpolate it.
  1102		 */
  1103		dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
  1104		bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
  1105	
  1106		/* mag data is at the end of the frame, in front of radar_info */
  1107		mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
  1108	
  1109		/* copy raw bins without scaling them */
  1110		memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
  1111		fft_sample.max_exp = mag_info->max_exp & 0xf;
  1112	
  1113		fft_sample.max_magnitude = spectral_max_magnitude(mag_info->all_bins);
  1114		fft_sample.max_magnitude = __cpu_to_be16(fft_sample.max_magnitude);
  1115		fft_sample.max_index = spectral_max_index(mag_info->all_bins);
  1116		fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
  1117		fft_sample.tsf = __cpu_to_be64(tsf);
  1118	
  1119		ath_debug_send_fft_sample(sc, &fft_sample.tlv);
  1120		return 1;

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
