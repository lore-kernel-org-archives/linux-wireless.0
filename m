Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54768 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965979AbZLHUQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 15:16:56 -0500
Received: by ywh36 with SMTP id 36so5772277ywh.15
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 12:17:03 -0800 (PST)
Message-ID: <4B1EB43B.8090806@lwfinger.net>
Date: Tue, 08 Dec 2009 14:16:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to
 suspend' warning
References: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net> <200912081202.04591.mb@bu3sch.de> <200912081341.20682.herton@mandriva.com.br>
In-Reply-To: <200912081341.20682.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2009 09:41 AM, Herton Ronaldo Krzesinski wrote:
> That's why in my last patch I added code to register the radio led, we have to 
> go that way to fix properly the issue (also this way we turn the led on/off only 
> when mac80211 wants it, which is the right way), so we can avoid having to 
> place code in start/stop or creating suspend/resume hooks only because the 
> issue.

I do not understand the reason for adding another LED device, nor why
you think it helps. When I added the LED code, I wanted to get the LED
to indicate that there was I/O activity, which is why I chose the TX
and RX LEDs. Choosing "on" as the default state when there was no
activity and blinking it "off" with I/O seems to give exactly the
right behavior. Unfortunately, the asynchronous behavior of the USB
operations makes it very tricky to get the shutdown right.

Larry

