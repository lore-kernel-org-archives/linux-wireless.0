Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33108 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbcART7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 14:59:42 -0500
Received: by mail-lf0-f49.google.com with SMTP id m198so178462650lfm.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 11:59:41 -0800 (PST)
Subject: Re: Fwd: 8192 WiFi Realtek 8192E disconnects after a while and fails
 to reconnect
To: Larry Finger <Larry.Finger@lwfinger.net>, gilbertdion@gmail.com,
	wlanfae@realtek.com, chaoming_li@realsil.com.cn
References: <CAKQFV0H+K46CO62w=9yNRvVaOpwmDj3UKXD0QOmF1XPs54GwnQ@mail.gmail.com>
 <CAKQFV0EV9WvmzJaUaFEGODc-kxpt=rXJVYe5Md4oM5H00cBaeQ@mail.gmail.com>
 <568EE125.1030103@gmail.com> <569C10A9.8020200@gmail.com>
 <569C39D0.4060909@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Message-ID: <569D442B.8090105@gmail.com> (sfid-20160118_205949_563406_E226666A)
Date: Mon, 18 Jan 2016 20:59:39 +0100
MIME-Version: 1.0
In-Reply-To: <569C39D0.4060909@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi Larry,

On 18.01.2016 02:03, Larry Finger wrote:
> On 01/17/2016 04:07 PM, Mateusz Kulikowski wrote:
[...]
>> System: Ubuntu 15.04 (from usb stick), kernel 3.19.0-15-generic, 
>> x86_64 Machine: MSI AM1I, Sempron 2650, PCIe to mini-pcie "wifi" 
>> bridge (with antenna connector and proper RFKILL wiring).
>> 
>> 
>> Are you able to do more troubleshooting?
>> 
>> Perhaps try different AP/Channel/mode, (dis)connect power cable 
>> from laptop etc.
>> 
>> I'll try to make another reproduction attempt, as without being 
>> able to reproduce it I will probably not be able to fix it.
> 
> Did you see lots of messages regarding the TX rings in the dmesg 
> output? If so, those are errors.

Nope, It was pretty silent (just EAPOL notifications), but I tested 
that on old (distro) kernel.

More error messages on recent kernels may be my fault, as during 
driver cleanups, I converted a lot of RT_TRACE messages to (mostly) 
debug printks that should never get into log.

In some places though I upgraded it to a higher log level - 
in places where error condition was "obvious", perhaps in one or two 
such places we can downgrade message back to dbg level to avoid 
syslog spamming.

For example this message will appear only on more recent kernels:
No more TX desc@7, ring->idx = 12, idx = 12, skblen = 0x18 queuelen=64


Like I said - I'll try to play with most recent kernel 
later this week (probably during weekend) and hopefully will 
figure something out.


Regards,
Mateusz
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWnUQnAAoJELvtohmVtQzBSgkIAI6SLDNzj2u/OdLGGSkKlwWY
ejSWH2qY1ygFIUEocPxEw9cxfxiGaoOGtqC2xAOR4J9RBAcNziRPVbGP1L9rdOZ2
nXo4dLEtRB+YEhgyfSmbtCkRCrAFeCXW9Kw5GKCZv3LKVPRmTMouiMLPGsgEzI+L
tuu2SWZGQEfwqreglPT/TkBcDcAr9+cx4Zkd4sU/2yw13Upyo2Vbfpx/rqPVFd88
Av6/NeUf+oEOeq0IG6k4eBexv3ufQ1x+v7rMT1Eh3A4obLROYWuLoLFuXRQS7Mx8
bmqpPV8W2PwOyozvvvJfx90hriDSNT+W7DSjFZyTZA+esLFFWHxL1WMutbog1F4=
=1QFR
-----END PGP SIGNATURE-----
