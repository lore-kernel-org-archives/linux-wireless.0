Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2COOG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 10:06:59 -0400
Subject: Re: signal strength in nl80211 and IEEE80211_HW_SIGNAL_UNSPEC
From: Johannes Berg <johannes@sipsolutions.net>
To: Cristian Morales Vega <cristian@samknows.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <CAGUfO+wJd8wdcwzaigV=DYzhCNt8cNtWc4P=MoXJLd9ozHyPjg@mail.gmail.com> (sfid-20120315_145933_601091_9647B8FA)
References: <CAGUfO+wJd8wdcwzaigV=DYzhCNt8cNtWc4P=MoXJLd9ozHyPjg@mail.gmail.com>
	 (sfid-20120315_145933_601091_9647B8FA)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 15:06:57 +0100
Message-ID: <1331820417.3432.16.camel@jlt3.sipsolutions.net> (sfid-20120315_150702_997199_9C292885)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 13:59 +0000, Cristian Morales Vega wrote:
> I don't have a device using a driver with IEEE80211_HW_SIGNAL_UNSPEC
> to test, but because of
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=19deffbeba930030cfaf000b920333c6ba99ad52
> I guess nl80211 will report the NL80211_STA_INFO_SIGNAL even if the
> driver doesn't uses dBm, true?
> Looking at http://permalink.gmane.org/gmane.linux.kernel.wireless.general/24814
> it seems this wasn't wanted. Bug, the check for
> IEEE80211_HW_SIGNAL_DBM is done elsewhere or finally it was decided
> that the signal strength should be reported even if the units are
> unknown?

Huh, yes, the nl80211 reporting here was intended to be dBm as
documented in the header file, so John's commit does look like a bug.
John, can you revert that please? The "unspec" signal strength thing is
used only in NL80211_BSS_SIGNAL_UNSPEC, i.e. the signal strength
reported in scan results. If we want/need it in station information as
well we need to add a separate attribute.

johannes

