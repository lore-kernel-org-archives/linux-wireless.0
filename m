Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:14559 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZG0O1m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 10:27:42 -0400
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Pavel Roskin <proski@gnu.org>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c6b1100b0907270235l19e9c2d9kb33dae2d6a0f78@mail.gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <c6b1100b0907140404h4fdbe419p8443da43350f3520@mail.gmail.com>
	 <c6b1100b0907210439jf67d886s3125dafa5f4d3928@mail.gmail.com>
	 <c6b1100b0907261215l71ada148y8a15f6595d939192@mail.gmail.com>
	 <1248639013.32168.15.camel@mj>
	 <c6b1100b0907261433s5f069f8ck26861cef5239ef98@mail.gmail.com>
	 <1248653207.3106.9.camel@mj>
	 <c6b1100b0907270235l19e9c2d9kb33dae2d6a0f78@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 10:27:40 -0400
Message-Id: <1248704860.2834.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 10:35 +0100, Chris Clayton wrote:

> I've built and installed a kernel with all the various types of
> MAC80211 debugging turned on (in addition to the RT61 driver's) and
> with CONFIG_MAC80211_DEFAULT_PS enabled. The attached file is the
> output from dmesg just after a freeze occurs. (The pcmcia card eject
> represents me ejecting the wireless card, so that the freeze "thaws"
> and I can capture the output from dmesg).
> 
> Let me know if any additional diagnostics are needed. I have enabled
> MAC80211 debugfs too.

I could not reproduce the freezing with CONFIG_MAC80211_DEFAULT_PS
enabled.  That said, I'm using wireless-testing with a patch for the
scanning state machine (hopefully it will be committed today).

The output of dmesg doesn't show anything interesting.  The stack dump
from the video card is unlikely to be related.

But I think you may be getting something when the freeze happen.  But to
see it, you need to be on a text console.  There are other ways to
capture the kernel messages, which are described in the file
Documentation/oops-tracing.txt in the Linux sources.

-- 
Regards,
Pavel Roskin
