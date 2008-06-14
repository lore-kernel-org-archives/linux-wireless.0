Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:52598 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbYFNJje (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 05:39:34 -0400
Date: Sat, 14 Jun 2008 12:38:51 +0300
From: Jouni Malinen <j@w1.fi>
To: Maciek Kaliszewski <mkalkal@interia.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 and WPA
Message-ID: <20080614093851.GF5062@jm.kir.nu> (sfid-20080614_113939_524119_3155082E)
References: <4852658A.4040402@interia.pl> <20080613132317.GB5333@tuxdriver.com> <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com> <48527D72.4070509@interia.pl> <1213375014.29669.36.camel@dv> <4852D6EB.3020304@interia.pl> <1213391287.22425.31.camel@dv> <4852F389.1070506@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4852F389.1070506@interia.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 14, 2008 at 12:24:09AM +0200, Maciek Kaliszewski wrote:

> You are right . It may be wpa_supplicant issue . (I'm moving to hostap list 
> as soon as I get subscribed )
> Kernel is amd64 and wpa_supplicant is i386 binary.

Isn't this the known issue with ioctl compat code when using 64-bit
kernel with 32-bit user space? wireless-tools has some workaround code
for figuring out what kernel is trying to say in WEXT data, but
wpa_supplicant does not have such workaround since I do not believe it
belongs to every user space program that is using WEXT.

If I've understood correctly, Dave Miller is working on cleaning up the
compat WEXT code (see "Proper compat WEXT support" thread from June 3rd
for the patch series). I would hope that that fixes issues with
64/32-bit systems without require all user space programs to be modified
to be aware of the bogus data from the kernel. As a temporary
workaround, it might help to build 64-bit wpa_supplicant for that
kernel.

-- 
Jouni Malinen                                            PGP id EFC895FA
