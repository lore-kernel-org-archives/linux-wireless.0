Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403FDC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 18:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1CD920817
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 18:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1CD920817
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=i2se.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbeK0FJG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Nov 2018 00:09:06 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:33281 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725723AbeK0FJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Nov 2018 00:09:06 -0500
Received: from oxbaltgw35.schlund.de ([172.19.246.43]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MYvse-1fwYxh1cOG-00Uvc5; Mon, 26 Nov 2018 19:14:05 +0100
Date:   Mon, 26 Nov 2018 19:14:05 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Message-ID: <1820979779.200101.1543256045155@email.ionos.de>
In-Reply-To: <978d5d47-004e-21a9-0c53-2eb1571a5138@broadcom.com>
References: <142675996.139583.1543082320719@email.ionos.de>
 <ab765dfac2c4a19d820677c5c05a5566@milecki.pl>
 <355192050.233466.1543151650720@email.ionos.de>
 <978d5d47-004e-21a9-0c53-2eb1571a5138@broadcom.com>
Subject: Re: brcmfmac: regression using AP mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev46
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:6n6MeNGpGdu72N6I1sVGg1NpR0GTlMkF+eY1jghvjSoKM6z5a8p
 s2n/m43c+GcJBt7p0cMEG8sAaz6nrS8rFSJK//nKP27Mx3LYULPgINWGOJbdc7+LpKzIBes
 BJXiJpfDl/069MKJi9z1BVRWNkUYopqwPRymsTNTHqNJOUpb6c3ThG4rL9rS4F6YSpxblyQ
 YymaOCYCq0TCijUxLKTkg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9AzOBYjoHNc=:4Y7Vksv9JBmMjL5+CzjpnY
 Fkuz2/7Jf2gggD96G2hc51coonCNNl941SOY8aRnVyXwAAiQe6yVa0xmBfK9H53N20cXynpvs
 qunFowOEKPpMaj/z4k2fv/jlDU+K8JdsNx/6mkv/pCR1bJfddWoPIwWdzdrn2xsILQqpeRSFt
 DYLFkvmJVUE4oJZe5jNn/Kw54mstLrz7IosilzuiQxI2cJIQaNstgAdyRL3qOVbIEHJX1LCCl
 2Wv+Xk4pFkgeGrzPbOmh+ZaWZjBKxYt/MUYe6nqrLbXCBuiXU6kOOwIsDENvHAGI7q2KKcWiF
 oGoJJUwLVfHctN2QhlAQMjOzaDlOgcu2go9MBroaE16l3HkDRNVxHOK4Dg/vDIictOV1b0eiN
 JkB5Y87EXk5P4prZR56ciUdeNJD6d8Ow3MV328MZR/mnji0Z4yYlnXYTm1AKS2T/2y2ZDt4o9
 CWP+8wlH1BwNkQIGahYJdA1oO1x/sBL5YBc8k2beYebBy+5bT/D3b/CdCp6eKZDHG9YhpxLa2
 QZZDjCmvmBL4DjU+n0uMmlFRVnYA48R+JqAp4z7pqX3ZMhCTDGuTlRgkkGIR4uEb8r/YTijAJ
 ZDZbOu0Bxok2IkOIFohwdpbTf7NWZ032SY7iyOKRzViPEPA5l3cztvpQtrkLBwpuiRzp1eCdk
 uMmWPlLUk90oDwthj++8bA/ryKLgkO1VH/h5x5T9mT2DtGPwjyHWDlmrVj/IM5RDdDaNqanLx
 xfXHtrFtssEZOUjiLtBgEc8AtsZE+h18sQGnYRw8qTY63IYrsp02q/Gpg8uwMTjYgLxcqHRli
 M3YcLKTAKHiMttXixzSyjOEcOGzBg==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

> Arend van Spriel <arend.vanspriel@broadcom.com> hat am 26. November 2018 um 11:11 geschrieben:
> 
> So no AP listed here. I suspect Rafał was focusing on "device_ap_sme=1 
> use_monitor=1" scenario. You can try adding AP entry with similar rx 
> bits as P2P_GO above.

thanks this make all driver errors like "setting AP mode failed -52" disappear, but now hostapd 2.6 seems to stuck in a loop during establishing the link:

random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd/hostapd-5GHz.conf
nl80211: Using driver-based roaming
nl80211: TDLS supported
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:6
nl80211: Using driver-based off-channel TX
nl80211: Supported vendor command: vendor_id=0x1018 subcmd=1
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Enable multi-channel concurrent (driver advertised support)
nl80211: use P2P_DEVICE support
nl80211: interface wlan0 in phy phy0
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Setup AP(wlan0) - device_ap_sme=1 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x589348 (device SME)
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=04
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=0501
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=0504
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=06
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=08
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=0a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=11
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x589348 match=7f
nl80211: Enable Probe Request reporting nl_preq=0x5891d8
nl80211: Register frame type=0x40 (WLAN_FC_STYPE_PROBE_REQ) nl_handle=0x5891d8 match=
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Add own interface ifindex 3 (ifidx_reason -1)
nl80211: if_indices[16]: 3(-1)
phy: phy0
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=DE (DFS-ETSI)
nl80211: 2400-2483 @ 40 MHz 20 mBm
nl80211: 5150-5250 @ 80 MHz 20 mBm (no outdoor)
nl80211: 5250-5350 @ 80 MHz 20 mBm (no outdoor) (DFS)
nl80211: 5470-5725 @ 160 MHz 26 mBm (DFS)
nl80211: 5725-5875 @ 80 MHz 13 mBm
nl80211: 57000-66000 @ 2160 MHz 40 mBm
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=13 freq=2472 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=34 freq=5170 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=36 freq=5180 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=38 freq=5190 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=40 freq=5200 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=42 freq=5210 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=44 freq=5220 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=46 freq=5230 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=48 freq=5240 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=149 freq=5745 MHz max_tx_power=13 dBm
Allowed channel: mode=2 chan=153 freq=5765 MHz max_tx_power=13 dBm
Allowed channel: mode=2 chan=157 freq=5785 MHz max_tx_power=13 dBm
Allowed channel: mode=2 chan=161 freq=5805 MHz max_tx_power=13 dBm
Allowed channel: mode=2 chan=165 freq=5825 MHz max_tx_power=13 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=13 freq=2472 MHz max_tx_power=20 dBm
Completing interface initialization
Mode: IEEE 802.11a  Channel: 36  Frequency: 5180 MHz
DFS 0 channels required radar detection
nl80211: Set freq 5180 (ht_enabled=0, vht_enabled=0, bandwidth=20 MHz, cf1=5180 MHz, cf2=0 MHz)
  * freq=5180
  * vht_enabled=0
  * ht_enabled=0
  * channel_type=0
RATE[0] rate=60 flags=0x1
RATE[1] rate=90 flags=0x0
RATE[2] rate=120 flags=0x1
RATE[3] rate=180 flags=0x0
RATE[4] rate=240 flags=0x1
RATE[5] rate=360 flags=0x0
RATE[6] rate=480 flags=0x0
RATE[7] rate=540 flags=0x0
hostapd_setup_bss(hapd=0x58a8a8 (wlan0), first=1)
wlan0: Flushing old station entries
nl80211: flush -> DEL_STATION wlan0 (all)
nl80211: Station flush failed: ret=-14 (Bad address)
wlan0: Could not connect to kernel driver
wlan0: Deauthenticate all stations
nl80211: sta_remove -> DEL_STATION wlan0 ff:ff:ff:ff:ff:ff --> 0 (Success)
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-22 Invalid argument)
Failed to clear default encryption keys (ifname=wlan0 keyidx=0)
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-22 Invalid argument)
Failed to clear default encryption keys (ifname=wlan0 keyidx=2)
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-22 Invalid argument)
Failed to clear default encryption keys (ifname=wlan0 keyidx=3)
Using interface wlan0 with hwaddr b8:27:eb:6c:5e:c9 and ssid "rpi3aplus"
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=9):
     72 70 69 33 61 70 6c 75 73                        rpi3aplus       
