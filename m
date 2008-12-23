Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:23661 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYLWWwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 17:52:41 -0500
Subject: Re: p54: ad-hoc mode doesn't work
From: Pavel Roskin <proski@gnu.org>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200812230132.21839.rossi.f@inwind.it>
References: <200812230132.21839.rossi.f@inwind.it>
Content-Type: text/plain
Date: Tue, 23 Dec 2008 17:52:38 -0500
Message-Id: <1230072758.5692.2.camel@dv> (sfid-20081223_235246_803394_B1FDF8C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-23 at 01:32 +0100, Fabio Rossi wrote:
> I was trying to test the ad-hoc mode with my wireless nic (p54 driver, latest 
> wireless-testing git) but I get the following error result:
> 
> # iwconfig wlan0 mode ad-hoc
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlan0 ; Operation not supported.
> 
> The documentation page on linuxwireless.org states that the ad-hoc mode should 
> be supported: what's wrong?

I think you need to install crda:
http://wireless.kernel.org/en/developers/Regulatory/CRDA

Once CRDA is installed, use "iw" to set your regulatory domain.  Without
CRDA, the kernel uses very conservative rules that don't allow beaconing
and thus the ad-hoc mode.

-- 
Regards,
Pavel Roskin
