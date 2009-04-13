Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23103.mail.ird.yahoo.com ([217.146.189.43]:34554 "HELO
	web23103.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751689AbZDMTRB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 15:17:01 -0400
Message-ID: <164369.31510.qm@web23103.mail.ird.yahoo.com> (sfid-20090413_211707_248188_667101E7)
Date: Mon, 13 Apr 2009 19:16:58 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFT/RFC V2] rtl8187: Implement TX/RX blink for LED
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Mon, 13/4/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The following patch implements some
> control over the LED on RTL8187B and
> RTL8187L devices. Triggers are registered for TX and RX.
> Whenever the
> trigger event occurs, the LED is turned off for 1/20
> second, then turned
> back on.
> 
> Note: For those RTL8187X devices that are built into the
> computer and have
> a LED that is expected to be controlled with a radio
> switch, this patch will
> not operate that LED. That will take a separate patch to be
> prepared later.
> 
> Please test and comment.
> 
> The behavior described above is found for my Level One
> RTL8187B. Prior to this
> patch, the LED was on continuously. On a Netgear WG111V2
> RTL8187L, the LED
> blinks erratically. Before the patch, the LED was off.
> 
> If you test, please report the status of the LED before and
> after applying the
> patch. In addition, find the line that looks like "rtl8187:
> Customer ID 0x00" in
> the dmesg output and report it. I also need to know if you
> have a B or L model.
> 
> A number of problems with version 1 of this patch have been
> fixed. The most
> important of these was a locking problem that caused the
> RTL8187L to fail.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

I see you have changed to cancel_delayed_work_sync() - that's might be where how it was(?) crashing?

Hin-Tak




      
