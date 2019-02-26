Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228B3C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58992173C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="D568s2lD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfBZJXi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:23:38 -0500
Received: from narfation.org ([79.140.41.39]:48690 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbfBZJXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:23:37 -0500
Received: from bentobox.localnet (unknown [IPv6:2001:16b8:55a6:6fea:5e82:58e:dae2:b2b])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 070621100E8;
        Tue, 26 Feb 2019 10:23:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=narfation.org;
        s=20121; t=1551173014;
        bh=Ih9lUnb6HpUibt5SNiB8UfFHpfxAaCw3AV8rXqlNJ/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D568s2lDk1UEp4JuboB7DdiOC4y8pvqZX/snqxsaf4OSj17HYcBhSsTPfgSD2e4+b
         CAsRdqNWWTgXsqukdhwsSUjHVh79nSkwmCdbjH52DLxeSd7XTBrP9ceeezUjg1tG30
         4t8Km0kUSDSaz9zKYq/kkkJ8neBTJs5rrZyVW37k=
From:   Sven Eckelmann <sven@narfation.org>
To:     Sven Eckelmann <sven@narfation.org>,
        Ansuel Smith <ansuelsmth@gmail.com>
Cc:     ath10k@lists.infradead.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Zhi Chen <zhichen@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        John Crispin <john@phrozen.org>,
        Steve deRosier <derosier@cal-sierra.com>
Subject: Re: [PATCH] ath10k: fix incorrect multicast/broadcast rate setting
Date:   Tue, 26 Feb 2019 10:23:30 +0100
Message-ID: <3062143.B1lnfLpWcE@bentobox>
In-Reply-To: <2172036.sbaLp6LFFn@bentobox>
References: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org> <2172036.sbaLp6LFFn@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2093160.Su1pxlAiQj"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart2093160.Su1pxlAiQj
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, 25 February 2019 21:00:38 CET Sven Eckelmann wrote:
[...]
> Tested-by: Sven Eckelmann <sven@narfation.org>
> 
> Was tested on QCA988X with 10.2.4-1.0-00041

I just wanted to test it with 802.11s setup on IPQ4019 with 10.4-3.5.3-00057 
and QCA9888 with 10.4-3.5.3-00053 (ath10k-firmware) and 10.4-3.6-00140
(linux-firmware 2018-12-16-211de167) for both. But it looks like the firmware 
always crashes with and without this patch and 11s.

    [  221.620803] ath10k_pci 0000:01:00.0: wmi command 36967 timeout, restarting hardware
    [  221.744056] ieee80211 phy0: Hardware restart was requested
    [  225.130829] ath10k_pci 0000:01:00.0: failed to receive control response completion, polling..
    [  226.170824] ath10k_pci 0000:01:00.0: Service connect timeout
    [  226.170871] ath10k_pci 0000:01:00.0: failed to connect htt (-110)
    [  226.252248] ath10k_pci 0000:01:00.0: Could not init core: -110

If i count correctly, this is WMI_10_4_GPIO_CONFIG_CMDID. Not really supported 
by upstream but it looks like there is an Openwrt private patch (not yet
accepted upstream [1])

  package/kernel/mac80211/patches/ath/974-ath10k_add-LED-and-GPIO-controlling-support-for-various-chipsets.patch 

which I have now removed to fix this problem for me.

The tests with 10.4-3.6-00140 and 10.4-3.5.3-* worked fine without this patch.

@Kalle are you expecting that he resents the patch again or can you just 
append this information to the commit message? At least it looks at the moment 
like there will be no new patch in the near future. But the 
commit cd93b83ad92 ("ath10k: support for multicast rate control") is breaking 
real world setups.

Kind regards,
	Sven

[1] https://patchwork.kernel.org/patch/10327075/
--nextPart2093160.Su1pxlAiQj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlx1BZIACgkQXYcKB8Em
e0YvKhAAnyguDTsGDYi5g7x5U4XjIbo0doEW7Gqmb4KvMTsUvdSMjhCh9ckvGdkp
1j6js0WN+f1lZ8Ob6qMEtySjABZ7r9KZs0QlWC1QUoZtesO4aJpzBbRK8vQwi1aw
ytzu2lP/NvHsMIY7VT4xX/6THGeV/yNZmudT4dj3KvzM4vnSrtoeR7FD/jv+AmxG
GWtNjgsNZfApqTrRef5j9F8Nl118GMVwpqpluAQL8w0f6h/mQA+6ZdyNAKJlWt/p
3ZMRV/1d8KUpwIb8QhNCsGnV7oAh+xJQhat6UqMa7Wsiz/ahVHlvweYUIc0Rm43u
By5aYj6Bi0amJLkAZpHI8xyyhQK5UVFv6pwJi4PEs4pY7dUfnAjXGY9SeqMqmPWH
WNGhQRJn/E+M1Y9NAYzaNyrsFMgWtb7D7QiI7F2te+DZnoXjjRD2nLzX9UcEWNpO
Yp2BuddecxVij8lId0tN7qDUua4CrAEJrRdUH7iDGkR+fIPqQ9ftS+jqESOSpB9T
p2VLoRiqiIs7eSiW5qZvx93xKFtkaK9E10vAkd/oV2KE1ds/Ct0Dn4uyfxN3Bu+1
ThieigxlY4Af317nXwAat8X01SUSHWf1iGWB8XA2q4Yvklpx3V4CdVCgWwzZcsix
Cn/4fanEatPLvTI8Ef8Vz526puDSLsntmb9YTtkBNvBevQtiVI4=
=1miS
-----END PGP SIGNATURE-----

--nextPart2093160.Su1pxlAiQj--



