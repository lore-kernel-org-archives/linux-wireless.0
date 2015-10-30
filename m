Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58108 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776AbbJ3K6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 06:58:19 -0400
Message-ID: <1446202696.3261.24.camel@sipsolutions.net> (sfid-20151030_115822_395732_29184AC2)
Subject: Re: [PATCH 1/2] cfg80211: Add support for aborting an ongoing scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Sunil Dutt <usdutt@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, vkanchan@qti.qualcomm.com,
	amarnath@qca.qualcomm.com
Date: Fri, 30 Oct 2015 11:58:16 +0100
In-Reply-To: <20151030103703.GA6731@jouni.qca.qualcomm.com>
References: <1446104804-8312-1-git-send-email-usdutt@qti.qualcomm.com>
	 <1446197640.3261.15.camel@sipsolutions.net>
	 <20151030103703.GA6731@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-30 at 12:37 +0200, Jouni Malinen wrote:
> 
> The currently identified use cases do not seem to care much about the
> actual result of this command since there is going to be a wait for 
> the
> scan completed event anyway and the call is not even used unless 
> there
> is a known ongoing scan. As such, even the difference of a driver
> supporting this command or not is not that significant taken into
> account this is used only as an optimization to speed up the 
> following
> operation when a long scan operation was in progress. Things work 
> fine
> (though without that speed benefit) even if the driver does not
> support this. Anyway, making cfg80211 advertise whether the new 
> command
> is available could obviously be done should someone come up with a 
> use
> case that depends on knowing that the optimization is available.
> 

Fair point. In that case though, making the driver operation void would
make sense.

johannes
