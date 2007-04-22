Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXDVWAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2007 18:00:25 -0400
Subject: Re: [PATCH] ieee80211: Output frequency rather than channel  in scan results
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <462A965D.9000708@lwfinger.net>
References: <46298e00.m7oDqYNvDCFdCSj1%Larry.Finger@lwfinger.net>
	 <20070421001253.q449myskosg0sg8k@webmail.spamcop.net>
	 <1177193997.19554.1.camel@localhost.localdomain>
	 <462A965D.9000708@lwfinger.net>
Content-Type: text/plain
Date: Sun, 22 Apr 2007 18:03:32 -0400
Message-Id: <1177279412.21205.23.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-04-21 at 17:55 -0500, Larry Finger wrote:
> Dan Williams wrote:
> > On Sat, 2007-04-21 at 00:12 -0400, Pavel Roskin wrote:
> >> Quoting Larry Finger <Larry.Finger@lwfinger.net>:
> >>
> >>> In ieee80211, the output of scan results lists channels rather than
> >>> frequencies; however, NetworkManager needs frequency. This patch
> >>> changes the output from channel to frequency.
> >> The driver can report both, and I think it should.  This would make the iwlist
> >> output a bit longer, but kernel drivers shouldn't be written to make userspace
> >> program generate pretty output.
> > 
> > I'm trying to remember why NM cares about frequency, and I think it's
> > for ad-hoc mode; but wpa_supplicant didn't historically support a
> > "channel" configuration parameter and so you can't create adhoc networks
> > with NM right now anyway...  What's the failure mode?
> 
> In the KDE NM applet, the frequency is listed as 0.

Haha.  Ok.  NM should be smarter about this and convert channels
returned by the driver into frequencies.  In the end, I prefer
frequencies where at all possible, because channel numbers are _not_
unique (unless you use the the tuple of [standard, band, channel] where
standard is something like "802.11" or "802.16", band is "a" or "bg").

Dan


Dan