PSK (ASCII passphrase) - hexdump_ascii(len=12): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
random: Got 20/20 bytes from /dev/random
Get randomness: len=32 entropy=0
GMK - hexdump(len=32): [REMOVED]
Get randomness: len=32 entropy=0
Key Counter - hexdump(len=32): [REMOVED]
WPA: Delay group state machine start until Beacon frames have been configured
nl80211: Set beacon (beacon_set=0)
nl80211: Beacon head - hexdump(len=60): 80 00 00 00 ff ff ff ff ff ff b8 27 eb 6c 5e c9 b8 27 eb 6c 5e c9 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 09 72 70 69 33 61 70 6c 75 73 01 08 8c 12 98 24 b0 48 60 6c 03 01 24
nl80211: Beacon tail - hexdump(len=28): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 7f 04 00 00 00 02
nl80211: ifindex=3
nl80211: beacon_int=100
nl80211: dtim_period=2
nl80211: ssid - hexdump_ascii(len=9):
     72 70 69 33 61 70 6c 75 73                        rpi3aplus       
  * beacon_int=100
  * dtim_period=2
nl80211: hidden SSID not in use
nl80211: privacy=1
nl80211: auth_algs=0x1
nl80211: wpa_version=0x2
nl80211: key_mgmt_suites=0x2
nl80211: pairwise_ciphers=0x10
nl80211: group_cipher=0x10
nl80211: beacon_ies - hexdump(len=6): 7f 04 00 00 00 02
nl80211: proberesp_ies - hexdump(len=6): 7f 04 00 00 00 02
nl80211: assocresp_ies - hexdump(len=6): 7f 04 00 00 00 02
WPA: Start group state machine to set initial keys
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
Get randomness: len=16 entropy=0
GTK - hexdump(len=16): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=3 addr=0x5397a4 key_idx=1 set_tx=1 seq_len=0 key_len=16
nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
   broadcast key
