Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:54081 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab2GWQBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 12:01:23 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, thomas@net.t-labs.tu-berlin.de,
	nbd@nbd.name
Subject: [PATCH 0/2] ath5k: fixing broken power gain calibration at 5GHz and txpower handling 
Date: Mon, 23 Jul 2012 18:01:13 +0200
Message-Id: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120723_180129_448177_F10BDC75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fix a wrong power gain calibration in ath5k for
entire 5GHz band and enables consistent usage of tx_power specified by
the user.

(1)
Function ath5k_eeprom_read_target_rate_pwr_info() read 10 lines of
rate_pcal_info[i].target_power which worngly produces e.g. from 
Winstron CM9:
[   38.988000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[0].freq = 4920, rate_pcal_info[0].target_power_6to24 = 36, rate_pcal_info[0].target_power_54 = 24
[   39.004000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[1].freq = 5040, rate_pcal_info[1].target_power_6to24 = 36, rate_pcal_info[1].target_power_54 = 24
[   39.020000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[2].freq = 5170, rate_pcal_info[2].target_power_6to24 = 36, rate_pcal_info[2].target_power_54 = 26
[   39.040000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[3].freq = 5240, rate_pcal_info[3].target_power_6to24 = 38, rate_pcal_info[3].target_power_54 = 26
[   39.056000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[4].freq = 5320, rate_pcal_info[4].target_power_6to24 = 38, rate_pcal_info[4].target_power_54 = 26
[   39.076000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[5].freq = 5500, rate_pcal_info[5].target_power_6to24 = 38, rate_pcal_info[5].target_power_54 = 26
[   39.092000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[6].freq = 5700, rate_pcal_info[6].target_power_6to24 = 36, rate_pcal_info[6].target_power_54 = 26
[   39.112000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[7].freq = 5825, rate_pcal_info[7].target_power_6to24 = 34, rate_pcal_info[7].target_power_54 = 24
[   39.128000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[8].freq = 5360, rate_pcal_info[8].target_power_6to24 = 39, rate_pcal_info[8].target_power_54 = 39
[   39.144000] [ath5k_eeprom_read_target_rate_pwr_info] rate_pcal_info[9].freq = 5720, rate_pcal_info[9].target_power_6to24 = 38, rate_pcal_info[9].target_power_54 = 38

Beside that both last 2 lines hold invalid power gain values the last
line is responsible that subsequent interpolation functions apply
full power gain to all rates at all frequencies greater
rate_pcal_info[max].freq, i.e. > 5720 MHz. This leads to spectral
distortion when then global tx_power is higher than the expected
rate_pcal_info[xy].target_power_54 and therfore gives rates above
24MBit a very poor performance in therms of throughput. The first
patch reduces the eeprom calibration reads to 8. A validation
against madwifi showed 8x eeprom reads at 5GHz as well.

(2)
Furthermore the tx_power specified by the user is not respected in
cases where function phy_init() got called: tx_power is always
set to ah->ah_txpower.txp_cur_pwr which is never updated with the
txpower value specified by the user instead it equales max chan power
and is even incremented. So this wrong behavior amplifies the
occurrence of the performance problems coming from the wrong
calibration in cases the user set a low power. The second patch
fixes this by properly introduce and respect user tx_power.

Greetings Thomas

