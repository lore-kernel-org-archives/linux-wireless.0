Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42386 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbbJ3KhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 06:37:20 -0400
Date: Fri, 30 Oct 2015 12:37:03 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sunil Dutt <usdutt@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <vkanchan@qti.qualcomm.com>,
	<amarnath@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] cfg80211: Add support for aborting an ongoing scan
Message-ID: <20151030103703.GA6731@jouni.qca.qualcomm.com> (sfid-20151030_113729_990653_DFDD8E78)
References: <1446104804-8312-1-git-send-email-usdutt@qti.qualcomm.com>
 <1446197640.3261.15.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1446197640.3261.15.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 10:34:00AM +0100, Johannes Berg wrote:
> > + * @NL80211_CMD_ABORT_SCAN: stop an ongoing scan. Returns -ENOENT if a scan is
> > + *	not running.

> I think we might need to indicate in nl80211 exported capabilities
> whether or not this command is available?
> 
> The return code requirement should probably also be documented in
> cfg80211.h, and the fact that you get a scan-done message should be
> here as well.
> 
> Or is that not necessary - i.e. no relevant races are possible - and
> the function return can be void?

The currently identified use cases do not seem to care much about the
actual result of this command since there is going to be a wait for the
scan completed event anyway and the call is not even used unless there
is a known ongoing scan. As such, even the difference of a driver
supporting this command or not is not that significant taken into
account this is used only as an optimization to speed up the following
operation when a long scan operation was in progress. Things work fine
(though without that speed benefit) even if the driver does not
support this. Anyway, making cfg80211 advertise whether the new command
is available could obviously be done should someone come up with a use
case that depends on knowing that the optimization is available.

The wpa_supplicant patches I'm planning on pushing in as soon as the
nl80211 command ID gets assigned are here:
http://w1.fi/p/scan/

-- 
Jouni Malinen                                            PGP id EFC895FA
