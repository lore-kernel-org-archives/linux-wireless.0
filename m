Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C0DC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 10:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E7620657
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 10:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="mnmjM0hQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfAQKEI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 05:04:08 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39202 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfAQKEI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 05:04:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TGwtkV3yY7sp32Zjd0VaKOSq8k0JNi2G7jkOGWrvsDo=; b=mnmjM0hQ/XsPe1tx2CdUd60WE
        o590H+mP2jfoRH0ogeUULSZrFInhNnFNPOf292ZM+JZU4XNEHDz4bIzaS2oFF4ZBvPe5cpO2aYk3s
        GLAcsg365Jgh5yQua7kVQGBiN2Eldzc+EpH5MkwSbIMt5eR3wIZv0/6JWWcvyNC4PSnss=;
Received: from e5254000004ec.dyn.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:35874 helo=shell.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1gk4Wi-0000ja-Rt; Thu, 17 Jan 2019 10:03:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1gk4Wi-0008GM-5a; Thu, 17 Jan 2019 10:03:56 +0000
Date:   Thu, 17 Jan 2019 10:03:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Message-ID: <20190117100355.4x2vinai3aawtka7@e5254000004ec.dyn.armlinux.org.uk>
References: <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
 <20190108232646.GV11171@n2100.armlinux.org.uk>
 <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
 <20190109105622.GY11171@n2100.armlinux.org.uk>
 <20190111141543.GA2392@n2100.armlinux.org.uk>
 <9486d79d-ad48-1112-7100-65f9f9e5fc06@broadcom.com>
 <20190116001204.cjpvbr3okha4fhz7@e5254000004ec.dyn.armlinux.org.uk>
 <c33521df-9b75-49c8-1bfa-67ff6e7a8b74@broadcom.com>
 <20190116125149.mm3vviqgbfovtxak@e5254000004ec.dyn.armlinux.org.uk>
 <c4a0053e-5312-1b1f-68c9-ef58642698fa@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4a0053e-5312-1b1f-68c9-ef58642698fa@broadcom.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 16, 2019 at 02:21:32PM +0100, Arend Van Spriel wrote:
> The patch below works for me so can you provide the counters file contents
> after hitting the issue.

Okay, with the patch fixed, it seems to have failed last night for some
reason... I'm not sure exactly when it died, possibly about an hour
after bringing it up.  Here's the full log.

[674188.169386] brcmfmac: F1 signature read @0x18000000=0x16044330
[674188.192244] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4330-sdio for chip BCM4330/4
[674188.531614] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 31 expected 31
[674188.532876] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 31 expected 31
[674188.534489] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 36 expected 36
[674188.535340] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 84 expected 84
[674188.535606] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4330-sdio for chip BCM4330/4
[674188.544601] brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4330-sdio.clm_blob failed with error -2
[674188.555155] brcmfmac: brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may have limited channels available
[674188.568076] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 276 expected 276
[674188.568139] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4330/4 wl0: Oct 25 2011 19:34:12 version 5.90.125.104
[674188.579811] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 279 expected 279
[674188.580606] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 24 expected 24
[674188.581407] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.582207] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 45 expected 45
[674188.583033] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 45 expected 45
[674188.583931] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674188.584654] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674188.585535] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674188.586539] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 788 expected 788
[674188.587620] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 48 expected 48
[674188.588526] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 24 expected 24
[674188.589478] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 30 expected 30
[674188.590347] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 32 expected 32
[674188.591239] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 24 expected 24
[674188.592167] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 36 expected 36
[674188.592893] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[674188.593754] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674188.594476] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[674188.597599] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 36 expected 36
[674188.599126] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[674188.600055] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674188.600955] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674188.601729] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 32 expected 32
[674188.602519] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[674188.609345] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 1562 expected 1562
[674188.610594] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.611494] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.612337] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.613093] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.613902] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.614692] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.615691] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.617340] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.618146] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.618986] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.619906] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.620704] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.621555] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.622407] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.623174] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.624069] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.624824] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 34 expected 34
[674188.625752] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674188.626512] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 32 expected 32
[674188.627322] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 45 expected 45
[674188.628271] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 45 expected 45
[674188.630655] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674188.643691] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674188.652041] brcmfmac: CONSOLE: 
[674188.652056] brcmfmac: CONSOLE: RTE (USB-SDIO-CDC) 5.90.125.104 on BCM4330 r4 @ 37.4/80.0/80.0MHz
[674188.652066] brcmfmac: CONSOLE: sdpcmdcdc0: Broadcom SDPCMD CDC driver
[674188.652074] brcmfmac: CONSOLE: using p2p microcode
[674188.652083] brcmfmac: CONSOLE: reclaim section 0: Returned 35840 bytes to the heap
[674188.652092] brcmfmac: CONSOLE: wl0: Broadcom BCM4330 802.11 Wireless Controller 5.90.125.104
[674188.652099] brcmfmac: CONSOLE: TCAM: 64 used: 2 exceed:1
[674188.652108] brcmfmac: CONSOLE: reclaim section 1: Returned 53969 bytes to the heap
[674188.652116] brcmfmac: CONSOLE: sdpcmd_dpc: Enable
[674189.489923] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.490870] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.493574] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.495150] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.498398] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.579784] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.584426] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.585174] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.585920] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.586720] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.587548] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 32 expected 32
[674189.588639] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.589538] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 24 expected 24
[674189.590332] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 24 expected 24
[674189.591479] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.592930] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.593836] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.596863] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 37 expected 37
[674189.597778] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.599847] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[674189.606219] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.608057] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.609263] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.610376] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.611772] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 43 expected 43
[674189.612751] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.613604] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.614626] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.615852] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.616981] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.619829] br0: port 2(wlan0) entered blocking state
[674189.625163] br0: port 2(wlan0) entered disabled state
[674189.631653] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 43 expected 43
[674189.632428] device wlan0 entered promiscuous mode
[674189.637858] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.638894] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.640134] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.641239] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.642256] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.643597] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 43 expected 43
[674189.644631] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.645397] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.646346] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.647252] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.648207] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.655886] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[674189.667957] brcmfmac: CONSOLE: wl0: bc/mc deauth_reason on STA BSS?
[674189.727732] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.728995] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 24 expected 24
[674189.729967] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.730894] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.731900] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.733193] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 36 expected 36
[674189.734079] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.735139] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.736663] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.737396] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.738115] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.743790] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.744667] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.745375] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.746121] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.746916] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.763862] brcmfmac: CONSOLE: 2 packets not freed at wlc_down
[674189.826446] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.829309] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 68 expected 68
[674189.829978] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[674189.837884] br0: port 2(wlan0) entered blocking state
[674189.843192] br0: port 2(wlan0) entered forwarding state
[674189.851206] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[674189.852241] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.853249] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 32 expected 32
[674189.854248] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.855255] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674189.862109] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 49 expected 49
[674189.863114] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674189.865226] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674189.866229] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674189.867161] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674189.870911] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674190.942585] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 49 expected 49
[674190.943757] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 29 expected 29
[674190.944682] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 20 expected 20
[674190.945739] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
[674190.947201] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 26 expected 26
[674190.949043] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674224.997894] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[674225.001821] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[674225.002556] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674225.003276] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674225.004170] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674225.053950] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674225.062091] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[674225.062991] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[674225.077856] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 0
[674231.261377] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 789 expected 789
[674241.468933] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[674524.994041] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[674524.995691] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[674524.996906] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[674789.949598] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[674789.950312] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674789.951026] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674789.951938] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[674807.989875] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[674807.990785] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[674807.991795] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[675097.982242] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[675097.983180] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[675097.984451] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[675131.782331] brcmfmac: CONSOLE: wl0: ampdu_resp_timeout: cleaning up resp tid 0 waiting for seq 0x59c for 200 ms
[675348.979377] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[675348.980387] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[675348.981844] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[675390.876779] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[675390.877640] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[675390.878505] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[675390.879567] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[675390.895704] brcmfmac: CONSOLE: wl0: ampdu_resp_timeout: cleaning up resp tid 0 waiting for seq 0x5aa for 200 ms
[675652.966709] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[675652.967540] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[675652.968715] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[675965.956290] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[675965.957127] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[675965.958261] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[675990.849698] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[675990.850412] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[675990.851132] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[675990.852062] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[675990.865568] brcmfmac: CONSOLE: wl0: ampdu_resp_timeout: cleaning up resp tid 0 waiting for seq 0x5b7 for 200 ms
[676125.101860] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 4
[676269.950898] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[676269.951744] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[676269.952754] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[676466.826476] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[676466.826492] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[676472.074194] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[676472.074210] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[676496.704756] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus_regmpdu: unexpected completion: seq 0x15, start seq 0x0
[676496.704771] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x16, start seq 0x0
[676496.704781] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x17, start seq 0x0
[676496.704792] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x18, start seq 0x0
[676496.704801] brcmfmac: CONSOLE: wl0: unexpected seq: start_seq 0x0, seq 0x19
[676561.289093] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x2c tid 4
[676561.289108] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x620 tid 0
[676562.938207] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[676562.939115] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[676562.940173] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[676589.958015] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[676589.958815] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[676589.959664] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[676589.960595] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[676869.932921] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[676869.933826] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[676869.934894] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[676937.491750] brcmfmac: CONSOLE: wl0: ampdu_resp_timeout: cleaning up resp tid 0 waiting for seq 0x793 for 200 ms
[677154.851453] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 5
[677168.923773] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[677168.924582] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[677168.925703] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[677189.706821] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[677189.707632] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677189.708473] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677189.709489] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677484.910905] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[677484.911724] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[677484.912959] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[677520.866571] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[677520.866586] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[677525.462346] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[677525.462362] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[677542.107174] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[677542.108360] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[677542.109310] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[677543.657272] brcmfmac: CONSOLE: wl0: wlc_ampdu_dotxstatus: scb is null
[677643.499536] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[677643.551676] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677643.559409] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[677643.560429] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[677643.575761] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 0
[677647.507459] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 4
[677658.658777] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[677789.644606] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[677789.645528] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677789.646415] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677789.647544] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677828.753246] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[677828.753262] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[677828.753274] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[677828.753300] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[677942.114506] brcmfmac: CONSOLE: 
[677942.114521] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114530] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114538] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114546] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114555] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114563] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114571] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114580] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114588] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114596] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114605] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114613] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114621] brcmfmac: CONSOLE: wl0: PHYTX error
[677942.114628] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.118551] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.118565] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.118574] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.118582] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.485878] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[677943.487845] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[677943.489736] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[677943.506676] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506689] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506698] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506707] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506714] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506722] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506730] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506738] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506746] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506753] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506761] brcmfmac: CONSOLE: wl0: PHYTX error
[677943.506768] brcmfmac: CONSOLE: wl0: PHYTX error
[677959.699504] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[677959.700760] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[677959.701921] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[677977.845822] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[677977.896968] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[677977.905760] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[677977.906808] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[677977.920768] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 0
[677980.104519] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 4
[678009.646914] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[678066.543757] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[678090.242278] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[678162.298239] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[678162.298254] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[678166.945914] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[678166.945930] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[678199.436108] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus_regmpdu: unexpected completion: seq 0x12, start seq 0x0
[678199.436125] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x13, start seq 0x0
[678199.436135] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x14, start seq 0x0
[678199.436145] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x15, start seq 0x0
[678199.436155] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus_regmpdu: unexpected completion: seq 0x16, start seq 0x0
[678199.436163] brcmfmac: CONSOLE: wl0: unexpected seq: start_seq 0x0, seq 0x17
[678230.330311] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x2b tid 4
[678277.832947] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[678277.833940] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[678277.835273] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[678277.847714] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x14c tid 0
[678367.746514] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[678367.746529] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[678372.374251] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[678372.374266] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[678392.801126] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus_regmpdu: unexpected completion: seq 0x2b, start seq 0x0
[678392.801142] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x2c, start seq 0x0
[678392.801153] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x2d, start seq 0x0
[678392.801163] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x2e, start seq 0x0
[678392.801191] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x2f, start seq 0x0
[678393.054261] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[678393.055118] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[678393.056234] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[678393.057964] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[678518.497980] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x56 tid 4
[678518.497995] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x170 tid 0
[678566.824578] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[678566.825656] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[678566.826976] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[678612.164613] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[678612.164628] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[678617.588372] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[678617.588388] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[678617.588399] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus_regmpdu: unexpected completion: seq 0x56, start seq 0x0
[678617.588410] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x57, start seq 0x0
[678617.588420] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x58, start seq 0x0
[678617.588429] brcmfmac: CONSOLE: wl0: unexpected seq: start_seq 0x0, seq 0x59
[678617.588437] brcmfmac: CONSOLE: wl0: unexpected seq: start_seq 0x0, seq 0x5a
[678617.960260] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x173 tid 0
[678683.308609] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x64 tid 4
[678756.108459] brcmfmac: CONSOLE: wl0: ampdu_resp_timeout: cleaning up resp tid 0 waiting for seq 0xaf1 for 200 ms
[678757.588371] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[678757.588387] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[678757.588398] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[678757.588407] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[678763.796827] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[678763.798124] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[678763.799137] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[678763.812057] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 0 reason 36
[678763.812071] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 4 initiator 0 reason 36
[678765.631910] brcmfmac: CONSOLE: wl0: wlc_ampdu_dotxstatus: scb is null
[678765.631924] brcmfmac: CONSOLE: wl0: wlc_ampdu_dotxstatus: scb is null
[678765.631934] brcmfmac: CONSOLE: wl0: wlc_ampdu_dotxstatus: scb is null
[678797.976674] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[678798.005905] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 0
[678798.013165] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[678798.022154] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[678798.023041] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[678800.214078] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 4
[678814.301181] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[678870.077977] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[678982.135603] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[678982.135618] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[678987.939274] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[678987.939290] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[678994.470468] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[678994.481337] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[678994.482168] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[678994.483811] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[678994.484747] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[678994.485583] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[678995.462429] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[678995.473127] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[678995.475241] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[678995.476425] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[678997.204426] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[678997.205502] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[678997.218840] brcmfmac: CONSOLE: wl0: wlc_deauth_sendcomplete: Failed 
[679000.034649] brcmfmac: CONSOLE: wl0: wlc_ampdu_dotxstatus: scb is null
[679088.058606] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[679088.096689] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 25 expected 25
[679088.111311] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
[679088.112389] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[679088.125733] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x2 tid 0
[679090.197414] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x1 tid 4
[679103.736670] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[679158.737641] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[679262.059750] brcmfmac: CONSOLE: wl0: wlc_ampdu_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[679271.439179] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[679271.439195] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[679277.202872] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[679277.202887] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[679290.670105] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus_regmpdu: unexpected completion: seq 0x10, start seq 0x0
[679290.670121] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x11, start seq 0x0
[679290.670132] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x12, start seq 0x0
[679290.670141] brcmfmac: CONSOLE: wl0: ampdu_dotxstatus: unexpected completion: seq 0x13, start seq 0x0
[679340.159392] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x18 tid 4
[679345.427077] brcmfmac: CONSOLE: wl0: wlc_send_bar: seq 0x21a tid 0
[679388.046184] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
[679388.047045] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
[679388.048254] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
[679587.037310] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 4 due to no progress for 2 secs
[679587.037325] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 4 initiator 1 reason 39
[679594.436407] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[679597.060430] brcmfmac: send_key_to_dongle: wsec_key error (-110)
[679597.080552] brcmfmac: CONSOLE: wl0: ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs
[679597.080567] brcmfmac: CONSOLE: wl0: wlc_ampdu_send_delba: tid 0 initiator 1 reason 39
[679598.022611] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[679598.980107] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[679601.667976] brcmfmac: send_key_to_dongle: wsec_key error (-110)
[679602.905381] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[679602.907116] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 22 expected 22
[679602.909065] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[679613.839752] brcmfmac: CONSOLE: wl0: wlc_ampdu_dotxstatus: scb is null
[679613.839767] brcmfmac: CONSOLE: wl0: wlc_ampdu_dotxstatus: scb is null
[679658.183171] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[679707.001572] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[679755.702746] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[679804.476149] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[679853.246025] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[680192.739578] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[680241.511279] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[680264.135556] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[686381.516088] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[686391.583197] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[686408.128386] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[686423.253366] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[686438.198398] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689528.778375] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689546.513189] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689564.300786] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689582.079264] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689599.869496] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689910.809173] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689928.565159] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689951.110787] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689968.909630] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[689986.680260] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690004.531559] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690022.328834] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690333.479694] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690351.164860] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690369.000673] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690386.806691] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690404.593000] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690715.572437] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690733.220200] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690751.018363] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690768.780739] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[690786.632099] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691097.510170] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691115.316866] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691133.105072] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691150.898478] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691168.710485] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691486.628026] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691504.384314] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691522.173066] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691539.984338] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691557.827559] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691868.824310] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691886.503760] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691904.321375] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691922.114367] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[691939.892000] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692251.856616] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692269.205126] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692288.985144] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692306.776002] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692324.546797] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692642.471114] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692660.306637] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692678.112309] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692695.914593] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[692713.720360] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693028.551425] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693046.298834] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693064.144381] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693081.955496] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693099.727677] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693410.330714] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693428.145093] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693445.930758] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693463.829403] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693481.632481] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693799.244606] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693817.035243] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693834.798151] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693849.578429] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[693864.289318] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694175.112674] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694192.908637] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694210.652359] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694228.469818] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694246.236946] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694557.237803] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694575.003543] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694592.783406] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694610.603029] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694628.385468] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694944.082735] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694961.958048] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694979.746380] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[694997.558167] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695015.338464] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695326.139030] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695343.924484] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695361.720915] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695379.493736] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695397.329329] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695708.073930] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695725.885533] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695743.666052] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695761.548784] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[695779.305280] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696093.410044] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696111.159924] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696128.952391] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696146.730482] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696164.595375] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696475.394824] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696493.135980] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696510.924993] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696528.798791] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696546.518669] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696857.288618] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696875.073934] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696892.878010] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696910.653111] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[696928.480411] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[697246.293623] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[697264.105089] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[697281.932548] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[697299.627405] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[697317.501733] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698508.649136] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698526.173188] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698552.600283] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698570.380637] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698588.129810] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698899.846177] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698917.218855] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698935.030577] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698952.787384] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[698970.570049] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699281.493090] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699299.304678] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699314.048574] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699331.857824] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699346.607946] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699736.873108] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699754.645702] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699772.481025] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699790.246199] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[699808.044651] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700118.842189] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700136.638516] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700154.449595] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700172.206717] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700189.981664] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700500.639340] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700518.396572] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700536.208394] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700554.004122] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700571.769185] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700882.540678] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700900.333749] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700918.223971] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700936.773526] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[700954.600303] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701265.304138] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701285.092568] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701302.920098] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701317.731902] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701335.483550] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701646.377305] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701664.186887] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701681.967586] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701699.763666] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[701717.577380] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702028.359603] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702046.174637] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702061.717903] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702079.514495] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702097.271214] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702415.251714] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702432.963182] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702450.780815] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702465.550805] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702483.287798] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702794.033228] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702811.798144] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702829.619974] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702847.400696] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[702865.234319] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703176.096915] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703193.848280] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703211.649628] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703229.431352] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703247.250230] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703564.901377] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703582.682709] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703600.472643] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703618.313200] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703636.057001] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703946.784257] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703964.543780] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[703982.324665] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704000.149923] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704017.954489] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704328.848233] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704346.536867] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704364.356577] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704382.126601] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704399.993705] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704717.652953] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704735.425929] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704753.222402] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704771.004000] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[704788.743695] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705099.618647] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705117.457612] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705135.206791] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705153.018170] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705170.838645] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705481.716278] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705499.537738] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705517.316552] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705535.057593] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705552.824874] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705870.716386] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705888.457607] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705906.257070] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705924.068683] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[705941.854421] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706252.818485] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706270.630263] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706288.413798] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706306.183847] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706323.981956] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706634.935519] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706652.703629] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706670.497166] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706688.348556] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[706706.116453] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707020.920264] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707038.709797] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707056.505111] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707074.317142] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707092.113108] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707403.014599] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707420.802601] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707438.583442] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707456.411707] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707474.207883] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707785.046409] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707802.844701] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707820.680420] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707838.481873] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[707856.285545] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708174.010381] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708191.827618] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708209.553186] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708227.294674] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708245.100799] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708556.093790] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708573.764825] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708591.531054] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708607.506225] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[708625.242009] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[709366.233146] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[709384.029470] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[709401.755309] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[709416.520987] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[709434.295617] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[710894.143288] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[710911.945279] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[710929.735292] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[710947.508609] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[710965.341179] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711276.219576] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711293.976641] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711308.788612] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711330.858731] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711348.662311] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711659.513034] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711677.323794] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711695.087764] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711712.905431] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[711730.662362] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[712041.487519] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[712059.391047] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[712077.225923] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[712094.298148] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713294.228893] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713604.801114] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713622.571603] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713637.336685] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713652.031033] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713669.806408] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713980.651330] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[713998.463012] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714016.251252] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714034.055935] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714053.807172] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714364.661837] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714382.432028] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714400.230338] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714418.078899] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714434.835879] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714752.377932] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714772.134997] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714789.939469] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714809.704255] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[714827.470788] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715138.245689] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715156.043620] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715173.783136] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715191.563445] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715209.375650] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715520.120654] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715537.895819] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715555.745301] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715573.550681] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715591.297532] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715908.998022] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715926.752786] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715944.533684] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715962.353597] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[715980.102473] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716292.778792] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716310.550686] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716328.346516] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716346.152706] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716363.938717] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716674.670957] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716692.441716] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716710.198691] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716728.002763] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[716745.778514] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717063.584286] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717081.340363] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717099.154134] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717116.950318] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717134.697734] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717445.366669] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717463.144447] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717480.964787] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717498.628135] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717516.666332] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717827.333875] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717845.194557] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717862.974759] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717880.794963] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[717898.590981] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718216.349865] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718234.137654] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718251.926195] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718269.716891] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718287.505610] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718598.420279] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718616.301785] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718634.067094] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718651.967397] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718669.636110] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718980.483719] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[718998.219799] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719016.005392] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719033.809251] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719051.605701] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719350.711708] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719369.397339] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719387.169682] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719405.028832] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719422.833395] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719440.613479] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719751.420871] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719769.217263] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719786.990355] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719804.794267] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[719821.709306] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720132.389891] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720150.163227] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720167.927835] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720185.731717] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720203.512258] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720514.539053] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720532.131540] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720549.975131] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720563.959872] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[720581.715912] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[721758.967540] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[721776.652860] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[721794.487529] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[721812.270319] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[721830.072235] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722141.058641] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722158.496551] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722176.262925] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722194.034440] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722211.808976] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722522.530114] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722540.194269] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722557.998673] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722575.800550] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722593.575217] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722904.295048] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722922.015214] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722939.832956] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722957.615096] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[722975.387845] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723292.961477] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723310.778764] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723328.553311] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723346.378609] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723364.130342] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723674.885708] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723692.661873] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723710.481389] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723728.292872] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[723746.058532] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724060.648573] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724078.419421] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724096.225527] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724113.988649] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724131.761225] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724449.311067] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724467.107470] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724484.895482] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724502.733269] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724520.505828] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724832.241634] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724850.031520] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724867.880008] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724885.693730] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[724903.487496] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725215.438769] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725233.125400] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725250.953006] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725268.834897] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725286.623376] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725597.787924] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725615.578847] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725633.380792] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725651.129852] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725668.980014] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725980.921271] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[725998.696330] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726016.513185] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726034.349514] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726052.160108] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726363.831285] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726381.624045] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726399.443439] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726417.341141] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726435.084918] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726746.150306] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726763.980141] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726781.781793] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726799.614532] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[726817.404464] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727129.328924] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727147.171758] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727165.000090] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727182.803396] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727200.637625] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727512.594059] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727530.377432] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727548.186494] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727566.021549] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
[727583.810015] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
