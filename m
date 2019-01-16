Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B2CC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE7CE206C2
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ECac8FvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391625AbfAPMI1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:08:27 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:34669 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389730AbfAPMI1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 07:08:27 -0500
Received: by mail-yw1-f65.google.com with SMTP id g75so2380500ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 04:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2uawYoiVIao+2JG6FKxm6MxCYha66L0qUXzoCcaZbRo=;
        b=ECac8FvEqrB2lVb6KTviGBKP4wYeRmL7OQKxNbSC4yiDu+1tw2YgD3mVCtfMYBKS29
         gR/8cCtJbLsk4JadwPcZ3D/7/WswB5jjuB2fiVuYT0qkTT3rlD8f5+zDm+abozEoigX8
         aOYIlv2KAt7ikepYzTl0w+cLcKXvYY5VwinXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2uawYoiVIao+2JG6FKxm6MxCYha66L0qUXzoCcaZbRo=;
        b=jEgGNrPDnLuh+6ZfdaQTvnius7OT1SFEk52U9Rl/N4EE7kEPSxkbCbqa/FoJ/uJDyO
         graIHCou9pqv+668xbpYDFPZ3ddMxEOy6QYMuYv/65Q3hqKBHDX4uGU/0Aihh/b/cqPi
         YDXSgbf6FvhQa0cv3ScQi1ZVL8dNXOZ91arqkg82HtasXSOJ4+zFr5iodgl4nWdtYNa+
         OLXuq/j97et93BuzRAvGq7C8fMJYBnlJH6FHhOHlw+CVuMLa3V9QlMjB282w6/J3O6+r
         +1Kqqut8KOY209azgSON/4l5jHwNlsNQzR9A6FJIBpOQZSbRDcvo94xIIDEEFcx6Orkj
         7i2w==
X-Gm-Message-State: AJcUukfGNjqmFP9IAzriLjcw5AareYV9IFIh8lQ/KMe7XvzujkoYcyPR
        1OLCrd9lhtQDNDmIPRLACOdA3w==
X-Google-Smtp-Source: ALg8bN6HKey+vJVjWQcHGu2cZqgR0FZ5nNJl8FPuTkOX9TxH9iRjsrVCrbm8vBr/gCkA/gN+uW2NDQ==
X-Received: by 2002:a81:27cc:: with SMTP id n195mr7122929ywn.243.1547640506349;
        Wed, 16 Jan 2019 04:08:26 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id w63sm2145088ywc.46.2019.01.16.04.08.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 04:08:25 -0800 (PST)
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
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c33521df-9b75-49c8-1bfa-67ff6e7a8b74@broadcom.com>
Date:   Wed, 16 Jan 2019 13:08:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190116001204.cjpvbr3okha4fhz7@e5254000004ec.dyn.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/16/2019 1:12 AM, Russell King - ARM Linux admin wrote:
> On Mon, Jan 14, 2019 at 12:49:09PM +0100, Arend Van Spriel wrote:
>> Could you try the compile and load test I suggested earlier. I will try to
>> replicate things over here as well.
> 
> I'm not sure that helps:
> 
> [588980.874745] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
> [588980.875776] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
> [588980.876925] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
> [589095.542690] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [589098.262719] brcmfmac: send_key_to_dongle: wsec_key error (-110)
> [589100.822465] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
> [589101.814313] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [589104.410194] brcmfmac: send_key_to_dongle: wsec_key error (-110)
> [589106.970045] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110
> [589109.530191] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
> [589110.322685] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> [601235.163954] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> [601245.240024] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> [601264.207886] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> ...
> [605377.238304] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> [605395.118751] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> [605412.976951] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28

So actually it shows me that we are not getting responses. That and the 
pend8021x is starting to look pretty fishy, but lacking console messages 
may be build issue that I explain further down.

> Looking at the time the messages (at 589095.542690) are produced, what
> seems to cause this is when I head out with my LineageOS (TI WiLink
> based) phone to the car and drive off.  I've suspected that's the case
> with all the previous iterations of this problem too.
> 
> At this point, the LineageOS phone is completely unable to reassociate
> with the AP, but it can see the AP with varying amounts of signal - it
> shows medium signal, which drops to nothing when it tries to associate.
> As soon as it stops, the indicated signal seems to come back... not
> sure if that's a LineageOS thing or something that is really happening
> on the Broadcom side.
> 
> It looks to me like the older firmware is not happy about a station
> disappearing off into the distance... surely I can't be the only one
> who takes an associated station out of range of a BRCM4330 in hostap
> mode?

Thanks. Always good to have a scenario to trigger it. I tried setting it 
up over here. Everything looks fine but my stations don't see any 
beacons coming from it :-(

> I don't seem to have any messages from the firmware, and I can't find
> anything useful under /sys/kernel/debug for the driver - the only
> thing I have is:
> 
> # tree /sys/kernel/debug/ieee80211/phy5
> /sys/kernel/debug/ieee80211/phy5
> ├── features
> ├── fragmentation_threshold
> ├── fwcap
> ├── fws_stats
> ├── ht40allow_map
> ├── long_retry_limit
> ├── revinfo
> ├── rts_threshold
> └── short_retry_limit

That is weird. For SDIO it should also have three additional files:

forensics
counters
console_interval

The fact that these are absent suggests that sdio.c was not build with 
DEBUG define. How do you build the brcmfmac driver?

> 0 directories, 9 files
> 
> Also no devcoredumps appear to have been produced, although the
> facility is enabled.
> 
> I'm going back to the 2013 firmware now, which seems to behave itself.

I was also thinking about what has changed since 4.18. One commit that 
comes to mind is the rewrite of scatter-gather handling in bcmsdh.c, ie.
commit 4a5a553ddef7 ("brcmfmac: Use standard SKB list accessors in 
brcmf_sdiod_sglist_rw."). Maybe you revert that and try again.

Regards,
Arend
