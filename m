Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60132
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbXGGSim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 14:38:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: Errors when firmware is missing
Date: Sat, 7 Jul 2007 20:37:44 +0200
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com> <468FD6B2.6000408@lwfinger.net>
In-Reply-To: <468FD6B2.6000408@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707072037.44582.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 07 July 2007 20:08:50 Larry Finger wrote:
> Jon Smirl wrote:
> > I have a new Broadcom 4318 adapter (which has exactly the same issues
> > with promiscuous mode). I didn't have the right firmware down for it
> > and I received this error message when I did "ifconfig wlan up"
> > SIOCSIFFLAGS: No such file or directory.  This is not the most user
> > friendly error message, but I did receive a log entry.
> 
> If the firmware did not load correctly, the bcm43xx driver logs appropriate messages. This error 
> would have been encountered and logged when the interface was brought up. Is that what you meant 
> when you say that you received a log entry? The ifconfig error message is output by the user code, 
> and is not controlled by any driver.

Well it is. It's -ENOENT, which we return in the driver.
I'd like to return, -ENOFIRMWARE, but there's no such error.
So I selected the most sane error code (to me), which says
file not found...


-- 
Greetings Michael.
