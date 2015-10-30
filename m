Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57445 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758617AbbJ3JeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:34:04 -0400
Message-ID: <1446197640.3261.15.camel@sipsolutions.net> (sfid-20151030_103408_126713_F3470B76)
Subject: Re: [PATCH 1/2] cfg80211: Add support for aborting an ongoing scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt <usdutt@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	vkanchan@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Fri, 30 Oct 2015 10:34:00 +0100
In-Reply-To: <1446104804-8312-1-git-send-email-usdutt@qti.qualcomm.com>
References: <1446104804-8312-1-git-send-email-usdutt@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>   *
> + * @NL80211_CMD_ABORT_SCAN: stop an ongoing scan. Returns -ENOENT if a scan is
> + *	not running.


I think we might need to indicate in nl80211 exported capabilities
whether or not this command is available?

The return code requirement should probably also be documented in
cfg80211.h, and the fact that you get a scan-done message should be
here as well.

Or is that not necessary - i.e. no relevant races are possible - and
the function return can be void?

johannes
