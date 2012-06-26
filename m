Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45594 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2FZUXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:23:34 -0400
Date: Tue, 26 Jun 2012 15:05:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Juho-Mikko Pellinen <juho-mikko.pellinen@iki.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Kernel Oops with 3.5-rc4 and zd1211rw (regression)
Message-ID: <20120626190506.GC32503@tuxdriver.com> (sfid-20120626_222354_776669_F7204F01)
References: <4FE9FC2C.6040205@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FE9FC2C.6040205@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 09:15:08PM +0300, Juho-Mikko Pellinen wrote:
> Hi!
> 
> I just got this kernel oops the first time I compiled and booted 3.5-rc4
> . Oops message: http://i.imgur.com/oyIhy.jpg
> 3.4.x-series work just fine.
> 
> The Oops happens when I log in to gdm. At that time Network Manager is
> already up and connected to network because I can ssh to the computer.
> Naturally after the crash wlan goes down and the computer is unreachable.
> 
> The zd1211rw is an usb network card. I have also wlan card with the chip
> 'rtl8192ce' installed, but not activated because I'm experiencing
> problems with it.
> 
> Attached are lspci, lsusb and dmesg from kernel 3.4.3.
> I will investigate later on the possibility of setting up netconsole and
> logging dmesg just before the crash.
> 
>    -Juho-Mikko Pellinen

I noticed that you are using CONFIG_CFG80211_INTERNAL_REGDB, but you
have an empty db.txt file.  Please turn-off that option and install
a proper CRDA setup.  Alternatively, at least give it an up-to-date
db.txt file to use for regulatory rules.

You are getting a lot of CR_REG1 timeouts from your zd1211rw device.
Are you certain that the device is still functioning properly?

The zd1211rw driver isn't exactly changing rapidly.  I do see that
commit e1f12eb6ba6f1e74007eb01ed26fad7c5239d62b touches it.  You might
try reverting that one?  And, of course, you could try to do a git
bisect between 3.4 and 3.5-rc4 -- as a Gentoo user, I'm sure you are
up to the task! :-)

Does any of that move the ball for us?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
