Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33099 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbYAQWPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 17:15:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: led support in mac80211 and drivers
Date: Thu, 17 Jan 2008 23:12:59 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Tomas Carnecky <tom@dbservice.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <478DF297.9020904@dbservice.com> <20080116200126.GA3164@tuxdriver.com> <1200584782.8007.59.camel@johannes.berg>
In-Reply-To: <1200584782.8007.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801172313.00246.mb@bu3sch.de> (sfid-20080117_221553_485145_6149B0EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 17 January 2008 16:46:22 Johannes Berg wrote:
> > > > > Actually the major problem I have currently with mac80211 trigger
> > > > > implementation RX/TX trigger since Intel's led doesn't have to be
> > > > > triggered ON/OFF on each packet, led is capable of blinking itself.,
> 
> I'm wondering if this shouldn't simply be a driver decision and mac80211
> exports an RXon LED that is always "on" for as long as receive is
> running (whatever that means, please specify!)

I read this thread multiple times, but I don't get where the problem is.
Why don't you simply implement this in the driver:
When LED didn't change software state for X jiffies, switch the auto-blinking
LED in the hardware off. Switch it on if it's off in hardware and there's
a software state transition.
Where's the problem? This is trivial to implement.

-- 
Greetings Michael.
