Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45489 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZDGUT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 16:19:58 -0400
Received: by fxm2 with SMTP id 2so2501800fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 13:19:56 -0700 (PDT)
Subject: Re: Making promisc mode work with WPA encryption?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090407161718.GA19733@jm.kir.nu>
References: <1239063352.4705.40.camel@maxim-laptop>
	 <20090407161718.GA19733@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 23:19:52 +0300
Message-Id: <1239135592.17958.6.camel@maxim-laptop> (sfid-20090407_222005_756047_6435975A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-07 at 19:17 +0300, Jouni Malinen wrote:
> On Tue, Apr 07, 2009 at 03:15:52AM +0300, Maxim Levitsky wrote:
> 
> > But I could arrange small program that listens to device in monitor or
> > maybe even just promisc mode, and records WPA handshakes. For every
> > handshake it could install the key in kernel driver, so it would use it
> > for decryption, and show the traffic on device in promisc mode. Is it
> > possible to do today? I guess not.
> 
> No, and I don't see why this should ever end up in the kernel.. It is
> better done in userspace for such a special case. The key configuration
> interface does not support configuring different keys based on the
> receiver address and most hardware acceleration designs would not
> support matching the key in this way, so the standard mechanism used for
> decrypting packets to the STA in normal case does not really suit this
> type of need.
> 
I mostly agree.
But then maybe its better not to show unencryped frames at all on
promisc interface?


> > All this program has to know is the PSK.
> > (I could even arrange WPA supplicant to do this job - it knows all keys
> > already)
> 
> Sure, you could figure out the PTK for each STA when using WPA-Personal
> (but not so for WPA-Enterprise/EAP), but that is only one part of the
> task. The problem comes from decrypting packets that were not designed
> to be decrypted (unicast frames to other STAs).
Exactly. this why I thought it would be nice if kernel could do that and
present a virtual promisc mode.
Userspace helper could do all the job figuring the keys, and kernel
would just use keys to decrypt the traffic.
I could even hack the wpa_supplicant on all systems that belong to my
network to exchange the keys.


Anyway, thanks,
	Best regards,
		Maxim Levitsky





