Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34017 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754389AbcJEJIW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 05:08:22 -0400
Received: by mail-pa0-f50.google.com with SMTP id rz1so27518886pab.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 02:08:22 -0700 (PDT)
Subject: Re: BCM43602 firmware reports multiple BRCMF_E_DEAUTH
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
References: <CACna6rzS4nDZ+H5kU71WwTTNLp5uZStpQHv4LLmWBDSdf5jpyw@mail.gmail.com>
 <f97678dc-2869-1b6a-33a3-f829cc30918a@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <90e69e94-2210-22ec-3aec-67d9605b4b7c@broadcom.com> (sfid-20161005_110832_988397_BCDEFC0D)
Date: Wed, 5 Oct 2016 11:08:19 +0200
MIME-Version: 1.0
In-Reply-To: <f97678dc-2869-1b6a-33a3-f829cc30918a@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4-10-2016 20:15, Rafał Miłecki wrote:
> On 09/28/2015 11:00 AM, Rafał Miłecki wrote:
>> I'm using recent brcmfmac and brcmfmac43602-pcie.ap.bin that currently
>> sits in linux-firmware.git.
>>
>> In OpenWrt we have hostapd with a feature of banning STAs. It works in
>> a quite simple way. Whenever hostapd gets NL80211_CMD_NEW_STATION for
>> STA that is banned it sends NL80211_CMD_DEL_STATION.
>>
>> The problem is that in such case BCM43602 firmware happens to randomly
>> send more than 1 BRCMF_E_DEAUTH event. It seems it can send random
>> amount between 1 and 3. Looks a bit like some kind of race. It's
>> nothing really critical, just makes hostapd log a bit confusing.
>>
>> Could someone at Broadcom look at firmware source to see if you can
>> fix this, please?
> 
> Hey, I didn't get any reply on this for a year. I just saw similar
> problem with
> BCM4366. Below you will find a nice log with my extra comments.
> 
> Could take a look at this issue this time, please?

Can try.

> I think it may be another problem related to the A-MPDU thing (bug?) I
> reported
> in "AMPDU stalls with brcmfmac4366b-pcie.bin triggering WARNINGs" e-mail
> thread.

So what firmware version do you have? A colleague pointed me to firmware
fix that may be related so I want to know the target string to build.
Firmware version is in the bin file:

$ hexdump -C fw.bin | tail -40

Regards,
Arend

> # My smartphone remains in the same place (1 m from the AP) but there is
> some
> # connection/A-MPDU problem.
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509120] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: wl0.0 scb:0035ee78 tid:0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509250] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: wl0.0 dead_cnt 2 tx_in_transit 1 psm_mux
> 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509304] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 110486
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509346] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509411] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: txall 4 txbcn 0 txrts 0 rxcts 0 rsptmout
> 0 rxstrt 0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509477] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 4 0 0 0 0
> ifs_boff 0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509527] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509576] brcmfmac:
> CONSOLE: 026970.308 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509665] brcmfmac:
> CONSOLE: 026970.308 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due
> to no progress for 2 secs tx_in_transit 1
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509726] brcmfmac:
> CONSOLE: 026970.308 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1
> reason 39
> Tue Oct  4 17:22:41 2016 kern.debug kernel: [  266.456860] brcmfmac:
> CONSOLE: 026990.068 wl0.0: wlc_send_bar: seq 0x7c tid 0
> Tue Oct  4 17:22:43 2016 kern.debug kernel: [  268.178234] brcmfmac:
> CONSOLE: 026991.783 pktid is NULL
> 
> # After recovering from A-MPDU thing firmware sends BRCMF_E_DEAUTH and
> # BRCMF_E_DISASSOC_IND events.
> # My smartphone never receives deauth/disassoc and it believes it's still
> # connected to the AP.
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275305] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 4
> Tue Oct  4 17:23:24 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275354] brcmfmac:
> brcmf_notify_connect_status_ap event 12, reason 8
> Tue Oct  4 17:23:24 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275865] brcmfmac:
> brcmf_cfg80211_del_key key index (0)
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.276177] brcmfmac:
> brcmf_cfg80211_del_key key index (0)
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.276188] brcmfmac:
> brcmf_cfg80211_del_key Ignore clearing of (never configured) key
> 
> # My smartphone starts sending packets. It seems brcmfmac refuses them
> due to
> # STA not being connected and for each packet it reports BRCMF_E_DEAUTH
> to the
> # driver.
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.000406] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.001227] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.001894] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.002594] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.003741] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004096] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004490] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004936] brcmfmac:
> brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> 
> As you can see in above example I got more than just 3 BRCMF_E_DEAUTH
> reported
> originally for BCM43602 firmware. But this isn't the worst case. In one
> extreme
> situation I got 9714 of these events!
> 
> 
> Mon Oct  3 09:10:04 2016 kern.err kernel: [227426.890053] brcmfmac:
> brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x
> packets
> Mon Oct  3 09:10:04 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:06 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:06 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:06 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:06 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:06 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 472 identical lines were here)
> Mon Oct  3 09:10:07 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:07 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:07 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:07 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:07 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 623 identical lines were here)
> Mon Oct  3 09:10:08 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:08 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:08 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:08 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:08 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 443 identical lines were here)
> Mon Oct  3 09:10:09 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:09 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:09 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:09 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:09 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 434 identical lines were here)
> Mon Oct  3 09:10:10 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:10 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:10 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:10 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:10 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 577 identical lines were here)
> Mon Oct  3 09:10:11 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:11 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:11 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:11 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:11 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 562 identical lines were here)
> Mon Oct  3 09:10:12 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:12 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:12 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:12 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:12 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 451 identical lines were here)
> Mon Oct  3 09:10:13 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:13 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:13 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:13 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:13 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 557 identical lines were here)
> Mon Oct  3 09:10:14 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:14 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:14 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:14 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:14 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 426 identical lines were here)
> Mon Oct  3 09:10:15 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:15 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:15 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:15 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:15 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 340 identical lines were here)
> Mon Oct  3 09:10:16 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:16 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:16 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:16 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:16 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 115 identical lines were here)
> Mon Oct  3 09:10:17 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:17 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:17 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:17 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:17 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 115 identical lines were here)
> Mon Oct  3 09:10:18 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:18 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:18 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:18 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:18 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 150 identical lines were here)
> Mon Oct  3 09:10:19 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:19 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:19 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:19 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:19 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 668 identical lines were here)
> Mon Oct  3 09:10:20 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:20 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:20 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:20 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:20 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 602 identical lines were here)
> Mon Oct  3 09:10:21 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:21 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:21 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:21 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:21 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 482 identical lines were here)
> Mon Oct  3 09:10:22 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:22 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:22 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:22 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:22 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 419 identical lines were here)
> Mon Oct  3 09:10:23 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:23 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:23 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:23 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:23 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 462 identical lines were here)
> Mon Oct  3 09:10:24 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:24 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:24 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:24 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:24 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 584 identical lines were here)
> Mon Oct  3 09:10:25 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:25 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:25 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:25 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:25 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 417 identical lines were here)
> Mon Oct  3 09:10:26 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:26 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:26 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:26 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:26 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 485 identical lines were here)
> Mon Oct  3 09:10:27 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:27 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:27 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:27 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:27 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 200 identical lines were here)
> Mon Oct  3 09:10:28 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:28 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:28 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:28 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> Mon Oct  3 09:10:28 2016 daemon.info hostapd: wlan1: STA
> 3c:15:c2:dd:ce:de IEEE 802.11: disassociated
> (another 14 identical lines were here)
