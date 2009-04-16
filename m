Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:4590 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZDPCjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 22:39:33 -0400
Received: by fg-out-1718.google.com with SMTP id 16so729926fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 19:39:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49e644a4.3DqmSbwccrtRsayP%Larry.Finger@lwfinger.net>
References: <49e644a4.3DqmSbwccrtRsayP%Larry.Finger@lwfinger.net>
Date: Thu, 16 Apr 2009 03:39:31 +0100
Message-ID: <3ace41890904151939gf8cce84x54a34407f3ab575@mail.gmail.com> (sfid-20090416_043943_509522_679D5321)
Subject: Re: [RFT/RFC V3] rtl8187: Implement TX/RX blink for LED
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 9:33 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The following patch implements some control over the LED on RTL8187B and
> RTL8187L devices. Triggers are registered for TX and RX. Whenever the
> trigger event occurs, the LED is turned off for 1/20 second, then turned
> back on.
>
> Note: For those RTL8187X devices that are built into the computer and have
> a LED that is expected to be controlled with a radio switch, this patch will
> not operate that LED. That will take a separate patch to be prepared later.
>
> Please test and comment.
>
> The behavior described above is found for my Level One RTL8187B. Prior to this
> patch, the LED was on continuously. On a Netgear WG111V2 RTL8187L, the LED
> blinks erratically. Before the patch, the LED was off.
>
> If you test, please report the status of the LED before and after applying the
> patch. In addition, find the line that looks like "rtl8187: Customer ID 0x00" in
> the dmesg output and report it. I also need to know if you have a B or L model.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Just checking it does nothing other than outputting these lines on my
hardware, as expected.
rtl8187: Customer ID is 0x04
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx
