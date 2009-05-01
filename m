Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64588 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZEAFpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 01:45:12 -0400
Received: by fxm2 with SMTP id 2so2189946fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2009 22:45:10 -0700 (PDT)
To: Jamie Lentin <jm@lentin.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Chances of WPA with at76c505a-rfmd2958
References: <alpine.DEB.1.10.0904301926090.24512@woodchuck.wormnet.eu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 01 May 2009 08:45:08 +0300
In-Reply-To: <alpine.DEB.1.10.0904301926090.24512@woodchuck.wormnet.eu> (Jamie Lentin's message of "Thu\, 30 Apr 2009 19\:49\:50 +0100 \(BST\)")
Message-ID: <87r5z99y1n.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jamie Lentin <jm@lentin.co.uk> writes:

> Hi,

Hello,

> I've got this chip within my OQO 01+, generally the driver seems very
> stable (thankyou for your work!), 

Which driver? There is at76c50x-usb (using mac80211) and at76_usb in
staging (which is going away sometime in the future). Because
at76c50x-usb is the path forward, I will omit at76_usb here.

> however when trying to use WPA with the chip the association
> conversation fails.

Yes, at76c50x-usb doesn't support WPA right now.

> Of course, I can provide the logs from both the device and hostapd on
> the other end, but suspect that the answer will fall into one of the
> categories:-
>
> (a) Be patient!  Test it once I've said the driver supports it.
>
> (b) Go off and try and implement x, y and z, see what happens.
>
> (c) Not a chance with this chip, sorry.  The firmware can't send x, so
> the association won't ever work.
>
> WPA would be very useful for me, so would be glad to help in any way.
> If the answer is (c), ah well, still nice to know though.

The answer is (b). At least some chipsets seem to support WPA. I'm busy
with other projects right now and I don't have time to implement WPA
support, but I can give you hints. I see two ways forward:

1) use mac80211 to encrypt the frames

Currently encryption happens in hardware, but also mac80211 can do it.
And mac80211 sw encryption supports TKIP and AES, so with luck you will
get WPA working with that method. Remove .set_key from at76_ops and see
what happens.

2) enable firmware support for WPA

Milan Plzik had some patches for at76_usb which added WPA firmware
support. The patches are here:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-legacy.git;a=shortlog;h=at76

You can port them for at76c50x-usb and get WPA working. First check that
the WPA firmware supports your device, though.

If you need any help, send email to me and this list. We'll help you as
we can.

-- 
Kalle Valo
