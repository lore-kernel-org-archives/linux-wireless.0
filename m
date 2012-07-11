Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55267 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab2GKQzR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 12:55:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Sp0C3-0002eL-I7
	for linux-wireless@vger.kernel.org; Wed, 11 Jul 2012 18:55:15 +0200
Received: from 83.101.52.162 ([83.101.52.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 18:55:15 +0200
Received: from not0read0765 by 83.101.52.162 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 18:55:15 +0200
To: linux-wireless@vger.kernel.org
From: Olive <not0read0765@yopmail.com>
Subject: Re: rt73usb not working since linux 3.4
Date: Wed, 11 Jul 2012 18:50:26 +0200
Message-ID: <20120711185026.657d7786@yopmail.com> (sfid-20120711_185522_107030_7DEE9CC0)
References: <1364831.ftJE0YjeaD@proton>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Jun 2012 18:03:56 +0200
Andreas Messer <andi@bastelmap.de> wrote:

> Dear all,
> 
> updating my pc from linux kernel 3.3 to linux kernel 3.4 broke my
> wlan. I'm using rt2571 based wlan module from qcom: LR802UKG, which
> is wired to an internal usb port of my media center pc. The rfkill
> switch is hardwired to make wlan active all the time. This setup is
> (almost) properly working since about three years now. (If i ignore
> the occasional vendor_request_error things)
> When I use kernel 3.4., i get a lot of additional devices reported by
> the kernel - three leds and a rfkill switch which have not been there
> before. (or at least I did not notice them) The wlan device now
> refuses to go online, saying that the kill switch is active, which of
> course can not be as it is working with linux kernel 3.3.
> Furthermore, the driver reports three leds, but my wlan device has
> only one, so probably a bad eeprom? i dont know... Anyway, I noticed,
> that when I set the radio led to brightness 255, which takes a lot of
> time and gives me some vendor_request_errors, the rfkill switch gets
> turned off (sys/class/rfkill/../hard = 0). Unfortunately, this
> doesn't help to bring the interface online: After doing that I get
> frequent vendor_request_failed messages, even the PC becomes stuck on
> shutdown. (Probably NetworkManager waiting for something...) So, what
> can I do to track down the problem?
> 
> Cheers,
> Andreas

I have the same problem with a rt73usb too and with the
kernel 3.4.4-2-ARCH (Archlinux). The solution was to recompile the
kernel with the option CONFIG_RFKILL unset (really unset not as a
module). Then everything works properly (exept you cannot disable it
with rfkill). I did not had this problem before the kernel 3.4 (but I do
not know if rfkill actually works, or if the wlan was always enabled).

Olive

