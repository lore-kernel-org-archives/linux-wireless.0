Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53881 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140Ab2COOcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 10:32:14 -0400
Date: Thu, 15 Mar 2012 10:20:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Cristian Morales Vega <cristian@samknows.com>,
	linux-wireless@vger.kernel.org
Subject: Re: signal strength in nl80211 and IEEE80211_HW_SIGNAL_UNSPEC
Message-ID: <20120315142049.GB31717@tuxdriver.com> (sfid-20120315_153219_579805_926D7070)
References: <CAGUfO+wJd8wdcwzaigV=DYzhCNt8cNtWc4P=MoXJLd9ozHyPjg@mail.gmail.com>
 <1331820417.3432.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331820417.3432.16.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 03:06:57PM +0100, Johannes Berg wrote:
> On Thu, 2012-03-15 at 13:59 +0000, Cristian Morales Vega wrote:
> > I don't have a device using a driver with IEEE80211_HW_SIGNAL_UNSPEC
> > to test, but because of
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=19deffbeba930030cfaf000b920333c6ba99ad52
> > I guess nl80211 will report the NL80211_STA_INFO_SIGNAL even if the
> > driver doesn't uses dBm, true?
> > Looking at http://permalink.gmane.org/gmane.linux.kernel.wireless.general/24814
> > it seems this wasn't wanted. Bug, the check for
> > IEEE80211_HW_SIGNAL_DBM is done elsewhere or finally it was decided
> > that the signal strength should be reported even if the units are
> > unknown?
> 
> Huh, yes, the nl80211 reporting here was intended to be dBm as
> documented in the header file, so John's commit does look like a bug.
> John, can you revert that please? The "unspec" signal strength thing is
> used only in NL80211_BSS_SIGNAL_UNSPEC, i.e. the signal strength
> reported in scan results. If we want/need it in station information as
> well we need to add a separate attribute.

Well, that commit fixes this bug:

	https://bugzilla.kernel.org/show_bug.cgi?id=14763

sta_set_sinfo is called by ieee80211_get_station, which gets invoked
by cfg80211_wireless_stats when handling SIOCGIWSTATS ioctls.
Without that commit, devices that use IEEE80211_HW_SIGNAL_UNSPEC
report a 0 signal strength through wext.

So, how do we fix this and keep wext working for those devices?
For that matter, what actual bug is it causing?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
