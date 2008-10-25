Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40853 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYJYN4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 09:56:03 -0400
Date: Sat, 25 Oct 2008 09:55:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: why differnet wlan drivers need different settings?
Message-ID: <20081025135512.GG19057@tuxdriver.com> (sfid-20081025_155613_054762_9AD4EDF1)
References: <200810251153.25533.bug-track@fisher-privat.net> <200810251303.35295.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810251303.35295.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 25, 2008 at 01:03:34PM +0200, Rafael J. Wysocki wrote:
> On Saturday, 25 of October 2008, Alexey Fisher wrote:
> > May be this is the wrong plase to ask. 
> 
> Yeah, better ask that on linux-wireless@vger.kernel.org (CCed).
> 
> > The question is: Why differnet wlan drivers use different settings to stay 
> > silent - powered on but not trying to associate to any accespoint?
> > For example: ipw2200 - if wlan was connfigured like:
> > 
> > iwconfig wlan1 essid "my-ap" chan 6 ap my:aps:mac ?key s:pass
> > 
> > this will normaly connect to my secure ?AP. and if i set after this:
> > ?
> > iwconfig wlan1 essid off ap off
> > 
> > it will connect to unsecure AP of my neighbour or of Dr.Evil :)
> > to disable association on ipw2200 i need to set all this and plus "chan 0".
> > With this cnowleg i want to set up iwl3945, and surprise it's not working. 
> > This driver do not accepted "chan 0" and instead of "essid off" it did 
> > "essid """
> > 
> > Are there any unified way to keep adapter powered on but not trying to 
> > associate to some AP?

That is from the bad-ole-days.  I could be wrong, but AFAIK only the
ipw2x00 drivers do that anyway.  I recently merged a patch to change
the default for that for ipw2200 into wireless-testing.  We should
probably have one for ipw2100 as well.

Anyway, there are module options for those.  Add "options ipw2200
associate=0" to /etc/modprobe.conf.

Hth!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
