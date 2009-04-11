Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:48115 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZDKQgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 12:36:51 -0400
Message-ID: <49E0C713.4040507@lwfinger.net> (sfid-20090411_183655_375711_C78006FE)
Date: Sat, 11 Apr 2009 11:36:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>	 <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>	 <49DE7E42.5020700@lwfinger.net>	 <3ace41890904102123o3e280edau933c8235649879c5@mail.gmail.com> <3ace41890904102129n2b62001clff35027088bedcd1@mail.gmail.com>
In-Reply-To: <3ace41890904102129n2b62001clff35027088bedcd1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> On Sat, Apr 11, 2009 at 5:23 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> 
> Oh, I forgot to mention that to test this code against
> compat-wireless, appending "CONFIG_RTL8187_LEDS=y" to config.mk does
> the job.
> 
> I am wonder if we actually needs an extra Kconfig for this - at least
> in my case, the code has no ill effect with device which hasn't got an
> RX/TX LED. (other than possibly a small theoretical performance loss
> from do extra non-useful work).

I do have to compile the LED code only if the kernel has support for them,
otherwise the registration entry points would be missing. The necessary
conditions would be more complicated, thus I put them in one place in the
Kconfig and let the source only be dependent on CONFIG_RTL8187_LEDS.

Larry


