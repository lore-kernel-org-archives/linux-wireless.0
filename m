Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:37814 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbYCWLeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 07:34:25 -0400
Received: from [192.168.2.253] (Bas.steadydecline.net [192.168.2.253])
	by steady.steadydecline.net (8.14.2/8.14.2) with ESMTP id m2NBRfjA011836
	for <linux-wireless@vger.kernel.org>; Sun, 23 Mar 2008 12:27:42 +0100
Subject: hostapd with mac80211 and rt2500pci: hostapd doesn't receive
	clients EAPOL keys unless mon.wlan1 is promiscuous
From: Bas Hulsken <bhulsken@hotmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 23 Mar 2008 12:24:18 +0100
Message-Id: <1206271458.2902.27.camel@Bas> (sfid-20080323_113430_380950_98BCE00E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi List,

I'm trying to get my rt2500pci running as an accesspoint. So far with
only very limited success. I'm running the most recent stuff from
git.wireless-testing (mac80211-v2.6.25_rc5_2623_g7556b76_080322-1). I've
applied these patches from Johannes Berg:
006-mac80211-sparse-check-endianness-by-default.patch
008-allow-ap-vlan-modes.patch
009-mac80211-allow-wds.patch

I've tried running hostapd-0.6.2 (patched for nl80211) up to 0.6.4, all
with the same results.

This is the problem, as far as I understand it:

hostapd doesn't receive the EAPOL key from the laptop that is trying to
connect (thinkpad x61s, 00:1b:77:a4:db:26. I've tried connecting from
both fedora8, and windows Vista). While ethereal shows that EAPOL keys
are being sent by the thinkpad. This is what hostapd lists: 
wlan1: STA 00:1b:77:a4:db:26 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=1 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
wlan1: STA 00:1b:77:a4:db:26 WPA: EAPOL-Key timeout
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKSTART
wlan1: STA 00:1b:77:a4:db:26 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=1 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
wlan1: STA 00:1b:77:a4:db:26 WPA: EAPOL-Key timeout

repeated quite a few times, before the thinkpad gives up trying to
associate.

However, if I switch mon.wlan1 on the hostapd accesspoint to
promiscuous, by issuing tethereal -i mon.wlan1, then suddenly hostapd
does receive the EAPOL key from the think pad, and this happens (hostapd
output):

wlan1: STA 00:1b:77:a4:db:26 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=1 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 123 bytes from 00:1b:77:a4:db:26
   IEEE 802.1X: version=1 type=3 length=119
wlan1: STA 00:1b:77:a4:db:26 WPA: received EAPOL-Key frame (2/4
Pairwise)
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:0c:f6:14:05:19 A2=00:1b:77:a4:db:26
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKINITNEGOTIATING

so, now hostapd does receive a keyframe from the thinkpad. Unfortunately
hostapd hangs after "WPA_PTK entering state PTKINITNEGOTIATING", and can
only be terminated with a ctrl-c. In the past (one month ago, hostapd
would continue, and it was actually possible to connect the thinkpad to
hostapd, however I could never connect without making either mon.wlan1
or wlan1 promiscuous by running ethereal on it, and even then I'd get
some kernel OOPSES on heavy traffic). This is the tethereal -i mon.wlan1
output (thinkpad=IntelCor_a4:db:26, hostapd=SitecomE_14:05:19):

 17.034743 SitecomE_14:05:19 -> IntelCor_a4:db:26 EAPOL Key
 17.034747 SitecomE_14:05:19 -> IntelCor_a4:db:26 EAPOL Key
 17.051720 IntelCor_a4:db:26 -> SitecomE_14:05:19 EAPOL Key
 27.050899 IntelCor_a4:db:26 -> SitecomE_14:05:19 IEEE 802.11
Disassociate, SN=3012, FN=0, Flags=........
 27.051921 IntelCor_a4:db:26 -> SitecomE_14:05:19 IEEE 802.11
Disassociate, SN=3012, FN=0, Flags=....R...
 27.080414 IntelCor_a4:db:26 -> SitecomE_14:05:19 IEEE 802.11 Null
function (No data), SN=3013, FN=0, Flags=...P...T
 27.264342 IntelCor_a4:db:26 -> SitecomE_14:05:19 IEEE 802.11 Null
function (No data), SN=3014, FN=0, Flags=.......T
 27.265133 IntelCor_a4:db:26 -> SitecomE_14:05:19 IEEE 802.11 QoS Null
function (No data), SN=3014, FN=0, Flags=....R..T

The QoS and Null function stuff continues more or less forever.

Ok, to summarize: hostapd doesn't seem to work at the moment with
rt2500pci and lates git.wireless-testing. The cause seems to be that
EOPOL key send from the client does not arrive at hostapd. This can be
'fixed' by running tethereal on the monitor interface. Any thoughts on
what might cause this?

thanks for your time!
best regards,
Bas Hulsken

some additional info:
--------------------------------------------------------------
hostapd.conf:
--------------------------------------------------------------
interface=wlan1
driver=nl80211
logger_syslog=-1
logger_syslog_level=0
logger_stdout=-1
logger_stdout_level=0
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=steadydecline
country_code=NL
hw_mode=g
channel=1
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
accept_mac_file=/etc/hostapd.accept
deny_mac_file=/etc/hostapd.deny
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
#ieee8021x=0
eapol_version=1
eap_message=hello
eapol_key_index_workaround=0
own_ip_addr=127.0.0.1
wpa=1
wpa_passphrase=***********
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
supported_rates=10 20 55 110
wpa_group_rekey=600
wpa_strict_rekey=1
wpa_gmk_rekey=86400
--------------------------------------------------------------
ifcfg-wlan1
--------------------------------------------------------------
# RaLink RT2500 802.11g Cardbus/mini-PCI
DEVICE=wlan1
ONBOOT=no
HWADDR=00:0c:f6:14:05:19
BROADCAST=192.168.3.255
IPADDR=192.168.3.1
NETMASK=255.255.255.0
NETWORK=192.168.3.0
IPV6INIT=no
MODE=Master
BOOTPROTO=none
TYPE=Wireless
ESSID=steadydecline
#WIRELESS_RTS=on
RATE=AUTO
MODE=AUTO
CHANNEL=1
--------------------------------------------------------------
iwconfig
--------------------------------------------------------------
wmaster0  no wireless extensions.

wlan1     IEEE 802.11  ESSID:"steadydecline"  
          Mode:Master  Frequency:2.412 GHz  Tx-Power=23 dBm   
          Retry min limit:7   RTS thr=2347 B   Fragment thr=2346 B   
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

mon.wlan1  IEEE 802.11  Mode:Monitor  Frequency:2.412 GHz  Tx-Power=23
dBm   
          Retry min limit:7   RTS thr=2347 B   Fragment thr=2346 B   
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
--------------------------------------------------------------


