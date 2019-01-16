Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C9FC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 00:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 623A1206C2
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 00:12:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="o8kXGzH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfAPAMP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 19:12:15 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44256 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfAPAMP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 19:12:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BdnIbbfprvOAkWGhLZKB0CEtqTc/RS3IKGLQSxy/YvA=; b=o8kXGzH0CFj+kIFyUi6/A/3EA
        /NPhDEHiEC2eQKWvg1HNUFMjXKKIkUC5/5cFjB/VfBGy0syBPviTNKvFizjrvU7SAECqoPnxOjgRV
        SpY9WhpbExVWTKwTBY8Kc6eCBkxnkZ0saXLDhWmkNse/8HtPUNR8rPBOINKnojunlzGQE=;
Received: from e5254000004ec.dyn.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:35782 helo=shell.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1gjYoP-00007q-3T; Wed, 16 Jan 2019 00:12:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1gjYoO-0005a8-ER; Wed, 16 Jan 2019 00:12:04 +0000
Date:   Wed, 16 Jan 2019 00:12:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Message-ID: <20190116001204.cjpvbr3okha4fhz7@e5254000004ec.dyn.armlinux.org.uk>
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
 <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
 <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
 <20190108232646.GV11171@n2100.armlinux.org.uk>
 <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
 <20190109105622.GY11171@n2100.armlinux.org.uk>
 <20190111141543.GA2392@n2100.armlinux.org.uk>
 <9486d79d-ad48-1112-7100-65f9f9e5fc06@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9486d79d-ad48-1112-7100-65f9f9e5fc06@broadcom.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 14, 2019 at 12:49:09PM +0100, Arend Van Spriel wrote:
> Could you try the compile and load test I suggested earlier. I will try to
> replicate things over here as well.

I'm not sure that helps:

[588980.874745] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[588980.875776] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[588980.876925] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[589095.542690] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[589098.262719] brcmfmac: send_key_to_dongle: wsec_key error (-110)
[589100.822465] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
[589101.814313] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[589104.410194] brcmfmac: send_key_to_dongle: wsec_key error (-110)
[589106.970045] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110
[589109.530191] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
[589110.322685] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[601235.163954] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[601245.240024] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[601264.207886] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
...
[605377.238304] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[605395.118751] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[605412.976951] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28

Looking at the time the messages (at 589095.542690) are produced, what
seems to cause this is when I head out with my LineageOS (TI WiLink
based) phone to the car and drive off.  I've suspected that's the case
with all the previous iterations of this problem too.

At this point, the LineageOS phone is completely unable to reassociate
with the AP, but it can see the AP with varying amounts of signal - it
shows medium signal, which drops to nothing when it tries to associate.
As soon as it stops, the indicated signal seems to come back... not
sure if that's a LineageOS thing or something that is really happening
on the Broadcom side.

It looks to me like the older firmware is not happy about a station
disappearing off into the distance... surely I can't be the only one
who takes an associated station out of range of a BRCM4330 in hostap
mode?

I don't seem to have any messages from the firmware, and I can't find
anything useful under /sys/kernel/debug for the driver - the only
thing I have is:

# tree /sys/kernel/debug/ieee80211/phy5
/sys/kernel/debug/ieee80211/phy5
├── features
├── fragmentation_threshold
├── fwcap
├── fws_stats
├── ht40allow_map
├── long_retry_limit
├── revinfo
├── rts_threshold
└── short_retry_limit

0 directories, 9 files

Also no devcoredumps appear to have been produced, although the
facility is enabled.

I'm going back to the 2013 firmware now, which seems to behave itself.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
