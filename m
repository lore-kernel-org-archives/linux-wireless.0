Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:25032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZDKEX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 00:23:59 -0400
Received: by fg-out-1718.google.com with SMTP id e12so413572fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2009 21:23:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DE7E42.5020700@lwfinger.net>
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
	 <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>
	 <49DE7E42.5020700@lwfinger.net>
Date: Sat, 11 Apr 2009 05:23:56 +0100
Message-ID: <3ace41890904102123o3e280edau933c8235649879c5@mail.gmail.com> (sfid-20090411_062404_926909_02C0A342)
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 10, 2009 at 12:01 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:

> I take it that your device is built in. If it works with the hardware switch,
> then we need a "radio" LED and the rfkill subsystem. I won't be able to test
> that configuration, but I will try to spin that code, but I'll do it separately
> from the TX/RX LEDs.

I just gave your patch against compat-wireless, and there isn't any
noticeable effect other than
these three lines in dmesg - which at least shows that the new code is active:

rtl8187: Customer ID 0x4
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx

Since I don't have the Tx/Rx LEDs (my device is
OEM/on-board/built-in), this is expected.
Also, note that my Customer is one of invalid value that's not
documented - I guess you can add a comment in
with 0x04 is found on built-in OEM device on toshiba laptops, just for
completeness.
One day we might want to distinguish 0x4 from the default treatment,
you never know.

Oh, also can you change that from 0x%X to 0x%02X ? I just like hex
numbers to have even number of digits.

Actually that code is slightly ambiguous/misleading - the printfk
customer id is bit-masked for the lower 8-bit, but the actual decision
itself is based on the full 16-bit value read off the register. It is
possible for the dmesg customer id to show one of the special values
in dmesg and yet and code path goes to the default: case, due to
non-zero higher 8-bit.

Hmm, I went back to check the vendor driver code, its decision is
based on the lower 8-bit only, so you should either do a reg &=0xFF
right after read, or do "switch(reg &0xFF) {}", just in case there is
garbage in the upper 8-bit...
