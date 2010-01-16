Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55928 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab0APBci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 20:32:38 -0500
Received: by pwj9 with SMTP id 9so656391pwj.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 17:32:38 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 15 Jan 2010 17:32:37 -0800
Message-ID: <fd145f7d1001151732j109b605bn9926201b5fb4b5d@mail.gmail.com>
Subject: compat 2010-01096 ath9k 2.6.30 still stops passing traffic eventually
From: Jeffrey Baker <jwbaker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I still have the same problem I've always had with ath9k: the AP stops
passing traffic after a short time.  There is never anything useful in
the logs.  Why is this?  Am I the only one?

Here is quite seriously my entire hostapd log:

Jan 15 13:49:10 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
802.11: authenticated
Jan 15 13:49:10 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
802.11: associated (aid 1)
Jan 15 13:49:10 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb RADIUS:
starting accounting session 4B50E288-00000000
Jan 15 16:45:40 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
802.11: disassociated
Jan 15 16:45:41 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
802.11: deauthenticated due to inactivity

Nothing relevant.  16:45 was when I switched to my other AP because
packets weren't being forwarded any more.  There's nothing in dmesg
either:

[    9.533427] cfg80211: World regulatory domain updated:
[    9.536872]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    9.543353]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.547313]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    9.549684]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    9.554838]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.558822]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.544221] ath: EEPROM regdomain: 0x37
[   11.544235] ath: EEPROM indicates we should expect a direct regpair map
[   11.544253] ath: Country alpha2 being used: AW
[   11.544266] ath: Regpair used: 0x37
[   11.585594] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   11.589998] Registered led device: ath9k-phy0::radio
[   11.593009] Registered led device: ath9k-phy0::assoc
[   11.596903] Registered led device: ath9k-phy0::tx
[   11.602215] Registered led device: ath9k-phy0::rx
[   11.606128] phy0: Atheros AR9280 Rev:2 mem=0xd0d00000, irq=11
[   11.611776] cfg80211: Calling CRDA for country: AW
[   12.563347] loop: module loaded
[   13.952093] Bridge firewalling registered
[   14.051828] device eth0 entered promiscuous mode
[   14.166584] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   14.206389] device wlan0 entered promiscuous mode
[   14.485841] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.510399] br0: port 1(eth0) entering learning state
[   24.524396] eth0: no IPv6 routers present
[   25.080428] br0: no IPv6 routers present
[   29.512687] br0: port 1(eth0) entering forwarding state
[   37.339576] br0: port 2(wlan0) entering disabled state
[   37.462156] br0: port 2(wlan0) entering learning state
[   47.910012] wlan0: no IPv6 routers present
[   52.466568] br0: port 2(wlan0) entering forwarding state

Is there something wrong with the bridge code in 2.6.30?  Is there a
problem bridging to Via Rhine III ethernets?  How can I debug this?
My hostapd is 0.6.9.

interface=wlan0
bridge=br0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
dump_file=/tmp/hostapd.dump
ctrl_interface_group=0
ssid=test
country_code=US
hw_mode=g
channel=11
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
auth_algs=3
ignore_broadcast_ssid=0
wme_enabled=1
wme_ac_bk_cwmin=4
wme_ac_bk_cwmax=10
wme_ac_bk_aifs=7
wme_ac_bk_txop_limit=0
wme_ac_bk_acm=0
wme_ac_be_aifs=3
wme_ac_be_cwmin=4
wme_ac_be_cwmax=10
wme_ac_be_txop_limit=0
wme_ac_be_acm=0
wme_ac_vi_aifs=2
wme_ac_vi_cwmin=3
wme_ac_vi_cwmax=4
wme_ac_vi_txop_limit=94
wme_ac_vi_acm=0
wme_ac_vo_aifs=2
wme_ac_vo_cwmin=2
wme_ac_vo_cwmax=3
wme_ac_vo_txop_limit=47
wme_ac_vo_acm=0
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40]
eapol_key_index_workaround=0
eap_server=0
own_ip_addr=127.0.0.1

Frustrated,
jwb
