Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33429 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754051AbcJONR3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Oct 2016 09:17:29 -0400
Received: by mail-lf0-f50.google.com with SMTP id x79so222222240lff.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2016 06:17:28 -0700 (PDT)
Subject: Re: BCM43602 firmware reports multiple BRCMF_E_DEAUTH
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
References: <CACna6rzS4nDZ+H5kU71WwTTNLp5uZStpQHv4LLmWBDSdf5jpyw@mail.gmail.com>
 <f97678dc-2869-1b6a-33a3-f829cc30918a@gmail.com>
 <90e69e94-2210-22ec-3aec-67d9605b4b7c@broadcom.com>
 <b395146e-1917-e8d7-04e6-5d544f17531e@gmail.com>
 <CAF7Mx6ocYn21OkP7Tv7tMcuP_LLUQa-oPZigKzQWE1S4q9v=VA@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <5f6563f2-6038-2036-27c9-5811b90df2f1@gmail.com> (sfid-20161015_151736_376648_4F436D2D)
Date: Sat, 15 Oct 2016 15:17:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6ocYn21OkP7Tv7tMcuP_LLUQa-oPZigKzQWE1S4q9v=VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2016 12:13 PM, Arend Van Spriel wrote:
> Ok. Did you also try the firmware I sent you?

Hey again. Since you asked in public, I hope you don't mind me answering so.

So I tested experimental firmware I got from Arend (thank you!). It seems to
behave slightly differently but I still observe timeouts in
brcmf_netdev_wait_pend8021x.

Please note I modified brcmfmac to call brcmf_netdev_wait_pend8021x
continuously. This way it's not a matter of when send_key_to_dongle gets called.

I'll attach log of 11 cases where I saw wlc_ampdu_watchdog kicking in or just
a warning from brcmf_netdev_wait_pend8021x.

1st case: timeouts started occuring 16 seconds after wlc_ampdu_watchdog
2nd case: wlc_ampdu_tx_send_delba + timeout but without wlc_ampdu_watchdog
3rd case: timeouts 6 seconds after wlc_ampdu_watchdog
4th case: wlc_ampdu_watchdog without any timeout!
5th case: just one timeout
6th case: timeout between 2 wlc_ampdu_tx_send_delba + without any wlc_ampdu_watchdog
7th case: no timeout in brcmf_netdev_wait_pend8021x at all
8th case: it seems I can now see timeouts also before wlc_ampdu_watchdog + ampdu_dbg
9th case: similar to above
10th case: just 1 timeout *before* wlc_ampdu_watchdog + ampdu_dbg
11th case: wlc_ampdu_watchdog + ampdu_dbg without timeout at all

It's hard for me to say if it's much better. In some cases I didn't get timeouts
in brcmf_netdev_wait_pend8021x at all which is nice. In other ones timeouts were
occuring *before* wlc_ampdu_watchdog or *after* with some extra delay.

So something has changed, but some problem seems to remain.

