Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48673 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab3BUPAf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 10:00:35 -0500
Message-ID: <51263681.1090705@hauke-m.de> (sfid-20130221_160039_695947_AC281DE9)
Date: Thu, 21 Feb 2013 16:00:17 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "W. Trevor King" <wking@tremily.us>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: rev-17 Broadcom core support in b43 and CONFIG_B43_BCMA_EXTRA
References: <20130221121722.GA23690@odin.tremily.us> <51261C0B.1040506@hauke-m.de> <20130221134637.GA24350@odin.tremily.us>
In-Reply-To: <20130221134637.GA24350@odin.tremily.us>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/21/2013 02:46 PM, W. Trevor King wrote:
> On Thu, Feb 21, 2013 at 02:07:23PM +0100, Hauke Mehrtens wrote:
>> On 02/21/2013 01:17 PM, W. Trevor King wrote:
>>> I've been poking around in b43 and brcmsmac trying to wrap my
>>> head around device detection.  Obviously, b43 and brcmsmac both
>>> support some devices, and since 4f3d09d (b43: add option to
>>> avoid duplicating device support with brcmsmac, 2012-01-11)
>>> overlapping devices have been masked behind
>>> CONFIG_B43_BCMA_EXTRA.  At the time of that commit, brcmsmac
>>> didn't support the r17 cores, but support has since been added
>>> in 6f80f01 (brcmsmac: add support for cores with revision 17,
>>> 2012-12-07).  Does that mean that b43 should move the r17 core
>>> entry into the masked-by-CONFIG_B43_BCMA_EXTRA block?
>> 
>> Yes you could move that core id into the CONFIG_B43_BCMA_EXTRA
>> block, but this core was just found on Router SoCs and there you
>> mostly want to use AP mode, which brcmsmac does not support.
> 
> So maybe a CONFIG_BRCM_BCMA_EXTRA to mask brcmsmac devices when b43
> is the recommended module?
> 
I would like to stay with the current situation. This
CONFIG_B43_BCMA_EXTRA is useful for distributions like Ubuntu where
you have one image used on many different devices and you are shipping
mostly every kernel model. No one used distributions like Ubuntu on
the BCM4716 where this core rev 17 wifi core is found. There you just
build an image with the modules you need so you end up with b43 or
brcmsmac in your image.

Hauke
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRJjaBAAoJEIZ0px9YPRMyhXcP/iYNEkror8YFpTgZwvcgMB+j
IXtbVGg4dCl5LZ5W+tTwmD5pF42mdmIwG9mIwYbY9EC84NT+Fl5oJtCztGRWXORg
S7ErQ1t/kL3kpksShbPIyZurOgSEq12lHs/9MieMyGgBdsrMEXqcmWmtWva1CEhc
jeXaB1sh2hd8O/7hKMcxFPXPqWk6ZQfiyhSLCZlLJpyCvysOGIQBjlsvEc/jxN61
YCRQrmQ6aVvzLk7LCygEH3+kqGFsAJO253zrnhsOfO8HzscE7McSB0jRlgLpECza
otxxLEm3VwB/sJSLxm3Gq0iE1lSyU+qyL/b1bHDeDeHhg6Ws1Dd5jTKv6FpQuqR2
B3nQdItFsYhNZkObXAA/Bdsmqp068zCKnJA1MP6j4EY8vjtBgIkrNmmrXW8U61on
TU5Wm45h0rltlidgVSfLNSMqE2tjXTpArk+vsSiDtj2G6IMXJYaV6BNdLfjhM6QI
y/RPChqY2hP3cVWYx2Kh3swIcAzVAfKHOZVl+C6FUXH+juJSgZUbcof+H/kfe+U9
Zfju1zGm9qKpbv2Vxn3JdllDuL+K/8Aq1Q9qGe+iVLKYcmZmiJ5HNh2qr7NY5dqz
IHMYZWjMKjzWL2K/FOfAYu7QV1Wv3PbXHGIc+iOZ1u1GhEEQCc1S9aYhPfxYkSFF
7FyUJvgSI1lmzuRUdSlW
=bdvI
-----END PGP SIGNATURE-----
