Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([109.74.194.28]:50846 "EHLO mrs.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbbBVMVH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 07:21:07 -0500
Message-ID: <54E9C852.50809@mrs.ro> (sfid-20150222_132111_664352_169480CB)
Date: Sun, 22 Feb 2015 14:15:14 +0200
From: Valentin Manea <linux-wirelss@mrs.ro>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: emmanuel.grumbach@intel.com, eran.harary@intel.com
Subject: iwlwifi: ampdu_factor for iwl-6000 is set to 0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

   Recently I started using kernel 3.19 from Ubuntu ppa and I noticed a 
big drop in Wifi throughput. After some investigation I found that my 
router was reporting the AMPDU factor changed from 3(in 3.18) to 0(in 3.19):
cat 
/sys/kernel/debug/ieee80211/phy1/netdev:wlan1/stations/c4:xx:xx:xx:xx:xx/ht_capa:
ht supported
cap: 0x1066
         HT20/HT40
         Dynamic SM Power Save
         RX HT20 SGI
         RX HT40 SGI
         No RX STBC
         Max AMSDU length: 3839 bytes
         DSSS/CCK HT40
ampdu factor/density: 3/5
MCS mask: ff ff 00 00 00 00 00 00 00 00
MCS tx params: 1

ht supported
cap: 0x1066
         HT20/HT40
         Dynamic SM Power Save
         RX HT20 SGI
         RX HT40 SGI
         No RX STBC
         Max AMSDU length: 3839 bytes
         DSSS/CCK HT40
ampdu factor/density: 0/5
MCS mask: ff ff 00 00 00 00 00 00 00 00
MCS tx params: 1

   In my setup this means a 50% drop in downstream throughput(from 
160Mbit/s to 80Mbit/s)

   I tracked down the offending commit and it seems this is it:
  iwlwifi: change max HT and VHT A-MPDU exponent 
c064ddf318aa51647a30108f7cd151c208c62eef
   A new mechanism was created to have per device ampd_factor:
- ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+ ht_info->ampdu_factor = cfg->max_ht_ampdu_exponent;

   however the max_ht_ampdu_exponent is not set for any of the iwl-6000 
devices(including mine Intel Corporation Centrino Advanced-N 6235)

#define IWL_DEVICE_6035						\
	.fw_name_pre = IWL6030_FW_PRE,				\
	.ucode_api_max = IWL6035_UCODE_API_MAX,			\
	.ucode_api_ok = IWL6035_UCODE_API_OK,			\
	.ucode_api_min = IWL6035_UCODE_API_MIN,			\
	.device_family = IWL_DEVICE_FAMILY_6030,		\
	.max_inst_size = IWL60_RTC_INST_SIZE,			\
	.max_data_size = IWL60_RTC_DATA_SIZE,			\
	.nvm_ver = EEPROM_6030_EEPROM_VERSION,		\
	.nvm_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
	.base_params = &iwl6000_g2_base_params,			\
	.eeprom_params = &iwl6000_eeprom_params,		\
	.led_mode = IWL_LED_RF_STATE

   Since the original value of IEEE80211_HT_MAX_AMPDU_64K I would 
suggest adding it to some iwl-6000 devices.
   I did not submit any patches because I have no idea if there are 
device which would not support this feature, however it worked before 
with default value set to IEEE80211_HT_MAX_AMPDU_64K so I guess it must 
be supported.

Regards,
Valentin
