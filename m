Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57837 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932317AbXGLSQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 14:16:53 -0400
Date: Thu, 12 Jul 2007 20:17:02 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, Guido Guenther <agx@sigxcpu.org>,
	at76c503a-develop@lists.berlios.de
Subject: Re: at76_usb - fourth submission attempt
Message-ID: <20070712201702.72209493@griffin.suse.cz>
In-Reply-To: <1184228166.2377.31.camel@dv>
References: <1184228166.2377.31.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jul 2007 04:16:06 -0400, Pavel Roskin wrote:
> I'd like to submit at76_usb driver for inclusion into the kernel.
> 
> The driver's temporary repository is located at
> http://git.80211libre.org/at76_usb.git/
> 
> To compile the driver standalone, just run "make" and "make install".
> To integrate the driver into the kernel, apply kernel_patch.diff to the
> kernel with -p1 option, then copy at76_usb*.[ch] to drivers/net/wireless

Could you send a direct pointer to the patch? And make a patch that
creates those at76_usb* files in the correct dir by itself? That will
ease the review a lot.

> [...]
> The biggest change that has not been done is conversion to mac80211.  I
> believe it's possible, but I don't expect it to happen overnight.  Until
> then, at76_usb uses its own implementation of 802.11 protocol.

Unfortunately, that prevents being accepted to vanilla.

I'd suggest to convert the driver to mac80211 and submit it then;
otherwise people will tend to look at the code saying "NAK, it contains
its own home grown 802.11 stack" only and not to review the driver in
depth.

Thanks,

 Jiri


-- 
Jiri Benc
SUSE Labs
