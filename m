Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:43922 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1IFI7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 04:59:50 -0400
Message-ID: <4E65DEC2.60202@linx.net> (sfid-20110906_105954_496008_0CCC165F)
Date: Tue, 06 Sep 2011 09:50:10 +0100
From: Tony Vroon <tony@linx.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: How to request firmware during module init?
References: <4E65DC7D.70306@qca.qualcomm.com>
In-Reply-To: <4E65DC7D.70306@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/09/11 09:40, Kalle Valo wrote:
> I noticed that when I compile ath6kl into kernel boot fails on my
> x86 box as firmware is not available because user space is not
> ready.

Provided CONFIG_FIRMWARE_IN_KERNEL=y you could add this firmware to
the kernel image with CONFIG_EXTRA_FIRMWARE. That's how I successfully
operate monolithic kernels on X86 laptops.
As an example:
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="iwlwifi-6000g2a-5.ucode"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5l3sIACgkQp5vW4rUFj5qIdgCbBD0fzZc+DB8qCxt7UVn4SXYK
THoAoKzKOg/hIpDV4+54KXCWRQu/ziPa
=DREw
-----END PGP SIGNATURE-----
