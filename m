Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37342 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbbAWPea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 10:34:30 -0500
Message-ID: <1422027267.2728.39.camel@sipsolutions.net> (sfid-20150123_163433_636509_0CD19919)
Subject: Re: [RFC iw next] phy: Allow set netns by fd
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 16:34:27 +0100
In-Reply-To: <1422026027-5806-1-git-send-email-vadim4j@gmail.com> (sfid-20150123_162433_668129_A5F1E60F)
References: <1422026027-5806-1-git-send-email-vadim4j@gmail.com>
	 (sfid-20150123_162433_668129_A5F1E60F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-23 at 17:13 +0200, Vadim Kochan wrote:
> From: Vadim Kochan <vadim4j@gmail.com>
> 
> Added possibility to change network namespace
> for phy device by network namespace name from
> /var/run/netns or by absolute file path:
> 
>     iw phy XXX set netns <nsname> | <pid>
> 
> First iw tries to find given nsname from /var/run/netns
> or by absoute path (in case if nsname contains "/") and if
> it failed to open nsname file then iw uses given argument as <pid>.

Hmm. I think it'd be better to do something like

iw phy XXX set netns name <nsname>

That way there's no way it can be a valid PID.

Otherwise, if you happen to have a file in your local directory that's
the name of the PID you want, weird things happen.

> Also added missing NL80211 attributes before NL80211_CMD_SET_WIPHY_NETNS.

Please don't - I'll update nl80211.h by copying as needed.

johannes

