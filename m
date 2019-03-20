Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDB6C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 08:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355EC2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 08:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="L+Zifx+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbfCTIh0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 04:37:26 -0400
Received: from narfation.org ([79.140.41.39]:34068 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfCTIhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 04:37:25 -0400
Received: from bentobox.localnet (unknown [IPv6:2001:16b8:5523:5cf2:11e7:332b:14eb:c67a])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id C074F1100E9;
        Wed, 20 Mar 2019 09:37:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=narfation.org;
        s=20121; t=1553071043;
        bh=D3KCSmQcGUyPyvzruVCQhnOiDagqF9dPaMF9W9SMALk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+Zifx+PCTo9kWechY5+qB9XzR6CEmN85Sb0lryBrH8I6BvUpnrmpPWjeIg0ijkww
         FevkQ+cMl8bYgofGnMwC7jVeD0whUzqlCe0ztYnZiJLdVEOvqACwO60Ki16eFh45fc
         /gZO7DlVmyV3c10hNbA+Ohhv7utbo+wSnd5llQ/k=
From:   Sven Eckelmann <sven@narfation.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Catrinel Catrinescu <cc@80211.de>
Subject: Re: [PATCH v2 0/2] Add xo calibration support for wifi rf clock
Date:   Wed, 20 Mar 2019 09:37:14 +0100
Message-ID: <2614783.8fX38OIfA2@bentobox>
In-Reply-To: <20190320044511.12172-1-govinds@codeaurora.org>
References: <20190320044511.12172-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2399685.A95HZVWdDr"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart2399685.A95HZVWdDr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, 20 March 2019 05:45:09 CET Govind Singh wrote:
> PMIC XO is the clock source for wifi rf clock in integrated wifi
> chipset ex: WCN3990. Due to board layout errors XO frequency drifts
> can cause wifi rf clock inaccuracy.
> XO calibration test tree in Factory Test Mode is used to find the
> best frequency offset(for example +/-2KHz )by programming XO trim
> register. This ensure system clock stays within required 20 ppm
> WLAN rf clock.
> 
> Retrieve the xo trim offset via system firmware (e.g., device tree),
> especially in the case where the device doesn't have a useful EEPROM
> on which to store the calibrated XO offset (e.g., for integrated Wifi).
> Calibrated XO offset is sent to fw, which compensate the clock drift
> by programing the XO trim register.

Who is responsible to fill in this values in the device-tree? On other 
products, the correct XTAL capacitor registers values are calibrated on 
different devices (in the same product line) separately to ensure that each 
device has a minimal inaccuracy. During the boot of the device, the two u8 
taken from params_for_tuning_caps (inside the EEPROM) are just written to the 
AR_CH0_XTAL register (mapped to the correct the INDAC and OUTDAC region).

Your patch here seems to be doing something similar (you may correct me if I 
misinterpret something) but you are already saying that these devices don't 
have an EEPROM. This is already quite odd because then we also wouldn't have 
temperature compensation (also stored in per device EEPROM/precal data for 
other devices).

So you move it to the device tree. By default, this device tree is most likely 
a static thing which is shipped with the rest of the firmware. So no per 
device data is stored in this DTB on the flash. To include device specific 
information (mac addresses, calibration data, ...), you could also have the 
bootloader (u-boot for example) change the device tree during the boot process 
and let it inject the device specific XO trim register data.

How is this planned to work? Is the bootloader expected to modify the device 
tree during the boot to provide the device specific xo-cal-data. If yes, where 
is it getting the information from? And is there already support for QDART for 
it?

If you do this, why aren't you using the data from qcom,ath10k-pre-
calibration-data. At least for other ath10k devices, it includes the 
previously mentioned tuning caps. It is the first time I heard about an XO 
trim register and thus it might be something different than what I expect.


Last question: why is it an u32 when the message with xo_cal_data can only 
transport an u8?

Kind regards,
	Sven
--nextPart2399685.A95HZVWdDr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlyR+7oACgkQXYcKB8Em
e0YN1Q//bYYPDFBXGEMAMOw9fXoqELZn3tQrZTxIQgO4pUgSC5z0AJRYhhInJSjX
Bpj6xZErQCRBbDQ6Rt5l4MVff7kdAsxdlk1EvC6PfwmPp5W16kQbFKDzgg2jLv7q
HctZ0a0Ymg+af9yfmk3LF2jTBxHQI8E/0acVriRji0BUyJr25xMNvigoUP2i/W8N
z8JcGlG6H/gQOQqpkmcmbfxVZfO8NdYFplreYnObEIqCVE2jxHs+WT74wN4jtc9R
rocuFgUx1wyCfR368ZaebFedCmOLMLFKfgz343qN445WCTTsXteVX0iRA2uGjYoi
nbO+w7takmRHMiB7p33McJIiIPLhNx5pvVZQY2Hq0/PCp/WJan5JuHjTwNH9cXc1
FGtohj9zcCNsl6zVzxi9RtLpYy7pxWrXblUNhXdozNoi/36EGJr/ZJAWzoBZmAgX
3YiQZxwmAPWKvochTzkIc90kQXvVv0/OlXHPRTrtzB6Ld8rCy0pKKK2PpIiIJeRB
PuuaBWzdrvSP3K+ilK7aPu9PrrVaagIXaIY80Wgw5uO8zvC3zSbsZpJ31ePsR1Mv
oorynjVevuP38PPBSwRl/XicZR1Ea55Q97fdvR+LBPUrPOArTyAekLHOWqORqqtP
pgvd+j/8wQVIp95T4Q5g9/UxmUq8Ord7j11T12a2rWWv1osJ3L0=
=1z4Z
-----END PGP SIGNATURE-----

--nextPart2399685.A95HZVWdDr--



