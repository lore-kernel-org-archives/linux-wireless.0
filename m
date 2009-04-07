Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54378 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878AbZDGQRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 12:17:24 -0400
Date: Tue, 7 Apr 2009 19:17:18 +0300
From: Jouni Malinen <j@w1.fi>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Making promisc mode work with WPA encryption?
Message-ID: <20090407161718.GA19733@jm.kir.nu> (sfid-20090407_181742_985090_0D2A0C24)
References: <1239063352.4705.40.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239063352.4705.40.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 07, 2009 at 03:15:52AM +0300, Maxim Levitsky wrote:

> But I could arrange small program that listens to device in monitor or
> maybe even just promisc mode, and records WPA handshakes. For every
> handshake it could install the key in kernel driver, so it would use it
> for decryption, and show the traffic on device in promisc mode. Is it
> possible to do today? I guess not.

No, and I don't see why this should ever end up in the kernel.. It is
better done in userspace for such a special case. The key configuration
interface does not support configuring different keys based on the
receiver address and most hardware acceleration designs would not
support matching the key in this way, so the standard mechanism used for
decrypting packets to the STA in normal case does not really suit this
type of need.

> All this program has to know is the PSK.
> (I could even arrange WPA supplicant to do this job - it knows all keys
> already)

Sure, you could figure out the PTK for each STA when using WPA-Personal
(but not so for WPA-Enterprise/EAP), but that is only one part of the
task. The problem comes from decrypting packets that were not designed
to be decrypted (unicast frames to other STAs).

-- 
Jouni Malinen                                            PGP id EFC895FA
