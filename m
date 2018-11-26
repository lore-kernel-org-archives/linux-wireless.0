Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6135EC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 10:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17BC920817
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 10:11:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RBZCsuSG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17BC920817
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbeKZVE4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 16:04:56 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:32962 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbeKZVE4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 16:04:56 -0500
Received: by mail-yb1-f196.google.com with SMTP id i78-v6so7240611ybg.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2018 02:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=FE5ilpeAfgbVVrKFGOYw2BYswAcIR8zGxKrLOe+jpp0=;
        b=RBZCsuSGbpVfGHJAZXIsKCdA1SYkf1du0dm0dyBRbVeyUYUWuwacRmfBq8m3fIC5iT
         zAqLXSXToBKE3jKeZyCN5RpCohW26sT9iTzt+vz6P2W2h8aJRHUiFePUDvRu9T0RdM6Q
         Hekgb4GrBAvObsa0lwj2h0wdRFaxF4i+OBk80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=FE5ilpeAfgbVVrKFGOYw2BYswAcIR8zGxKrLOe+jpp0=;
        b=LmnBazokoodhhWIZSx5DVZXY0ZTFZXRKHdLshYcT7R1OPOtnPnG4KWjiDrt5nmyJT6
         NZmqA9rHf5zIpW6HmZBWP8IziBYgsoStGy1iTa5XyKSbyppZy8bG1vW30EyfBjVjPaLk
         /JUnL5unZwAQ3S7RPhqaW9fDy/dV2RWUtZhmzVVBgxJOEHGE30sseOwj4jv0YobuVtA3
         Equ96vLzft4ubyTb8FUJo/QX/xXhcR1B1U7vOACyhbUU7x1wvFVB14PSOTFOHw9oMxwa
         KxBHK7Qad0rN0GzWBXedcF3QkmXDCkWfgr4TH4scmwAsoWmyq34pSnCkh3iG/2o0wbsD
         OcqQ==
X-Gm-Message-State: AA+aEWaZOkLeauRojwVLNJ323kGX79MIZI2jHboQ+UCsvyZfD5ukMMnE
        NdnIk1gClmyZrC38t2lySa6HgQ==
X-Google-Smtp-Source: AFSGD/UsJs5Za0DWD+8YOxpjL+0mKRk/gSc0okwVqFrKfFo1YB+vuNZxT2ZqDQb59xcjp2PVrOfT5A==
X-Received: by 2002:a25:2b41:: with SMTP id r62-v6mr16688652ybr.369.1543227078308;
        Mon, 26 Nov 2018 02:11:18 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id w70sm18615180yww.76.2018.11.26.02.11.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Nov 2018 02:11:17 -0800 (PST)
Subject: Re: brcmfmac: regression using AP mode
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <142675996.139583.1543082320719@email.ionos.de>
 <ab765dfac2c4a19d820677c5c05a5566@milecki.pl>
 <355192050.233466.1543151650720@email.ionos.de>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <978d5d47-004e-21a9-0c53-2eb1571a5138@broadcom.com>
Date:   Mon, 26 Nov 2018 11:11:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <355192050.233466.1543151650720@email.ionos.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/25/2018 2:14 PM, Stefan Wahren wrote:
> Hi Rafał,
>
>> Rafał Miłecki <rafal@milecki.pl> hat am 24. November 2018 um 22:23 geschrieben:
>>
>>
>> Possibly you can just update hostapd to anything more recent? I'm afraid
>> the version you're using may suffer from a lot of security issues anyway
>
> thanks for your quick reply. I updated hostapd to 2.6.18 from Debian Buster. This makes hostapd work better, but AP mode still does work (kernel output):
>
> [    6.085594] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> [    6.085772] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
> [    6.085781] cfg80211: failed to load regulatory.db
> [    6.148788] Console: switching to colour frame buffer device 240x67
> [    6.170518] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
> [    6.197752] vc4-drm soc:gpu: fb0: DRM emulated frame buffer device
> [    6.324425] random: crng init done
> [    6.324438] random: 7 urandom warning(s) missed due to ratelimiting
> [    6.365083] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
> [    6.398502] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/6 wl0: Feb 27 2018 03:15:32 version 7.45.154 (r684107 CY) FWID 01-4fbe0b04
> [    6.800404] Bluetooth: hci0: BCM4345C0 (003.001.025) build 0252
> [    9.961790] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   10.026130] Adding 102396k swap on /var/swap.  Priority:-2 extents:1 across:102396k SS
> [   10.272507] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   13.627905] brcmfmac: brcmf_cfg80211_stop_ap: setting AP mode failed -52
> [  146.411501] brcmfmac: brcmf_escan_timeout: timer expired
> [  146.862393] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
> [  257.130466] brcmfmac: brcmf_escan_timeout: timer expired
> [  257.581463] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
>
> Hostapd output:
>
> random: Trying to read entropy from /dev/random
> Configuration file: /etc/hostapd/hostapd.conf
> nl80211: Using driver-based roaming
> nl80211: TDLS supported
> nl80211: Supported cipher 00-0f-ac:1
> nl80211: Supported cipher 00-0f-ac:5
> nl80211: Supported cipher 00-0f-ac:2
> nl80211: Supported cipher 00-0f-ac:4
> nl80211: Supported cipher 00-0f-ac:6
> nl80211: Using driver-based off-channel TX
> nl80211: Supported vendor command: vendor_id=0x1018 subcmd=1
> nl80211: Use separate P2P group interface (driver advertised support)
> nl80211: Enable multi-channel concurrent (driver advertised support)
> nl80211: use P2P_DEVICE support
> nl80211: interface wlan0 in phy phy0
> nl80211: Set mode ifindex 3 iftype 3 (AP)
> nl80211: Setup AP(wlan0) - device_ap_sme=1 use_monitor=0
> nl80211: Subscribe to mgmt frames with AP handle 0x543340 (device SME)
> nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=04
> nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)

Probably the mgmt_stypes is not properly set:

         if (!(wdev->wiphy->mgmt_stypes[wdev->iftype].rx & BIT(mgmt_type)))
                 return -EINVAL;

which makes sense as brcmfmac has following:

static const struct ieee80211_txrx_stypes
brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
         [NL80211_IFTYPE_STATION] = {
                 .tx = 0xffff,
                 .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
         },
         [NL80211_IFTYPE_P2P_CLIENT] = {
                 .tx = 0xffff,
                 .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
         },
         [NL80211_IFTYPE_P2P_GO] = {
                 .tx = 0xffff,
                 .rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
                       BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
                       BIT(IEEE80211_STYPE_DISASSOC >> 4) |
                       BIT(IEEE80211_STYPE_AUTH >> 4) |
                       BIT(IEEE80211_STYPE_DEAUTH >> 4) |
                       BIT(IEEE80211_STYPE_ACTION >> 4)
         },
         [NL80211_IFTYPE_P2P_DEVICE] = {
                 .tx = 0xffff,
                 .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
                       BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
         }
};

So no AP listed here. I suspect Rafał was focusing on "device_ap_sme=1 
use_monitor=1" scenario. You can try adding AP entry with similar rx 
bits as P2P_GO above.

Regards,
Arend
