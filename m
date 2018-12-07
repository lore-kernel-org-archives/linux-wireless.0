Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F5AC64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C28320838
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C28320838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=i2se.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbeLGK3P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:29:15 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:33643 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbeLGK3O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 05:29:14 -0500
Received: from [192.168.178.52] ([109.104.37.200]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MxVbb-1hOYx82osD-00xrgz; Fri, 07 Dec 2018 11:29:07 +0100
Subject: Re: brcmfmac: regression using AP mode
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <142675996.139583.1543082320719@email.ionos.de>
 <ab765dfac2c4a19d820677c5c05a5566@milecki.pl>
 <355192050.233466.1543151650720@email.ionos.de>
 <978d5d47-004e-21a9-0c53-2eb1571a5138@broadcom.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <54026c34-b034-b432-93c0-c492cdc048d3@i2se.com>
Date:   Fri, 7 Dec 2018 11:29:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <978d5d47-004e-21a9-0c53-2eb1571a5138@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Provags-ID: V03:K1:1OnfD1zUENWLfChKJ+UbN/UI5rVZQT2Gg0UdQ1FP/tfKJgInpzd
 8quCphPE6WJWrWIw2qGEOXstGoXVjQljdv4dOEUYJ1/lJA+Fckz1SuIGNSNMmOvukWUChUX
 dBuq72ayMVm5YGN8R6fcD2EkVA1npc1xidBb+byPUWvb2Poc1wLsf6xaK6mW8AwokyEQ3ZS
 2FjpTTYUCXhH4BDI5j3jQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vFrP1WuNkb4=:DCUzNcIGQ/E5k5UF9DntUm
 6CBZ9Nt31m6Usg5KYvB9HOvzMHO4bqxORWTyUDNKMHlcs1P17AoKLjtZxkDq1jl+pazxwHf+i
 /AODQOO6GcL6LmPGp11U0eMNwceWdQIrWslpuL8E9DawTaHhSD6uv8uhJAb5rvhmLvInxs/4k
 9QyUajMPxYOOGKgWZTWC+rm8Gpi+yqaahj3AORBqxQdwdhsyEBvaz2p/l28yy8H8JSxao4SnW
 hJmDlkiKVfcLasZssocHwMjYRDvGl2t7Q4D6kWnEbsgLCTFZUXQ/C9Mw+xKcir3D0IKwOPxzs
 HBztdvZyMck6c0UPDiM8QuOpRJ3a39vOQ8+zjlx41XTDFXxecf4s6SbVIDrTQUYa1FVxi7Hpz
 zC3JA2Nofy4M4mrF07bDUNF/BJ/4rpXafxaZRak2UlcpmA2eqpBkLlUIdX/ybgAUOUIORFNb1
 cmrq9nBf9JpMvBMM+evmx50tYosz9lZyuwbI2Brx8sdpbu7d0+yr8Jy9YJRA99ht8JWPPkrhc
 eoJL/NbakRbrF8lfrjzk186fW/L8su36dj+cp7XJv+ciHwjzzcKKig4rmHLjzi0JkYGFgCR6T
 aix7RI+N05/1ZdW0CqnwwiYLinOu1t/cxt/vzYUNO+rBaM2bP7P4HprXKQXP2ZuoLmKzlQNSW
 1g5mFgTRRi9v9fHU+DvnN3RjaxNfhoR5msYRqPT55dGGLQyz8+6Oqj5oTO8p8hsjmzylE+r/1
 Zk/D0+AITGP8fRsr/6nqPm1YGTdh/UETXhi4ws0GIJK55MvDujsAQ3bopC4=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Am 26.11.18 um 11:11 schrieb Arend van Spriel:
> On 11/25/2018 2:14 PM, Stefan Wahren wrote:
>> Hi Rafał,
>>
>>> Rafał Miłecki <rafal@milecki.pl> hat am 24. November 2018 um 22:23
>>> geschrieben:
>>>
>>>
>>> Possibly you can just update hostapd to anything more recent? I'm
>>> afraid
>>> the version you're using may suffer from a lot of security issues
>>> anyway
>>
>> thanks for your quick reply. I updated hostapd to 2.6.18 from Debian
>> Buster. This makes hostapd work better, but AP mode still does work
>> (kernel output):
>>
>> [    6.085594] cfg80211: Loaded X.509 cert 'sforshee:
>> 00b28ddf47aef9cea7'
>> [    6.085772] platform regulatory.0: Direct firmware load for
>> regulatory.db failed with error -2
>> [    6.085781] cfg80211: failed to load regulatory.db
>> [    6.148788] Console: switching to colour frame buffer device 240x67
>> [    6.170518] brcmfmac: brcmf_fw_alloc_request: using
>> brcm/brcmfmac43455-sdio for chip BCM4345/6
>> [    6.197752] vc4-drm soc:gpu: fb0: DRM emulated frame buffer device
>> [    6.324425] random: crng init done
>> [    6.324438] random: 7 urandom warning(s) missed due to ratelimiting
>> [    6.365083] brcmfmac: brcmf_fw_alloc_request: using
>> brcm/brcmfmac43455-sdio for chip BCM4345/6
>> [    6.398502] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/6
>> wl0: Feb 27 2018 03:15:32 version 7.45.154 (r684107 CY) FWID 01-4fbe0b04
>> [    6.800404] Bluetooth: hci0: BCM4345C0 (003.001.025) build 0252
>> [    9.961790] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [   10.026130] Adding 102396k swap on /var/swap.  Priority:-2
>> extents:1 across:102396k SS
>> [   10.272507] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [   13.627905] brcmfmac: brcmf_cfg80211_stop_ap: setting AP mode
>> failed -52
>> [  146.411501] brcmfmac: brcmf_escan_timeout: timer expired
>> [  146.862393] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
>> [  257.130466] brcmfmac: brcmf_escan_timeout: timer expired
>> [  257.581463] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
>>
>> Hostapd output:
>>
>> random: Trying to read entropy from /dev/random
>> Configuration file: /etc/hostapd/hostapd.conf
>> nl80211: Using driver-based roaming
>> nl80211: TDLS supported
>> nl80211: Supported cipher 00-0f-ac:1
>> nl80211: Supported cipher 00-0f-ac:5
>> nl80211: Supported cipher 00-0f-ac:2
>> nl80211: Supported cipher 00-0f-ac:4
>> nl80211: Supported cipher 00-0f-ac:6
>> nl80211: Using driver-based off-channel TX
>> nl80211: Supported vendor command: vendor_id=0x1018 subcmd=1
>> nl80211: Use separate P2P group interface (driver advertised support)
>> nl80211: Enable multi-channel concurrent (driver advertised support)
>> nl80211: use P2P_DEVICE support
>> nl80211: interface wlan0 in phy phy0
>> nl80211: Set mode ifindex 3 iftype 3 (AP)
>> nl80211: Setup AP(wlan0) - device_ap_sme=1 use_monitor=0
>> nl80211: Subscribe to mgmt frames with AP handle 0x543340 (device SME)
>> nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
>> nl_handle=0x543340 match=04
>> nl80211: Register frame command failed (type=208): ret=-22 (Invalid
>> argument)
>
> Probably the mgmt_stypes is not properly set:
>
>         if (!(wdev->wiphy->mgmt_stypes[wdev->iftype].rx &
> BIT(mgmt_type)))
>                 return -EINVAL;
>
> which makes sense as brcmfmac has following:
>
> static const struct ieee80211_txrx_stypes
> brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
>         [NL80211_IFTYPE_STATION] = {
>                 .tx = 0xffff,
>                 .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
>                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
>         },
>         [NL80211_IFTYPE_P2P_CLIENT] = {
>                 .tx = 0xffff,
>                 .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
>                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
>         },
>         [NL80211_IFTYPE_P2P_GO] = {
>                 .tx = 0xffff,
>                 .rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
>                       BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
>                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
>                       BIT(IEEE80211_STYPE_DISASSOC >> 4) |
>                       BIT(IEEE80211_STYPE_AUTH >> 4) |
>                       BIT(IEEE80211_STYPE_DEAUTH >> 4) |
>                       BIT(IEEE80211_STYPE_ACTION >> 4)
>         },
>         [NL80211_IFTYPE_P2P_DEVICE] = {
>                 .tx = 0xffff,
>                 .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
>                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
>         }
> };
>
> So no AP listed here. I suspect Rafał was focusing on "device_ap_sme=1
> use_monitor=1" scenario. You can try adding AP entry with similar rx
> bits as P2P_GO above.

please ignore my last mail, i forgot to terminate wpa_supplicant before :-(

Your suggestion works with hostapd 2.6. I could prepare a patch but i'm
not sure about the proper commit log.

Stefan

>
> Regards,
> Arend

