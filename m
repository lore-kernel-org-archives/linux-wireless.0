Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36705 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942256AbcJSOZn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:25:43 -0400
Received: by mail-lf0-f50.google.com with SMTP id b75so26110068lfg.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2016 07:25:42 -0700 (PDT)
Subject: Re: BCM43602 firmware reports multiple BRCMF_E_DEAUTH
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
References: <CACna6rzS4nDZ+H5kU71WwTTNLp5uZStpQHv4LLmWBDSdf5jpyw@mail.gmail.com>
 <f97678dc-2869-1b6a-33a3-f829cc30918a@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <befa10f7-265e-3f4e-dd0c-ebcd0b32f3e2@gmail.com> (sfid-20161019_162634_710539_8DDAE999)
Date: Wed, 19 Oct 2016 14:34:06 +0200
MIME-Version: 1.0
In-Reply-To: <f97678dc-2869-1b6a-33a3-f829cc30918a@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------C9AB860780B4E7B23D553841"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------C9AB860780B4E7B23D553841
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/04/2016 08:15 PM, Rafał Miłecki wrote:
> # My smartphone remains in the same place (1 m from the AP) but there is some
> # connection/A-MPDU problem.
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509120] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: wl0.0 scb:0035ee78 tid:0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509250] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: wl0.0 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509304] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 110486
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509346] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509411] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: txall 4 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509477] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 4 0 0 0 0 ifs_boff 0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509527] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509576] brcmfmac: CONSOLE: 026970.308 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509665] brcmfmac: CONSOLE: 026970.308 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
> Tue Oct  4 17:22:22 2016 kern.debug kernel: [  247.509726] brcmfmac: CONSOLE: 026970.308 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
> Tue Oct  4 17:22:41 2016 kern.debug kernel: [  266.456860] brcmfmac: CONSOLE: 026990.068 wl0.0: wlc_send_bar: seq 0x7c tid 0
> Tue Oct  4 17:22:43 2016 kern.debug kernel: [  268.178234] brcmfmac: CONSOLE: 026991.783 pktid is NULL
>
> # After recovering from A-MPDU thing firmware sends BRCMF_E_DEAUTH and
> # BRCMF_E_DISASSOC_IND events.
> # My smartphone never receives deauth/disassoc and it believes it's still
> # connected to the AP.
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275305] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 4
> Tue Oct  4 17:23:24 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275354] brcmfmac: brcmf_notify_connect_status_ap event 12, reason 8
> Tue Oct  4 17:23:24 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.275865] brcmfmac: brcmf_cfg80211_del_key key index (0)
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.276177] brcmfmac: brcmf_cfg80211_del_key key index (0)
> Tue Oct  4 17:23:24 2016 kern.debug kernel: [  309.276188] brcmfmac: brcmf_cfg80211_del_key Ignore clearing of (never configured) key
>
> # My smartphone starts sending packets. It seems brcmfmac refuses them due to
> # STA not being connected and for each packet it reports BRCMF_E_DEAUTH to the
> # driver.
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.000406] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.001227] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.001894] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.002594] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.003741] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004096] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004490] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
> Tue Oct  4 17:23:58 2016 kern.debug kernel: [  343.004936] brcmfmac: brcmf_notify_connect_status_ap event 5, reason 7
> Tue Oct  4 17:23:58 2016 daemon.info hostapd: wlan1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

I just got 400+ messages like this:
wlan1: STA 84:38:38:e4:b5:ea IEEE 802.11: disassociated
this time I was lucky enough to have monitor mode running on some independent
notebook and I got it recorded.

I'm attaching pcapng (Wireshark dump) file. You can see a lot of
Deauthentication frames flying both ways with a reason code 0x0006 (Class 2
frame received from nonauthenticated STA).

I think this reason code seems to match my suspicions: STA didn't realize it was
disconnected and it kept sending packets. Firmware reacted sending Deauth frames

--------------C9AB860780B4E7B23D553841
Content-Type: application/x-bzip;
 name="deauth.tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="deauth.tar.bz2"

QlpoOTFBWSZTWWe6KZkATS7/////////////////////////////////////////////4BNf
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
oyyfJNeYM/mAAg2sz/4u5IpwoSDPdFMy
--------------C9AB860780B4E7B23D553841--
