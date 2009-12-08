Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:45730 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966166AbZLHU5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 15:57:50 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to suspend' warning
Date: Tue, 8 Dec 2009 18:57:49 -0200
Cc: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net> <200912081341.20682.herton@mandriva.com.br> <4B1EB43B.8090806@lwfinger.net>
In-Reply-To: <4B1EB43B.8090806@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912081857.49661.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Ter 08 Dez 2009, às 18:16:59, Larry Finger escreveu:
> On 12/08/2009 09:41 AM, Herton Ronaldo Krzesinski wrote:
> > That's why in my last patch I added code to register the radio led, we
> > have to go that way to fix properly the issue (also this way we turn the
> > led on/off only when mac80211 wants it, which is the right way), so we
> > can avoid having to place code in start/stop or creating suspend/resume
> > hooks only because the issue.
> 
> I do not understand the reason for adding another LED device, nor why
> you think it helps. When I added the LED code, I wanted to get the LED
> to indicate that there was I/O activity, which is why I chose the TX
> and RX LEDs. Choosing "on" as the default state when there was no
> activity and blinking it "off" with I/O seems to give exactly the
> right behavior. Unfortunately, the asynchronous behavior of the USB
> operations makes it very tricky to get the shutdown right.

It's because without registering a radio led the current behaviour is wrong 
for some cases, the led stays on when it shouldn't. For example, if you bring 
the interface down (ifconfig <if> down) the led stays on, when it shouldn't. 
The led should only be active while interface is active, between start and 
stop (or in other words, the radio is on). After mac80211 stops the device, 
any i/o (led activity) shouldn't happen.

> 
> Larry

--
[]'s
Herton
