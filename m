Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F6AC10F0B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B41912173C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="xeTaQIkq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfBZJQQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:16:16 -0500
Received: from narfation.org ([79.140.41.39]:48668 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfBZJQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:16:15 -0500
Received: from bentobox.localnet (unknown [IPv6:2001:16b8:55a6:6fea:5e82:58e:dae2:b2b])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 96A5D1100E8;
        Tue, 26 Feb 2019 10:16:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=narfation.org;
        s=20121; t=1551172573;
        bh=ARRls0iKybpvcvOmKcvhTTzEi1oXn9xUY68Osi1R0U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xeTaQIkqj3DKwsgnx6j/QC6zjIo1TFrQv2nUGziXeM/wRGonrEvHi8OBoORxn9AcR
         PVWADZBawNygzLMM3QKB8tfdnysiOic2yW/p65LjE0CEPvqdotq/3/ddHlWNOqQhHZ
         v55Jro8zEnfRcVRKhjFk1ibXmDruBi8/OHTUhh6s=
From:   Sven Eckelmann <sven@narfation.org>
To:     ath10k@lists.infradead.org, John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        openwrt-devel@lists.openwrt.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: Re: [PATCH v13] ath10k: add LED and GPIO controlling support for various chipsets
Date:   Tue, 26 Feb 2019 10:16:05 +0100
Message-ID: <2468724.JaAZLprVu6@bentobox>
In-Reply-To: <1523027875-5143-1-git-send-email-kvalo@codeaurora.org>
References: <1523027875-5143-1-git-send-email-kvalo@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3062142.xbTPQMdo2G"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart3062142.xbTPQMdo2G
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, 6 April 2018 17:17:55 CET Kalle Valo wrote:
> From: Sebastian Gottschall <s.gottschall@newmedia-net.de>
> 
> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 based
> chipsets with on chipset connected led's using WMI Firmware API.  The LED
> device will get available named as "ath10k-phyX" at sysfs and can be controlled
> with various triggers.  adds also debugfs interface for gpio control.
> 
> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
> [kvalo: major reorg and cleanup]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>


This patch was imported to OpenWrt in commit 61d57a2f88b9 ("mac80211: ath10k 
add leds support") and broke the 11s support for IPQ4019 and QCA4019 (5GHz) 
firmware versions 10.4-3.5.3-00053, 10.4-3.5.3-00057, 10.4-3.6-00140:

    [  221.620803] ath10k_pci 0000:01:00.0: wmi command 36967 timeout, restarting hardware
    [  221.744056] ieee80211 phy0: Hardware restart was requested
    [  225.130829] ath10k_pci 0000:01:00.0: failed to receive control response completion, polling..
    [  226.170824] ath10k_pci 0000:01:00.0: Service connect timeout
    [  226.170871] ath10k_pci 0000:01:00.0: failed to connect htt (-110)
    [  226.252248] ath10k_pci 0000:01:00.0: Could not init core: -110

This was tested on an A62 with following wireless config:

    config wifi-device 'radio0'
            option type 'mac80211'
            option channel '36'
            option hwmode '11a'
            option path 'soc/40000000.pci/pci0000:00/0000:00:00.0/0000:01:00.0'
            option htmode 'VHT80'
            option disabled '0'
            option country US
    
    config wifi-device 'radio1'
            option type 'mac80211'
            option channel '11'
            option hwmode '11g'
            option path 'platform/soc/a000000.wifi'
            option htmode 'HT20'
            option disabled '0'
            option country US
    
    config wifi-device 'radio2'
            option type 'mac80211'
            option channel '149'
            option hwmode '11a'
            option path 'platform/soc/a800000.wifi'
            option htmode 'VHT80'
            option disabled '0'
            option country US
    
    config wifi-iface 'mesh0'
        option device 'radio0'
        option ifname 'mesh0'
        option network 'nwi_mesh0'
        option mode 'mesh'
        option mesh_id 'TestMesh'
        option mesh_fwding '1'
        option encryption 'none'
    
    config wifi-iface 'mesh1'
        option device 'radio1'
        option ifname 'mesh1'
        option network 'nwi_mesh1'
        option mode 'mesh'
        option mesh_id 'TestMesh'
        option encryption 'none'
    
    
    config wifi-iface 'mesh2'
        option device 'radio2'
        option ifname 'mesh2'
        option network 'nwi_mesh2'
        option mode 'mesh'
        option mesh_id 'TestMesh'
        option mesh_fwding '1'
        option encryption 'none

Kind regards,
	Sven
--nextPart3062142.xbTPQMdo2G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlx1A9UACgkQXYcKB8Em
e0ZR5A//Z5JgzDfPdNg3PFL8+ZN+obc7d/AlOyYHm5EXEHDvsYx6CMlA3TVfbChy
7sDHN4NBIjWW3qxUcAm1fLc/HQ6TCJcMCW7FBpXL+lSLxJwZA4AmROIk1ICy67wu
FaPZUmUC95VuqWQLRtwpYLZ9fGkStnIZYsZLIZCWeUpuMK62FxPwe2VDfiI7oZXV
EIJRhZ/nER7ZzTl8Cm9K5uOhLGqNyAo0ki9mNmM8xJZnWX9Ggziavoe8GqXheENa
/PL6GTpxv5qlNR/Yf0Hvgcc+oXlRI2/jKVMWWAsK17oZrLuiDMQg/TWLc1XYwwbI
2Gae5N+1FK90qHmnQKzHxOvxgski4wtC5XCnsl6PzIVNDsA11JYu2V90h73azSds
1IwjlvfJkchA5AxcXBjOpH8BGF41AE3kBfRINhCA3gxP8XYKgtkzUJSqv0dc4mmD
nbuqxu1GoBCMoz8XjKsVGeLE70M/0xzTHhe4qr619eNcvcmax4M0M9N9cU5ofHEd
6B+zxRtUAPPLDMKiLp7lNNJgWDB9t/NXKMfsuLjXpMGb01bTVLGm52HBtioJ3vRU
qdjB2NEXk9XMCUnYYV8a757V1Gnr/yiqgUDjowUyDrEaVOHrtAwOZuRol2aW5CCP
dzeS/Nne606+B17PRu5WgHLjE/AAVvgISVSO/c1Ff/ar8zzvCGU=
=y19m
-----END PGP SIGNATURE-----

--nextPart3062142.xbTPQMdo2G--



