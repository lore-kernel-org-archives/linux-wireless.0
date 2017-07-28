Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44362 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdG1OPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:15:20 -0400
Date: Fri, 28 Jul 2017 15:15:03 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: AP mode with Broadcom 4330
Message-ID: <20170728141503.GU31807@n2100.armlinux.org.uk> (sfid-20170728_161526_145391_3A9BDCF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been struggling yesterday and today trying to configure AP mode
with the Broadcom 4330 on a SolidRun Hummingboard2, using the 2013
firmware:

Firmware version = wl0: Jan 23 2013 17:47:32 version 5.90.195.114 FWID 01-f9e7e464

People tell me that this works with SR's 3.14 kernel, but I'd prefer
to use mainline (4.13-rc2).  Whenever I try to configure AP mode via
Network Manager or hostapd (on Debian Jessie), the SSID I ask for and
the MAC address does not appear on other wifi clients.  wlan0's
MAC is 6c:ad:f8:1d:4c:d9.

However, I have recently noticed that this pops up on clients when
AP mode is enabled:

BSS 00:10:18:f1:f2:f3(on wlan0)
        TSF: 80810271 usec (0d, 00:01:20)
        freq: 2412
        beacon interval: 10 TUs
        capability: ESS (0x0001)
        signal: -15.00 dBm
        last seen: 3203 ms ago
        SSID: BRCM_TEST_SSID
        Supported rates: 1.0* 2.0* 5.5* 11.0*
        DS Parameter set: channel 1
        IBSS ATIM window: 0 TUsBSS 52:0d:10:41:e9:99(on wlan0)
        TSF: 21849896478 usec (0d, 06:04:09)
        freq: 2462
        beacon interval: 100 TUs
        capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
        signal: -80.00 dBm
        last seen: 3020 ms ago
        Information elements from Probe Response frame:
        SSID: Virgin Media
        Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
        DS Parameter set: channel 11
        Country: GB     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: <no flags>
        Extended supported rates: 24.0 36.0 48.0 54.0
        HT capabilities:
                Capabilities: 0x1ad
                        RX LDPC
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        TX STBC
                        RX STBC 1-stream
                        Max AMSDU length: 3839 bytes
                        No DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT TX/RX MCS rate indexes supported: 0-15
        HT operation:
                 * primary channel: 11
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        Overlapping BSS scan params:
                 * passive dwell: 20 TUs
                 * active dwell: 10 TUs
                 * channel width trigger scan interval: 300 s
                 * scan passive total per channel: 200 TUs
                 * scan active total per channel: 20 TUs
                 * BSS width channel transition delay factor: 5
                 * OBSS Scan Activity Threshold: 0.25 %
        Extended capabilities: HT Information Exchange Supported, TFS, WNM-Sleep Mode, TIM Broadcast, BSS Transition, 6
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
        Vendor specific: OUI 00:03:7f, data: 01 01 00 00 ff 7f
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: IEEE 802.1X
                 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)

This is when using this hostapd configuration file:

interface=wlan0
driver=nl80211
ssid=Time
channel=1
hw_mode=g
wpa=2
wpa_passphrase=FooBarBazBat
wpa_pairwise=CCMP TKIP

Enabling tracing via /sys/kernel/debug/tracing/events/cfg80211/rdev_start_ap/enable
gives:

         hostapd-2213  [000] .... 15637.517729: rdev_start_ap: phy0, netdev:wlan0(3), AP settings - ssid: Time, band: 0, control freq: 2412, width: 0, cf1: 2412, cf2: 0, beacon interval: 100, dtim period: 2, hidden ssid: 0, wpa versions: 2, privacy: true, auth type: 8, inactivity timeout: 0

So the right SSID is being requested.  Enabling debug (4096+6) in the
brcmfmac driver gives:

brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_dpc Dongle reports CHIPACTIVE
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
brcmutil: data
00000000: 01 2b 00 00                                      .+..
brcmfmac: brcmf_cfg80211_get_tx_power Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=qtxpower, len=4
brcmutil: data
00000000: 7f 00 00 00                                      ....
brcmfmac: brcmf_cfg80211_get_tx_power Exit (0x7f 31)
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
brcmutil: data
00000000: 01 2b 00 00                                      .+..
brcmfmac: brcmf_cfg80211_get_tx_power Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=qtxpower, len=4
brcmutil: data
00000000: 7f 00 00 00                                      ....
brcmfmac: brcmf_cfg80211_get_tx_power Exit (0x7f 31)
brcmfmac: brcmf_cfg80211_change_iface Enter, bsscfgidx=0, type=3
brcmfmac: brcmf_cfg80211_change_iface IF Type = AP
brcmfmac: brcmf_cfg80211_change_iface Exit
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
brcmutil: data
00000000: 01 2b 00 00                                      .+..
brcmfmac: brcmf_cfg80211_get_tx_power Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=qtxpower, len=4
brcmutil: data
00000000: 7f 00 00 00                                      ....
brcmfmac: brcmf_cfg80211_get_tx_power Exit (0x7f 31)
brcmfmac: brcmf_cfg80211_del_station Enter ff:ff:ff:ff:ff:ff
brcmfmac: brcmf_fil_cmd_data_set ifidx=0, cmd=201, len=12
brcmutil: data
00000000: 02 00 00 00 ff ff ff ff ff ff e1 ec              ............
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_cfg80211_del_station Exit
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec_key, len=164
brcmutil: data
00000000: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000030: 01 00 00 00 00 d0 27 ee 00 00 00 00 c0 82 a1 ed  ......'.........
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_cfg80211_del_key Exit
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec_key, len=164
brcmutil: data
00000000: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000030: 02 00 00 00 00 d0 27 ee 00 00 00 00 c0 82 a1 ed  ......'.........
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_cfg80211_del_key Exit
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: chandef_to_chanspec chandef: control 2412 center 2412 width 0
brcmfmac: brcmf_cfg80211_start_ap ctrlchn=1, center=2412, bw=0, beacon_interval=100, dtim_period=2,
brcmfmac: brcmf_cfg80211_start_ap ssid=Tim(4), auth_type=8, inactivity_timeout=0
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_dpc Dongle reports CHIPACTIVE
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_int_get ifidx=0, cmd=46, value=0
brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mpc, len=4
brcmutil: data
00000000: 00 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_set_mpc MPC : 0
brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=arp_ol, len=4
brcmutil: data
00000000: 00 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=arpoe, len=4
brcmutil: data
00000000: 00 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_configure_arp_nd_offload successfully configured (0) ARP offload to 0x0
brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=ndoe, len=4
brcmutil: data
00000000: 00 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
brcmfmac: brcmf_configure_arp_nd_offload failed to configure (0) ND offload err = -23
brcmfmac: brcmf_cfg80211_start_ap WPA(2) IE is found
brcmfmac: brcmf_configure_wpaie Enter
brcmfmac: brcmf_configure_wpaie RSN_AKM_PSK
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wme_bss_disable, len=4
brcmutil: data
00000000: 01 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=auth, len=4
brcmutil: data
00000000: 00 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec, len=4
brcmutil: data
00000000: 46 00 00 00                                      F...
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wpa_auth, len=4
brcmutil: data
00000000: 80 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=76, value=100
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=78, value=2
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=3, value=1
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=apsta, len=4
brcmutil: data
00000000: 00 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=20, value=1
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mbss, len=4
brcmutil: data
00000000: 01 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=118, value=1
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=chanspec, len=4
brcmutil: data
00000000: 01 2b 00 00                                      .+..
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=2, value=1
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_cmd_data_set ifidx=0, cmd=26, len=52
brcmutil: data
00000000: 04 00 00 00 54 69 6d 65 00 00 00 00 00 00 00 00  ....Time........
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000030: 00 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_cfg80211_start_ap AP mode configuration complete
brcmfmac: brcmf_vif_set_mgmt_ie bsscfgidx 0, pktflag : 0x01
brcmfmac: brcmf_config_ap_mgmt_ie Applied Vndr IEs for Beacon
brcmfmac: brcmf_vif_set_mgmt_ie bsscfgidx 0, pktflag : 0x02
brcmfmac: brcmf_config_ap_mgmt_ie Applied Vndr IEs for Probe Resp[15330.653223] brcmfmac: brcmf_net_setcarrier Enter, bsscfgidx=0 carrier=1
brcmfmac: brcmf_txflowblock_if enter: bsscfgidx=0 stop=0x4 reason=4 state=0
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_cfg80211_add_key Enter
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec_key, len=164
brcmutil: data
00000000: ...
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=wsec, len=4
brcmutil: data
00000000: 46 00 00 00                                      F...
brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec, len=4
brcmutil: data
00000000: 46 00 00 00                                      F...
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
00000000: 46 00 00 00                                      F...
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_cfg80211_add_key Exit
brcmfmac: brcmf_cfg80211_config_default_key Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_tx_ctrlframe Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_dpc Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdio_read_control Enter
brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=wsec, len=4
brcmutil: data
00000000: 46 00 00 00                                      F...
brcmfmac: brcmf_cfg80211_config_default_key Exit

The SSID appears to be set by "brcmf_fil_cmd_data_set ifidx=0, cmd=26,
len=52" but seems to be ignored by the firmware.

The BRCM_TEST_SSID and mac address 00:10:18:f1:f2:f3 can be found in
the SDIO firmware .bin file:

0001acf0  34 01 04 00 01 00 00 0e  34 01 04 00 42 52 43 4d  |4.......4...BRCM|
                                                                         ^^^^
0001ad00  34 01 04 00 5f 54 45 53  34 01 04 00 54 5f 53 53  |4..._TES4...T_SS|
                                                                 ^^^^    ^^^^
0001ad10  34 01 04 00 49 44 01 04  34 01 04 00 82 84 8b 96  |4...ID..4.......|
                                                                 ^^
0001ad50  34 01 04 00 ff ff ff ff  34 01 04 00 00 10 18 f1  |4.......4.......|
                                               ^^^^^^^^^^^
0001ad60  34 01 04 00 f2 f3 00 10  34 01 04 00 18 f1 f2 f3  |4.......4.......|
                      ^^^^^|^^^^^              ^^^^^^^^^^^

so this BRCM_TEST_SSID with mac address 00:10:18:f1:f2:f3 is definitely
coming from the 4330.  Given that it goes away if I down the interface
and comes back when I reconfigure AP mode, this all points towards a
firmware/driver incompatibility and a regression compared to 3.14
kernels, which work with the exact same firmware.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
