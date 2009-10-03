Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:63399 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZJCL3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2009 07:29:46 -0400
Received: by fg-out-1718.google.com with SMTP id 22so694363fge.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2009 04:29:49 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Malte Gell <malte.gell@gmx.de>, Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Sat, 3 Oct 2009 13:29:46 +0200
Cc: linux-wireless@vger.kernel.org
References: <200910011654.10963.chunkeey@googlemail.com> <200910022108.15155.chunkeey@googlemail.com> <200910030453.42131.malte.gell@gmx.de>
In-Reply-To: <200910030453.42131.malte.gell@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910031329.47123.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 03 October 2009 04:53:41 Malte Gell wrote:
> Christian Lamparter <chunkeey@googlemail.com> wrote
> > If you take a look at the ledtriggers values in /sys/call/leds/
> > "none rfkill0 phy0rx phy0tx [phy0assoc] phy0radio",
> > you instantly see that the phyXname trigger is dynamic.
> 
> Can I change the link(s) there at any time
yes, you can change then any time you want.

> or will the ar9170usb change it again?
no, the setting stays. But of course,
it will be gone if the module is reloaded, or
the device has been replugged.
  
> > in my opinion, finding a simple udev rule is harder than simply
> > modify the driver code :-D.
> 
> That's true! I just had to exchange the words "tx" with "assoc" 
> in the driver,  whereas a udev rule is complicated!
well, there's at least one upside: this rule could be easily
modified to work with different wireless drivers.

by the way: Could you please do me a flavour (since you are
the only WN111 v2 owner I know) and tell us what "hwtype"
result you get with Joerg Albert's patch: 

http://marc.info/?l=linux-wireless&m=125452461322729&q=raw

Regards,
	Chr
