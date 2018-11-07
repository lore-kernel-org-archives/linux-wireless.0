Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E321C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 05:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD2920827
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 05:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="vPLRPov6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CD2920827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digip.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbeKGPDa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 10:03:30 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:40425 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbeKGPDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 10:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YNt178rrQYrKFd+jKUxOS6RkHckw0cDUdP5Ks7zE/ow=; b=vPLRPov6m4e325DkRznMbpSiHR
        III80lvpc/H9cHAozYY1JW+htdrpBbyrAvYErgPChz7V45jyUE04AKiSAMYnDVaRInZOKm4KY1zwy
        /vdqxWHeTjJFOxsMa6rWUqRmXEtlEk1gLjorAyJg28aOlaviuEIV62eTPn56cBx+Q57fyA4czdVA9
        9e9ECnca/jVZ33LE/Vz+pJ95IdlJp8xhT43wQAYk5tamlorYp0bkCPBEZqyCgxmSJagdPSiOPN6AZ
        PYH6s/ptyHAvN1Obdpeo0Ajdp9zJstFTVUjBy1tvXici8vsNS4OjzkrtI5fNhGUYX3TvqAVMsyB1n
        EyUVsv0g==;
Received: from [87.94.15.202] (helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <petri@digip.org>)
        id 1gKGUC-0006VY-5T
        for linux-wireless@vger.kernel.org; Wed, 07 Nov 2018 07:34:40 +0200
Date:   Wed, 7 Nov 2018 07:34:39 +0200
From:   Petri Lehtinen <petri@digip.org>
To:     linux-wireless@vger.kernel.org
Subject: Intel 8265 iwlwifi broken recent linux-firmware
Message-ID: <20181107053439.GA2730@ping.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 87.94.15.202
X-SA-Exim-Mail-From: petri@digip.org
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Loading iwlwifi produces the following messages to dmesg. Trying to
bring the wifi interface up also fails.

[Tue Oct 23 07:17:12 2018] iwlwifi 0000:3a:00.0: loaded firmware version 36.7596afd4.0 op_mode iwlmvm
[Tue Oct 23 07:17:12 2018] iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
[Tue Oct 23 07:17:13 2018] iwlwifi 0000:3a:00.0: SecBoot CPU1 Status: 0x3040001, CPU2 Status: 0x0
[Tue Oct 23 07:17:13 2018] iwlwifi 0000:3a:00.0: Failed to start INIT ucode: -110
[Tue Oct 23 07:17:13 2018] iwlwifi 0000:3a:00.0: Failed to run INIT ucode: -110

I'm on Arch Linux, and linux-firmware is built from commit d877533.
With older firmware (commit f1b95fe), it works with this in dmesg
output:

[Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: enabling device (0000 -> 0002)
[Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: loaded firmware version 36.e91976c0.0 op_mode iwlmvm
[Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
[Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: base HW address: 00:28:f8:87:a2:e9

Kernel version is 4.18.16, the machine is a Lenovo T470s. I'm happy to
provide more info!

Petri

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtdaVPm1QWe162g8v02V9JNBYQ0wFAlvieWsACgkQ02V9JNBY
Q0ysBg//a+yWgGWrBBn2pZaZtOBkrSqtiLFU93JayxI2CwynbrGfxwx2ccsarAOf
BMw0JPeYPM9GhoCI/EFU8o0vYMxidHSppfmh/Ig2KjWCaQ4luU4dHXb/Q1dAhRnx
W6FwqQ054fYkgEf5nzMPFbgwuGBXmtYqw/dj8Q46mc2nWH50YaCiVceIbkB6DNbf
akc5hHNwvqpZ34/aiep668mYgl0+GpCxF2wNKwSjkb61A/FsBzII740kUy5saLbB
dTZ1FrqlZzbBwfdl4rCZvQqKxVXGxbmONihOSXFq+MugR+STByIPDgGu30F62LN3
bh4Q5svZ8JTnM6HqU+hEAoY5pti6+/JCS7x68DcdJFspPoGBvmvscrkOcq2433cq
QdZ4+yC3GUVhVZJHGWt2c/9PdX7h/n7uj53bIKHJaXRrz4+4zVa90sVT7BwOTdxA
n0McgS9ZngOIWHO9pv17wbXzoKbXVm07T5nMEOfa4E2m4rE3QztKBpG27XxUHv0+
W3sZb4U7Rvg4QRxV86/l5bcRrHpQ6ou9/L17z+vBqHrJOqEu4Ojv4ArHDyV2eBQY
G7OC/QV0lRqUmJE7YgBd6SJXrpYHInFybrkA7Dh1u3n1mSydNYOYnZ6dP3+6mTIu
5Vbx1do13QFiNfxNSUKuA5hYF+CSk8Tg8I+YbvZEbv5d4CJh3GQ=
=R7As
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
