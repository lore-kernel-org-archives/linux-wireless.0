Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35936 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754524AbcKBTmF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 15:42:05 -0400
Received: by mail-pf0-f176.google.com with SMTP id 189so16994421pfz.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2016 12:42:05 -0700 (PDT)
Subject: Re: BCM43602 firmware reports multiple BRCMF_E_DEAUTH
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
References: <CACna6rzS4nDZ+H5kU71WwTTNLp5uZStpQHv4LLmWBDSdf5jpyw@mail.gmail.com>
 <f97678dc-2869-1b6a-33a3-f829cc30918a@gmail.com>
 <befa10f7-265e-3f4e-dd0c-ebcd0b32f3e2@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1263a154-9a9d-13fa-f657-b4f99f3897ee@broadcom.com> (sfid-20161102_204210_661979_CF65B616)
Date: Wed, 2 Nov 2016 20:42:00 +0100
MIME-Version: 1.0
In-Reply-To: <befa10f7-265e-3f4e-dd0c-ebcd0b32f3e2@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-10-2016 14:34, Rafał Miłecki wrote:
> On 10/04/2016 08:15 PM, Rafał Miłecki wrote:
>> # My smartphone remains in the same place (1 m from the AP) but there
>> is some
>> # connection/A-MPDU problem.
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509120] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: wl0.0 scb:0035ee78 tid:0
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509250] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: wl0.0 dead_cnt 2 tx_in_transit 1
>> psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0
>> cpbusy 0x0
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509304] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 110486
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509346] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509411] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: txall 4 txbcn 0 txrts 0 rxcts 0
>> rsptmout 0 rxstrt 0
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509477] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 4 0 0 0
>> 0 ifs_boff 0
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509527] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509576] brcmfmac:
>> CONSOLE: 026970.308 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509665] brcmfmac:
>> CONSOLE: 026970.308 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due
>> to no progress for 2 secs tx_in_transit 1
>> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509726] brcmfmac:
>> CONSOLE: 026970.308 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1
>> reason 39
>> Tue Oct  4 17:22:41 2016 kern.debug kernel: [  266.456860] brcmfmac:
>> CONSOLE: 026990.068 wl0.0: wlc_send_bar: seq 0x7c tid 0
>> Tue Oct  4 17:22:43 2016 kern.debug kernel: [  268.178234] brcmfmac:
>> CONSOLE: 026991.783 pktid is NULL
>>
>> # After recovering from A-MPDU thing firmware sends BRCMF_E_DEAUTH and
>> # BRCMF_E_DISASSOC_IND events.
>> # My smartphone never receives deauth/disassoc and it believes it's still
>> # connected to the AP.
>> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275305] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 4
>> Tue Oct  4 17:23:24 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275354] brcmfmac:
>> brcmf_notify_connect_status_ap event 12, reason 8
>> Tue Oct  4 17:23:24 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275865] brcmfmac:
>> brcmf_cfg80211_del_key key index (0)
>> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.276177] brcmfmac:
>> brcmf_cfg80211_del_key key index (0)
>> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.276188] brcmfmac:
>> brcmf_cfg80211_del_key Ignore clearing of (never configured) key
>>
>> # My smartphone starts sending packets. It seems brcmfmac refuses them
>> due to
>> # STA not being connected and for each packet it reports
>> BRCMF_E_DEAUTH to the
>> # driver.
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.000406] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.001227] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.001894] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.002594] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.003741] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004096] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004490] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
>> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004936] brcmfmac:
>> brcmf_notify_connect_status_ap event 5, reason 7
>> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA
>> 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> 
> I just got 400+ messages like this:
> wlan1: STA 84:38:38:e4:b5:ea IEEE 802.11: disassociated
> this time I was lucky enough to have monitor mode running on some
> independent
> notebook and I got it recorded.
> 
> I'm attaching pcapng (Wireshark dump) file. You can see a lot of
> Deauthentication frames flying both ways with a reason code 0x0006 (Class 2
> frame received from nonauthenticated STA).
> 
> I think this reason code seems to match my suspicions: STA didn't
> realize it was
> disconnected and it kept sending packets. Firmware reacted sending
> Deauth frames

Hi Rafał,

Staring at the wireshark dump I can not follow your suspicion above.
Where are the packets that STA was sending. The 802.11 spec mentions
there can be more deauth frames being transmitted during the deauth
procedure. So it seems they get stuck in the deauth procedure for some
reason.

Regards,
Arend
