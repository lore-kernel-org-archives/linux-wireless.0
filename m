Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:64012 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbXGHOA4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 10:00:56 -0400
Date: Sun, 8 Jul 2007 16:00:54 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Andy Green <andy@warmcat.com>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
Message-ID: <20070708140054.GA28113@deine-taler.de>
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org> <468E5C33.2000102@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <468E5C33.2000102@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-06 16:13 Andy Green wrote:

> Daniel Drake wrote:
> > Andy Green wrote:
> >> Second is a small patch for zd1211rw-mac80211 that fixes rate reporting
> >> on radiotap rx, last sent here 11 June.
> >>
> >> http://www.spinics.net/lists/linux-wireless/msg02897.html
> ...
> > Are we really sure we need another rate conversion function? there are
> > already a couple in the mac80211 driver, and one or 2 extra (for RTS/CTS
> > rate programming) in the softmac driver.
> 

I have created a commit (24b5500dc) in my Git tree that
implements Andy's patch. I didn't introduce a new rate conversion
function, but changed only zd_rx_rate(). The function is only used
for filling the ieee80211_rx_status structure.

I have added also some more cleanup patches. One of them changes
the name of all the struct ieee80211_hw pointers from dev to hw.
The structure isn't a device and this has confused me more then
once. I also renamed related functions accordingly. (John, these
patches still need review by Daniel and should not be merged into
wireless-dev right now.) I also removed fill_rt_header(). It
caused a unused function warning and is not needed anymore.

You can find my zd1211rw-dev branch here:

http://deine-taler.de/git-bin/gitweb.cgi?p=zd1211rw.git;a=shortlog;h=zd1211rw-dev

and also under

git://deine-taler.de/git/zd1211rw.git

-- 
Uli Kunitz
