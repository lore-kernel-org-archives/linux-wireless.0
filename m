Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48547 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0EZNaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 09:30:12 -0400
Date: Wed, 26 May 2010 09:28:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Gordon, Charles" <Charles.Gordon@digi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Is there a bug in 2.6.29-rc8 support of Ad-Hoc mode?
Message-ID: <20100526132811.GA5823@tuxdriver.com>
References: <8DCC153EAFE67A4B990A840E829F704B017C658D5E6C@mtk-sms-exch01.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B017C658D5E6C@mtk-sms-exch01.digi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
