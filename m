Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47306 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1BGUEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 15:04:24 -0500
Message-ID: <4D50503E.4090007@candelatech.com>
Date: Mon, 07 Feb 2011 12:04:14 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org> <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org> <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com> <4D4F0D83.4040401@candelatech.com> <4D4F0DFF.9010703@openwrt.org> <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com> <4D5033DE.4070701@candelatech.com> <AANLkTimzp3nL=vbxnhH2ZYZtGNFqMsKKqTw1+pfjkUMu@mail.gmail.com>
In-Reply-To: <AANLkTimzp3nL=vbxnhH2ZYZtGNFqMsKKqTw1+pfjkUMu@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2011 10:32 AM, Daniel Halperin wrote:
> Start on 2.4 GHz AP with HT Only (not just HT40) set.  That is, AP
> that doesn't allow 1 Mbps packets to be sent.  Scan, make sure 1 mbps
> packets are sent.

I configured my AP with the conf file below.  Radio is configured
for HT20.  Is that what you mean??

On channel 3 (off-channel), probe request is sent at 1Mbps
On channel 8 (on-channel), probe request (and deauth) is sent at 1Mbps.


[root@lec-2010p-ath9k-3x3 wifi]# cat /debug/ieee80211/wiphy0/ath9k/wiphy
wiphy0 (chan=8  center-freq: 2447 MHz  channel-type: 1 (ht20))
addr: 00:15:6d:84:65:0b
addrmask: ff:ea:a1:3f:12:f5
rfilt: 0x597 UCAST MCAST BCAST BEACON PROBEREQ PHYERR COMP_BAR


interface=vap0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
dump_file=/home/lanforge/wifi/hostapd_vap0.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=vap-3x3
bssid=00:00:33:44:88:01
country_code=US
ieee80211d=0
hw_mode=g
ieee80211n=1
channel=8
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
#ht_capab=[HT20][HT40-][SHORT-GI-40]
#ht_capab=[HT20][HT40+][SHORT-GI-40]
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
wpa_passphrase=vap-3x3-passwd


>
> Start on 5 GHZ AP with HT Only set.  Scan.  What rate are probes sent
> at for 2.4 GHz?

(Using slightly different hostapd.conf config file, of course)

On 5Ghz channels, they are sent at 6Mbps
On channel 3 (2.4Ghz), they are sent at 1Mbps


That seem right?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

