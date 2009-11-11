Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60001 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbZKKCfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 21:35:14 -0500
Received: by ewy3 with SMTP id 3so740960ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 18:35:18 -0800 (PST)
Message-ID: <4AFA22DF.8060907@lwfinger.net>
Date: Tue, 10 Nov 2009 20:35:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Monnier <monnier@iro.umontreal.ca>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187se locks up when switching network
References: <jwvljidrhm3.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
In-Reply-To: <jwvljidrhm3.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2009 07:25 PM, Stefan Monnier wrote:
> I've just dine a few more tests, and switching network works just fine
> if I "modprobe -r rtl8187se" and then "modprobe rth8187se" between the
> disconnect and the reconnect, but otherwise the system almost always
> hangs during the connection to the other network.  The way it hangs is
> always the same: everything just freezes and 2 of the status
> leds blink.  The exact moment at which the freeze takes place seems to
> vary: sometimes it's while getting the IP address, other times its
> earlier.

Do you mean that the "Caps Lock" and "num lock" LEDs are blinking? If so, that
is a kernel panic. You will be able to capture some information about that crash
by switching to the logging console (CTRL-ALT-F10) just after you initiate the
process that causes the crash.

> IIUC this driver is not under active development, but maybe someone
> knows it enough to try and fix it, or maybe there's some alternative
> driver for this card that I should try?

The vendor driver in staging is not really under active development. We are
currently writing a mainline driver that uses mac80211 from the vendor code. Of
course, it is not possible to predict when this driver will be ready.

Larry
