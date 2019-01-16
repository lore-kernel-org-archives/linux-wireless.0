Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74088C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3929C20675
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MNdM52UP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392924AbfAPMzw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:55:52 -0500
Received: from mail-yb1-f178.google.com ([209.85.219.178]:36471 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732803AbfAPMzv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 07:55:51 -0500
Received: by mail-yb1-f178.google.com with SMTP id a190so2467490ybg.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 04:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qWbureTeCuY9M+G/YMSROLF5TZ4z2Mqmiv9hx9zvl6E=;
        b=MNdM52UPDrz7XMzKwIVaAmP4F5Jit2DWvq7xXnN2va1Mo4Rt9tPtenk+Pqp6SfyZfT
         yxNnpSt0icw9zKQvWQ3ZkELei06VyUNGt+FjtEsaQoRJUTeNFJaj0BfFXyzQsz4TxmPI
         uQG5NKo8fw6XZXCD54Is0VhLb5E8oiQ/J0cc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qWbureTeCuY9M+G/YMSROLF5TZ4z2Mqmiv9hx9zvl6E=;
        b=FTFmunig3ii8bpUJeEN1FOkgeTiSmXfC3GrORqfzmHxyXXtKm9mJk9Sg2XoGpsUpSM
         CyzcDrR39WHzfDAJhfUGeQ7mFcZRxu8JED0UEzGtjqw/oc5meVHcKlalghVgvcrEf5wy
         WaGCgaIleYIgfztp3lH7Ys5v5Ed89ftoVLaheJ8/9fVqRm2HEhe6AWzL1ThTNA+4Rnzr
         aJAoZUy+nyUhlcbpEb+DZiTQfA3REhkg/WPsSv10MWBKw2X4S/SNMMw/JaTaAgfKPnhY
         dvJwksZtCRYG/oCTBFaLfZjaJCFacd4xPri0g3E1+Stb48LotHE8MAdikxXnz4335BSe
         j7GQ==
X-Gm-Message-State: AJcUuke4bfN/pYT8eQ+Wkdx77+STuaX03nqSx5sN0B/AXobJ5a1cn6eV
        xlcahylUAFMxDhBjyIfeTtwh0g==
X-Google-Smtp-Source: ALg8bN7waiy8TI4ha7KdlPU4UXowWv6zz6TTG3WYtGREzc8exq6HDR9Ym78bYOwZKewp7ghYUYSMxw==
X-Received: by 2002:a25:ba0e:: with SMTP id t14mr5652971ybg.206.1547643349909;
        Wed, 16 Jan 2019 04:55:49 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id g84sm5362537ywg.9.2019.01.16.04.55.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 04:55:49 -0800 (PST)
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
 <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
 <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
 <20190108232646.GV11171@n2100.armlinux.org.uk>
 <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
 <20190109105622.GY11171@n2100.armlinux.org.uk>
 <20190111141543.GA2392@n2100.armlinux.org.uk>
 <9486d79d-ad48-1112-7100-65f9f9e5fc06@broadcom.com>
 <20190116001204.cjpvbr3okha4fhz7@e5254000004ec.dyn.armlinux.org.uk>
 <c33521df-9b75-49c8-1bfa-67ff6e7a8b74@broadcom.com>
 <20190116125149.mm3vviqgbfovtxak@e5254000004ec.dyn.armlinux.org.uk>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3e99e082-88d0-23b4-7a4a-f5651788303d@broadcom.com>
Date:   Wed, 16 Jan 2019 13:55:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190116125149.mm3vviqgbfovtxak@e5254000004ec.dyn.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/16/2019 1:51 PM, Russell King - ARM Linux admin wrote:
> On Wed, Jan 16, 2019 at 01:08:21PM +0100, Arend Van Spriel wrote:
>> On 1/16/2019 1:12 AM, Russell King - ARM Linux admin wrote:
>>> On Mon, Jan 14, 2019 at 12:49:09PM +0100, Arend Van Spriel wrote:
>>>> Could you try the compile and load test I suggested earlier. I will try to
>>>> replicate things over here as well.
>>>
>>> I'm not sure that helps:
>>>
>>> [588980.874745] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
>>> [588980.875776] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
>>> [588980.876925] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
>>> [589095.542690] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>> [589098.262719] brcmfmac: send_key_to_dongle: wsec_key error (-110)
>>> [589100.822465] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
>>> [589101.814313] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>> [589104.410194] brcmfmac: send_key_to_dongle: wsec_key error (-110)
>>> [589106.970045] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110
>>> [589109.530191] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
>>> [589110.322685] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
>>> [601235.163954] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
>>> [601245.240024] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
>>> [601264.207886] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
>>> ...
>>> [605377.238304] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
>>> [605395.118751] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
>>> [605412.976951] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
>>
>> So actually it shows me that we are not getting responses. That and the
>> pend8021x is starting to look pretty fishy, but lacking console messages may
>> be build issue that I explain further down.
>>
>>> Looking at the time the messages (at 589095.542690) are produced, what
>>> seems to cause this is when I head out with my LineageOS (TI WiLink
>>> based) phone to the car and drive off.  I've suspected that's the case
>>> with all the previous iterations of this problem too.
>>>
>>> At this point, the LineageOS phone is completely unable to reassociate
>>> with the AP, but it can see the AP with varying amounts of signal - it
>>> shows medium signal, which drops to nothing when it tries to associate.
>>> As soon as it stops, the indicated signal seems to come back... not
>>> sure if that's a LineageOS thing or something that is really happening
>>> on the Broadcom side.
>>>
>>> It looks to me like the older firmware is not happy about a station
>>> disappearing off into the distance... surely I can't be the only one
>>> who takes an associated station out of range of a BRCM4330 in hostap
>>> mode?
>>
>> Thanks. Always good to have a scenario to trigger it. I tried setting it up
>> over here. Everything looks fine but my stations don't see any beacons
>> coming from it :-(
>>
>>> I don't seem to have any messages from the firmware, and I can't find
>>> anything useful under /sys/kernel/debug for the driver - the only
>>> thing I have is:
>>>
>>> # tree /sys/kernel/debug/ieee80211/phy5
>>> /sys/kernel/debug/ieee80211/phy5
>>> ├── features
>>> ├── fragmentation_threshold
>>> ├── fwcap
>>> ├── fws_stats
>>> ├── ht40allow_map
>>> ├── long_retry_limit
>>> ├── revinfo
>>> ├── rts_threshold
>>> └── short_retry_limit
>>
>> That is weird. For SDIO it should also have three additional files:
>>
>> forensics
>> counters
>> console_interval
>>
>> The fact that these are absent suggests that sdio.c was not build with DEBUG
>> define. How do you build the brcmfmac driver?
> 
> With a split build tree, and brcmfmac as a module.  I've just moved
> drivers/net/broadcom/brcm80211 out of the way and re-built with verbose
> mode enabled.  The gcc lines show that they are indeed passed -DDEBUG.
> 
> If I look inside the sdio.o object, I do find the strings:
> 
> intrcount:    %u
> lastintrs:    %u
> pollcnt:      %u
> regfails:     %u
> 
> which are from brcmf_debugfs_sdio_count_read(), and is only built when
> DEBUG is defined - so the build looks correct.  I also find this in the
> module I have on the target system, so it too was indeed built with
> -DDEBUG as intended.
> 
> Nope, your debugfs support can't possibly work for anyone in 4.20.
> 
> sdio.c sets up the debugfs stuff in brcmf_sdio_debugfs_create() which
> wants wiphy->debugfsdir.  This is called via brcmf_bus_preinit() from
> brcmf_sdio_bus_preinit().  This happens before brcmf_cfg80211_attach().
> 
> This is the key point - brcmf_cfg80211_attach() calls wiphy_register(),
> which is where the wiphy's debugfs directory is setup:
> 
>          /* add to debugfs */
>          rdev->wiphy.debugfsdir =
>                  debugfs_create_dir(wiphy_name(&rdev->wiphy),
>                                     ieee80211_debugfs_dir);
> 
> Consequently, at the time when brcmf_sdio_debugfs_create() is called,
> the debugfs directory has not been setup, so the function merely
> returns.

Crap. I totally missed that when reworking the code to use the wiphy 
debugfsdir.

Thanks,
Arend
