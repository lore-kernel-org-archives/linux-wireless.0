Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail37.messagelabs.com ([216.82.241.83]:56738 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0EZPIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 11:08:14 -0400
From: "Gordon, Charles" <Charles.Gordon@digi.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 May 2010 10:07:44 -0500
Subject: RE: Is there a bug in 2.6.29-rc8 support of Ad-Hoc mode?
Message-ID: <8DCC153EAFE67A4B990A840E829F704B017C658D5E9F@mtk-sms-exch01.digi.com>
References: <8DCC153EAFE67A4B990A840E829F704B017C658D5E6C@mtk-sms-exch01.digi.com>
 <20100526132811.GA5823@tuxdriver.com>
In-Reply-To: <20100526132811.GA5823@tuxdriver.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Switching to your sequence of commands:

>	ifconfig wlan0 down
>	iwconfig wlan0 mode Ad-Hoc
>	ifconfig wlan0 up
>	iwconfig wlan0 essid "AdHocID"

solves the problem.  

Thanks for the help!



-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com] 
Sent: Wednesday, May 26, 2010 9:28 AM
To: Gordon, Charles
Cc: linux-wireless@vger.kernel.org
Subject: Re: Is there a bug in 2.6.29-rc8 support of Ad-Hoc mode?

On Wed, May 26, 2010 at 06:57:31AM -0500, Gordon, Charles wrote:
> I am trying to get a driver I'm developing to work with Ad-Hoc mode on
> Linux 2.6.29-rc8.  I am running into a problem.  I have traced it down
> to the routine ieee80211_scan_work.  I use the following commands to
> start Ad-Hoc mode:
> 
> ifconfig wlan0 down
> iwconfig wlan0 mode Ad-Hoc essid "AdHocID"
> ifconfig wlan0 up

FWIW, this should probably look more like the following:

	ifconfig wlan0 down
	iwconfig wlan0 mode Ad-Hoc
	ifconfig wlan0 up
	iwconfig wlan0 essid "AdHocID"

If that doesn't work, you may be experiencing some bug.  But...

> Can someone either confirm that this is a known problem with
> 2.6.28-rc8, or tell me what my driver could be doing to cause this
> problem?

This kernel is ancient, even if you meant 2.6.29-rc8 like you
said originally.  And it is not even an actual release version
(e.g. 2.6.29).  I could be wrong, but I doubt there will be much
interest among the people here in working on the internals of such
an old kernel.  Is there some reason you can't try something newer?
2.6.34 was just released...

Good luck!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