nl80211: Set wlan0 operstate 0->1 (UP)
netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=6 (IF_OPER_UP)
Failed to set TX queue parameters for queue 0.
Failed to set TX queue parameters for queue 1.
Failed to set TX queue parameters for queue 2.
Failed to set TX queue parameters for queue 3.
wlan0: interface state UNINITIALIZED->ENABLED
wlan0: AP-ENABLED 
wlan0: Setup of interface done.
ctrl_iface not configured!
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=2 linkmode=0 ifi_family=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=6 linkmode=0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=6 linkmode=0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: RTM_NEWLINK: ifi_index=3 ifname=wlan0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: vlan_newlink(wlan0)
VLAN: RTM_NEWLINK: ifi_index=3 ifname=wlan0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: vlan_newlink(wlan0)
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=5 linkmode=0 ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
nl80211: Set IF_OPER_UP again based on ifi_flags and expected operstate
netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=6 (IF_OPER_UP)
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=6 linkmode=0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: RTM_NEWLINK: ifi_index=3 ifname=wlan0 ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
VLAN: vlan_newlink(wlan0)
VLAN: RTM_NEWLINK: ifi_index=3 ifname=wlan0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: vlan_newlink(wlan0)
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=6 linkmode=0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: RTM_NEWLINK: ifi_index=3 ifname=wlan0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: vlan_newlink(wlan0)
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=5 linkmode=0 ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
nl80211: Set IF_OPER_UP again based on ifi_flags and expected operstate
netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=6 (IF_OPER_UP)
RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=6 linkmode=0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: RTM_NEWLINK: ifi_index=3 ifname=wlan0 ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
VLAN: vlan_newlink(wlan0)
VLAN: RTM_NEWLINK: ifi_index=3 ifname=wlan0 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
VLAN: vlan_newlink(wlan0)
