Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48342 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3BUNHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 08:07:33 -0500
Message-ID: <51261C0B.1040506@hauke-m.de> (sfid-20130221_140744_032982_15FA607B)
Date: Thu, 21 Feb 2013 14:07:23 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "W. Trevor King" <wking@tremily.us>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: rev-17 Broadcom core support in b43 and CONFIG_B43_BCMA_EXTRA
References: <20130221121722.GA23690@odin.tremily.us>
In-Reply-To: <20130221121722.GA23690@odin.tremily.us>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/21/2013 01:17 PM, W. Trevor King wrote:
> I've been poking around in b43 and brcmsmac trying to wrap my head 
> around device detection.  Obviously, b43 and brcmsmac both support 
> some devices, and since 4f3d09d (b43: add option to avoid
> duplicating device support with brcmsmac, 2012-01-11) overlapping
> devices have been masked behind CONFIG_B43_BCMA_EXTRA.  At the time
> of that commit, brcmsmac didn't support the r17 cores, but support
> has since been added in 6f80f01 (brcmsmac: add support for cores
> with revision 17, 2012-12-07).  Does that mean that b43 should move
> the r17 core entry into the masked-by-CONFIG_B43_BCMA_EXTRA block?

Yes you could move that core id into the CONFIG_B43_BCMA_EXTRA block,
but this core was just found on Router SoCs and there you mostly want
to use AP mode, which brcmsmac does not support.

Hauke
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRJhwHAAoJEIZ0px9YPRMyeyYP/jh0czsfjhPx6/WzPQTzt4yF
z2O2+xY5qPqiF0ZRcYSiWrW0u959c2SwY2Tfz/3Jp1Q3P95pVkSlVIBxXnRLWs7C
C+62DJJIoH1aYI3VyslBHUrQ61LcqDldpG76eszCaIxOE0zn4iG6aHPJX7cGptw9
z8BoMyY84AFxI7zJDG0zVOmO1VrL0j29FPXf7p3v1YOHYNK23FLtUS/W6lGIbjoN
lA9e9GpUs5Ec1NDxXrHsxiTb4jmUvLVd1+Pc9r3uF4r7rH3gmmyo1BlLqBV/99Cf
8oecLrHJAfo6SepIMUiGOOO0N7PsytZrQOJYgDAAfUVUmJT1JF0rKUZPtBkwFzTr
RR8cJwxT7whUCoY/s5aHcV7rCpo4wJx8ftxVpSwATGuhALFYWEFbPfNzdeROO6zo
4R5g22oAJybjzQSSQ+onInI4fwu/7NGJnGhz3EvEwHnKtmBAkIkf8pHkjU+6PzhF
Yuf93eznkB1UCiCwvbAVE4pGUZKJPllsBY97IZiFLpE9kZavCFYpmBYwL6PZPCt1
J1ijbU6jm/2UQaCrS0FShYKFQAT2VkCO3yuL/s4vsQ0zGCBA3sbOi4Hf0mVIL2Xc
5vebbVSEboIMi6JeIUfy7aJcyGrzmBpl99puIBWBjxnE1e0mGKPsHZNPF7p/G40Y
6Vr/lL10FoQyvYBvv1fV
=EQlO
-----END PGP SIGNATURE-----