#1
Sat Oct 15 10:40:34 2016 kern.debug kernel: [ 3444.338326] brcmfmac: CONSOLE: 030176.154 wl0: wlc_ampdu_resp_timeout: cleaning up resp tid 0 waiting forseq 0x6a8 for 1000 ms
Sat Oct 15 10:40:35 2016 kern.debug kernel: [ 3445.437653] brcmfmac: CONSOLE: 030177.254 wl0: wlc_ampdu_resp_timeout: cleaning up resp tid 0 waiting forseq 0x6af for 1000 ms
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659505] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: wl0.2 scb:0034946c tid:0
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659628] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659684] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109728
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659726] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659792] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: txall 1 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659860] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 14 0 0 0 0 ifs_boff 0
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659909] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.659960] brcmfmac: CONSOLE: 030178.476 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.660051] brcmfmac: CONSOLE: 030178.476 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 10:40:36 2016 kern.debug kernel: [ 3446.660113] brcmfmac: CONSOLE: 030178.476 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 10:40:39 2016 kern.debug kernel: [ 3449.657853] brcmfmac: CONSOLE: 030181.476 wl0: wlc_ampdu_watchdog: cleaning up tid 0 from poff
Sat Oct 15 10:40:54 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 10:40:55 2016 kern.err kernel: [ 3465.498648] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:40:56 2016 kern.err kernel: [ 3466.458647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:40:57 2016 kern.err kernel: [ 3467.409203] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:40:58 2016 kern.err kernel: [ 3468.368645] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:40:59 2016 kern.err kernel: [ 3469.319204] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:41:00 2016 kern.err kernel: [ 3470.278645] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:41:01 2016 kern.err kernel: [ 3471.229204] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:41:02 2016 kern.err kernel: [ 3472.188647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:41:03 2016 kern.err kernel: [ 3473.139229] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 10:41:03 2016 kern.debug kernel: [ 3473.657094] brcmfmac: CONSOLE: 030205.478 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 10:41:03 2016 kern.err kernel: [ 3473.657142] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 10:41:03 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#2
Sat Oct 15 11:36:56 2016 kern.debug kernel: [ 6826.183551] brcmfmac: CONSOLE: 033560.307 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 11:36:57 2016 kern.err kernel: [ 6827.368648] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:36:58 2016 kern.err kernel: [ 6828.328646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:36:59 2016 kern.err kernel: [ 6829.288646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:36:59 2016 kern.debug kernel: [ 6829.914889] brcmfmac: CONSOLE: 033564.041 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 11:36:59 2016 kern.err kernel: [ 6829.914961] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 11:36:59 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:36:59 2016 kern.err kernel: [ 6829.915141] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:36:59 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:36:59 2016 kern.err kernel: [ 6829.928441] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:36:59 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.095039] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.098203] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.311874] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.322031] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.324444] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.532318] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.547082] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.668501] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:00 2016 kern.err kernel: [ 6830.668911] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:00 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.123344] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.123725] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.124429] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.124724] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.125274] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.183095] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.183719] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.184148] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.184548] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.185028] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.185436] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.186032] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.186372] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.186842] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.187222] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.187749] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.188173] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.188523] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.188916] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.189432] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.189782] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.193480] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.193534] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.193558] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 11:37:01 2016 kern.err kernel: [ 6831.193580] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 11:37:01 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#3
Sat Oct 15 11:48:12 2016 kern.debug kernel: [ 7502.517302] brcmfmac: CONSOLE: 034236.934 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 11:48:13 2016 kern.debug kernel: [ 7503.866098] brcmfmac: CONSOLE: 034238.285 wl0: wlc_ampdu_resp_timeout: cleaning up resp tid 0 waiting forseq 0xd84 for 1000 ms
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528279] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: wl0.2 scb:00346afc tid:0
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528404] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528460] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109640
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528503] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528569] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: txall 5 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528699] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 14 0 0 0 0 ifs_boff 0
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528752] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528802] brcmfmac: CONSOLE: 034243.949 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528893] brcmfmac: CONSOLE: 034243.949 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 11:48:19 2016 kern.debug kernel: [ 7509.528955] brcmfmac: CONSOLE: 034243.949 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 11:48:25 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 11:48:25 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 11:48:25 2016 kern.err kernel: [ 7516.038647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:26 2016 kern.err kernel: [ 7516.998666] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:27 2016 kern.err kernel: [ 7517.949204] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:28 2016 kern.err kernel: [ 7518.908647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:29 2016 kern.err kernel: [ 7519.868646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:30 2016 kern.err kernel: [ 7520.828649] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:31 2016 kern.err kernel: [ 7521.788645] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:32 2016 kern.err kernel: [ 7522.748646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:33 2016 kern.err kernel: [ 7523.699209] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 11:48:34 2016 kern.debug kernel: [ 7524.545280] brcmfmac: CONSOLE: 034258.961 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 11:48:34 2016 kern.err kernel: [ 7524.545327] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 11:48:34 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#4
Sat Oct 15 11:53:42 2016 kern.debug kernel: [ 7832.709896] brcmfmac: CONSOLE: 034567.239 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 11:53:43 2016 kern.debug kernel: [ 7833.155136] brcmfmac: CONSOLE: 034567.686 wl0: wlc_ampdu_resp_timeout: cleaning up resp tid 0 waiting forseq 0xe6e for 1000 ms
Sat Oct 15 11:53:55 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.724898] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: wl0.2 scb:0034946c tid:0
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725022] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725078] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109071
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725120] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725187] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: txall 28 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725254] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 2 0 2 0 0 ifs_boff 0
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725304] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725356] brcmfmac: CONSOLE: 034580.251 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725447] brcmfmac: CONSOLE: 034580.251 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 11:53:55 2016 kern.debug kernel: [ 7845.725510] brcmfmac: CONSOLE: 034580.251 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 11:53:55 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 11:53:58 2016 kern.debug kernel: [ 7848.754986] brcmfmac: CONSOLE: 034583.290 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 11:53:58 2016 kern.err kernel: [ 7848.755041] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 11:53:58 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#5
Sat Oct 15 12:01:24 2016 kern.debug kernel: [ 8294.512509] brcmfmac: CONSOLE: 035029.214 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:01:25 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 12:01:26 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 12:01:27 2016 kern.debug kernel: [ 8297.522873] brcmfmac: CONSOLE: 035032.228 wl0: wlc_ampdu_resp_timeout: cleaning up resp tid 0 waiting forseq 0xcd8 for 1000 ms
Sat Oct 15 12:01:27 2016 kern.err kernel: [ 8297.809204] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:01:28 2016 kern.err kernel: [ 8298.759205] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:01:29 2016 kern.err kernel: [ 8299.709203] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709455] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: wl0.2 scb:00346afc tid:0
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709575] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709632] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109600
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709676] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709742] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: txall 8 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709810] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 12 0 0 0 0 ifs_boff 0
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709860] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.709911] brcmfmac: CONSOLE: 035034.226 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.710002] brcmfmac: CONSOLE: 035034.226 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 12:01:29 2016 kern.debug kernel: [ 8299.710063] brcmfmac: CONSOLE: 035034.226 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:01:30 2016 kern.err kernel: [ 8300.668646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:01:30 2016 kern.err kernel: [ 8300.845503] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 12:01:30 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:01:30 2016 kern.err kernel: [ 8300.846117] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:01:30 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:01:30 2016 kern.err kernel: [ 8300.846234] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:01:30 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:01:30 2016 kern.err kernel: [ 8300.846848] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:01:30 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:01:30 2016 kern.debug kernel: [ 8300.845457] brcmfmac: CONSOLE: 035035.551 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 12:01:30 2016 kern.err kernel: [ 8300.847118] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:01:30 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:01:30 2016 kern.err kernel: [ 8300.876364] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:01:30 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#6
Sat Oct 15 12:08:54 2016 kern.debug kernel: [ 8744.163589] brcmfmac: CONSOLE: 035479.101 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:08:55 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 12:08:55 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 12:08:57 2016 kern.err kernel: [ 8747.968646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:08:57 2016 kern.debug kernel: [ 8747.968977] brcmfmac: CONSOLE: 035482.107 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:08:59 2016 kern.debug kernel: [ 8749.033058] brcmfmac: CONSOLE: 035483.975 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 12:08:59 2016 kern.err kernel: [ 8749.033112] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 12:08:59 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.785827] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.786446] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.787826] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.788462] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.832697] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.832956] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.833657] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.833711] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.834027] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.834453] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.834591] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.835375] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.835583] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.836126] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.836518] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.836889] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.837295] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.837686] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.838107] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.838513] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.838884] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.839350] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.839733] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Sat Oct 15 12:09:02 2016 kern.err kernel: [ 8752.840185] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 7
Sat Oct 15 12:09:02 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#7
Sat Oct 15 12:11:20 2016 kern.debug kernel: [ 8890.348071] brcmfmac: CONSOLE: 035625.342 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:11:21 2016 kern.debug kernel: [ 8891.391863] brcmfmac: CONSOLE: 035626.393 wl0: wlc_ampdu_resp_timeout: cleaning up resp tid 0 waiting forseq 0xeba for 1000 ms
Sat Oct 15 12:11:25 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 12:11:26 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 12:11:29 2016 kern.debug kernel: [ 8899.083518] brcmfmac: CONSOLE: 035634.087 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 12:11:29 2016 kern.err kernel: [ 8899.083568] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 12:11:29 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#8
Sat Oct 15 12:22:25 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 12:22:25 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 12:22:27 2016 kern.err kernel: [ 9557.228645] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:28 2016 kern.err kernel: [ 9558.188646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451027] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: wl0.2 scb:0034777c tid:0
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451150] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451206] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109206
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451249] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451317] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: txall 33 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451383] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 4 0 0 0 0 ifs_boff 0
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451433] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451484] brcmfmac: CONSOLE: 036293.506 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451575] brcmfmac: CONSOLE: 036293.506 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 12:22:28 2016 kern.debug kernel: [ 9558.451636] brcmfmac: CONSOLE: 036293.506 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:22:29 2016 kern.err kernel: [ 9559.148655] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:30 2016 kern.err kernel: [ 9560.108648] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:31 2016 kern.err kernel: [ 9561.068647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:31 2016 kern.debug kernel: [ 9561.253087] brcmfmac: CONSOLE: 036296.512 wl0: wlc_ampdu_watchdog: cleaning up tid 0 from poff
Sat Oct 15 12:22:32 2016 kern.err kernel: [ 9562.028646] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:32 2016 kern.err kernel: [ 9562.988647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:33 2016 kern.debug kernel: [ 9563.258653] brcmfmac: CONSOLE: 036298.516 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 12:22:33 2016 kern.err kernel: [ 9563.258699] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 12:22:33 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#9
Sat Oct 15 12:22:55 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 12:22:56 2016 kern.err kernel: [ 9586.728647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:22:57 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.280576] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: wl0.2 scb:0034946c tid:0
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.280701] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.280756] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109237
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.280798] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.280865] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: txall 47 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.280933] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 7 0 0 0 0 ifs_boff 0
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.280982] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.281033] brcmfmac: CONSOLE: 036337.561 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.281124] brcmfmac: CONSOLE: 036337.561 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 12:23:12 2016 kern.debug kernel: [ 9602.281185] brcmfmac: CONSOLE: 036337.561 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.283602] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: wl0.2 scb:0034946c tid:0
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.283727] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.283781] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109686
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.283824] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.283890] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: txall 1 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.283957] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 3 0 0 0 0 ifs_boff 0
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.284008] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.284058] brcmfmac: CONSOLE: 036347.569 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.284150] brcmfmac: CONSOLE: 036347.569 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 12:23:22 2016 kern.debug kernel: [ 9612.284212] brcmfmac: CONSOLE: 036347.569 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
Sat Oct 15 12:23:25 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 12:23:26 2016 kern.err kernel: [ 9616.738647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:23:27 2016 kern.err kernel: [ 9617.698647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:23:28 2016 kern.err kernel: [ 9618.649206] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:23:28 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 12:23:29 2016 kern.err kernel: [ 9619.606333] brcmfmac: brcmf_notify_connect_status_ap: event ASSOC_IND (8), reason 0
Sat Oct 15 12:23:29 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: associated
Sat Oct 15 12:23:32 2016 kern.debug kernel: [ 9622.781918] brcmfmac: CONSOLE: 036358.071 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Sat Oct 15 12:23:32 2016 kern.err kernel: [ 9622.781972] brcmfmac: brcmf_notify_connect_status_ap: event DEAUTH (5), reason 3
Sat Oct 15 12:23:32 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

#10
Sat Oct 15 12:27:25 2016 daemon.info hostapd: wlan1-1: STA 88:53:2e:50:50:00 WPA: group key handshake completed (RSN)
Sat Oct 15 12:27:28 2016 kern.err kernel: [ 9858.338647] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Sat Oct 15 12:27:28 2016 daemon.info hostapd: wlan1-1: STA 84:38:38:e4:b5:ea WPA: group key handshake completed (RSN)
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.429832] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: wl0.2 scb:0034946c tid:0
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.429956] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430011] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 109632
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430054] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430121] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: txall 4 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430187] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 4 0 0 0 0 ifs_boff 0
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430238] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430289] brcmfmac: CONSOLE: 036596.854 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430380] brcmfmac: CONSOLE: 036596.854 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 12:27:31 2016 kern.debug kernel: [ 9861.430441] brcmfmac: CONSOLE: 036596.854 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39

#11
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438336] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: wl0.2 scb:0034946c tid:0
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438461] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438516] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 107539
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438559] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438705] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: txall 13 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438782] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 11 0 0 0 0 ifs_boff 0
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438833] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438883] brcmfmac: CONSOLE: 036603.864 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.438975] brcmfmac: CONSOLE: 036603.864 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
Sat Oct 15 12:27:38 2016 kern.debug kernel: [ 9868.439037] brcmfmac: CONSOLE: 036603.864 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
