Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45581 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2FZUXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:23:32 -0400
Date: Tue, 26 Jun 2012 13:18:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andreas Messer <andi@bastelmap.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt73usb not working since linux 3.4
Message-ID: <20120626171835.GB32503@tuxdriver.com> (sfid-20120626_222337_467574_0C98A1F1)
References: <1364831.ftJE0YjeaD@proton>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364831.ftJE0YjeaD@proton>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 06:03:56PM +0200, Andreas Messer wrote:
> Dear all,
> 
> updating my pc from linux kernel 3.3 to linux kernel 3.4 broke my wlan. I'm 
> using rt2571 based wlan module from qcom: LR802UKG, which is wired to an 
> internal usb port of my media center pc. The rfkill switch is hardwired to 
> make wlan active all the time. This setup is (almost) properly working since 
> about three years now. (If i ignore the occasional vendor_request_error 
> things)
> When I use kernel 3.4., i get a lot of additional devices reported by the 
> kernel - three leds and a rfkill switch which have not been there before. (or 
> at least I did not notice them) The wlan device now refuses to go online, 
> saying that the kill switch is active, which of course can not be as it is 
> working with linux kernel 3.3. Furthermore, the driver reports three leds, but 
> my wlan device has only one, so probably a bad eeprom? i dont know...
> Anyway, I noticed, that when I set the radio led to brightness 255, which 
> takes a lot of time and gives me some vendor_request_errors, the rfkill switch 
> gets turned off (sys/class/rfkill/../hard = 0). Unfortunately, this doesn't 
> help to bring the interface online: After doing that I get frequent 
> vendor_request_failed messages, even the PC becomes stuck on shutdown. 
> (Probably NetworkManager waiting for something...)
> So, what can I do to track down the problem?

Andreas,

Hmmm...well, perhaps you can start by doing a git bisect to narrow-down
the commit that started this problem for you?  It may take serveral
iterations, if you can only narrow it down to 3.3 working and 3.4 not
working.  But, at least that should point us in the right direction.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
