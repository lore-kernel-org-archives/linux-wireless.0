Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53888 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab1JTVx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 17:53:58 -0400
Message-ID: <4EA09874.3010006@candelatech.com> (sfid-20111020_235405_293209_6774A8CC)
Date: Thu, 20 Oct 2011 14:53:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on channel 44 and HT40+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I configured hostapd for channel 44, and gave it option for HT40+
That seems to work fine:

[root@ct520-6157 ]# cat /debug/ieee80211/wiphy0/ath9k/wiphy
wiphy0 (chan=44  center-freq: 5220 MHz  channel-type: 3 (ht40+))
addr: 00:0e:8e:32:12:cf
addrmask: ff:79:e8:45:74:31
rfilt: 0x4497 UCAST MCAST BCAST BEACON PROBEREQ COMP_BAR PSPOLL
[root@ct520-6157 ]#


However, the clients will not use HT40 because this check from the kernel's
mlme.c fails:

			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
				if (!(local->hw.conf.channel->flags &
				    IEEE80211_CHAN_NO_HT40PLUS))
					channel_type = NL80211_CHAN_HT40PLUS;

Both systems are ath9k on 3.0.6+ (+ my standard set of hacks).

Both systems are using US country code.

Client-side:
03:00.0 Network controller: Atheros Communications Inc. AR9160 802.11abgn Wireless PCI Adapter (rev 01)

AP:
03:00.0 Network controller: Atheros Communications Inc. AR9300 Wireless LAN adaptor (rev 01)


So, the question is:  Is this *supposed* to work?  The hostapd conf file seems
to indicate that HT40+ is valid on channel 44...


The hostapd config file is here:

interface=vap0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
dump_file=/home/lanforge/wifi/hostapd_vap0.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=test123
bssid=00:88:99:88:99:01
country_code=US
ieee80211d=0
hw_mode=a
ieee80211n=1
channel=44
beacon_int=240
dtim_period=2
max_num_sta=2007
rts_threshold=2347
fragm_threshold=2346
preamble=0
macaddr_acl=0
auth_algs=3
ignore_broadcast_ssid=0
# Enable HT modes if you want 300Mbps+ throughput.
#ht_capab=[HT20][HT40-][HT40+][GF][SHORT-GI-20][SHORT-GI-40]
#         [TX-STBC][RX-STBC123][MAX-AMSDU-7935][DSSS_CCK-40][PSMP][LSIG-TXOP-PROT]
ht_capab=[HT20][HT40+][HT40-][SHORT-GI-40]
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
ieee8021x=0
eapol_key_index_workaround=0
eap_server=0
own_ip_addr=127.0.0.1
wpa=1
wpa_pairwise=TKIP CCMP
wpa_passphrase=test1234


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

