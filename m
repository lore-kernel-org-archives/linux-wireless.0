Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39837 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638AbbFJUcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 16:32:00 -0400
Message-ID: <55789EBF.2060501@candelatech.com> (sfid-20150610_223206_922532_B64F4946)
Date: Wed, 10 Jun 2015 13:31:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Anyone tried ath10k AP with 40Mhz operation?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying this hostapd config file.  Beacons seem OK, and station
associates.  Station puts DHCP Discover on the air (using 20Mhz according
to wireshark).  AP reads this, and thinks it is sending a DHCP response back,
but sniffer never shows DHCP response on the air.

Kernel is 4.0.4+, ath10k firmware is CT firmware, 10.1.467 based.

I am curious if anyone else has tried to do this?

Thanks,
Ben

interface=vap50
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=ben-ota-2a
bssid=04:f0:21:98:d2:34
country_code=US
ieee80211d=0
ieee80211h=0
ieee80211w=0
hw_mode=a
ieee80211n=1
ieee80211ac=1
beacon_int=240
dtim_period=2
max_num_sta=2007
rts_threshold=2347
fragm_threshold=2346
preamble=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
# Enable HT modes if you want 300Mbps+ throughput.
#ht_capab=[HT20][HT40-][HT40+][GF][SHORT-GI-20][SHORT-GI-40]
#         [TX-STBC][RX-STBC123][MAX-AMSDU-7935][DSSS_CCK-40][PSMP][LSIG-TXOP-PROT]
ht_capab=[HT20][HT40+][SHORT-GI-40][SHORT-GI-20]
vht_capab=[MAX-MPDU-11454][RXLDPC][TX-STBC-2BY1][RX-STBC-1][MAX-A-MPDU-LEN-EXP0][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN]
wmm_enabled=1
wmm_ac_bk_cwmin=4
wmm_ac_bk_cwmax=10
wmm_ac_bk_aifs=7
wmm_ac_bk_txop_limit=0
wmm_ac_bk_acm=0
wmm_ac_be_aifs=3
wmm_ac_be_cwmin=4
wmm_ac_be_cwmax=10
wmm_ac_be_txop_limit=0
wmm_ac_be_acm=0
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmin=3
wmm_ac_vi_cwmax=4
wmm_ac_vi_txop_limit=94
wmm_ac_vi_acm=0
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmin=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_txop_limit=47
wmm_ac_vo_acm=0
### TX queue parameters
tx_queue_data3_aifs=7
tx_queue_data3_cwmin=15
tx_queue_data3_cwmax=1023
tx_queue_data3_burst=0
tx_queue_data2_aifs=3
tx_queue_data2_cwmin=15
tx_queue_data2_cwmax=63
tx_queue_data2_burst=0
tx_queue_data1_aifs=1
tx_queue_data1_cwmin=7
tx_queue_data1_cwmax=15
tx_queue_data1_burst=3.0
tx_queue_data0_aifs=1
tx_queue_data0_cwmin=3
tx_queue_data0_cwmax=7
tx_queue_data0_burst=1.5
vht_oper_centr_freq_seg0_idx=38
vht_oper_chwidth=0
channel=36
supported_rates=10 20 55 110 60 90 120 180 240 360 480 540
ieee8021x=0
eapol_key_index_workaround=0
eap_server=0
own_ip_addr=127.0.0.1

# Error emulation settings.
ignore_probe_probability=0.000000
ignore_auth_probability=0.000000
ignore_assoc_probability=0.000000
ignore_reassoc_probability=0.000000
corrupt_gtk_rekey_mic_probability=0.000000


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

