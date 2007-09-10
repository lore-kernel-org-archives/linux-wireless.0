Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39709
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXIJLBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 07:01:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd-mac80211: Fix TX status reports.
Date: Mon, 10 Sep 2007 12:58:39 +0200
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200709082341.31720.mb@bu3sch.de> <200709091259.00237.mb@bu3sch.de> <1189421542.4506.46.camel@johannes.berg>
In-Reply-To: <1189421542.4506.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200709101258.39619.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 September 2007 12:52:21 Johannes Berg wrote:
> On Sun, 2007-09-09 at 12:58 +0200, Michael Buesch wrote:
> 
> > Basically, the TX status report is only useful for the rate control
> > algorithm. So it's basically "only" statistics. But we have to
> > get these statistics approximately right to get the RC algo working
> > correctly. That is what this patch does. With it, the RC algo properly
> > scales up and down if the signal gets better or worse.
> 
> Michael, this is unfortunately not true. At least hostapd relies on the
> ack callback because it requires stations to acknowledge the association
> response before advancing the state machine, and we have also made
> monitoring outgoing packets depend on the ack callback.

I think the ack callback is pretty reliable, so that should be OK.
It looks for the ACK in software.

-- 
Greetings Michael.
