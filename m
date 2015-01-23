Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58500 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbbAWP6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 10:58:25 -0500
Received: by mail-we0-f174.google.com with SMTP id x3so8371743wes.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 07:58:24 -0800 (PST)
Date: Fri, 23 Jan 2015 17:47:31 +0200
From: Vadim Kochan <vadim4j@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vadim Kochan <vadim4j@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC iw next] phy: Allow set netns by fd
Message-ID: <20150123154731.GA9454@angus-think.wlc.globallogic.com> (sfid-20150123_165835_056515_116C6F47)
References: <1422026027-5806-1-git-send-email-vadim4j@gmail.com>
 <1422027267.2728.39.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422027267.2728.39.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 04:34:27PM +0100, Johannes Berg wrote:
> On Fri, 2015-01-23 at 17:13 +0200, Vadim Kochan wrote:
> > From: Vadim Kochan <vadim4j@gmail.com>
> > 
> > Added possibility to change network namespace
> > for phy device by network namespace name from
> > /var/run/netns or by absolute file path:
> > 
> >     iw phy XXX set netns <nsname> | <pid>
> > 
> > First iw tries to find given nsname from /var/run/netns
> > or by absoute path (in case if nsname contains "/") and if
> > it failed to open nsname file then iw uses given argument as <pid>.
> 
> Hmm. I think it'd be better to do something like
> 
> iw phy XXX set netns name <nsname>
> 
> That way there's no way it can be a valid PID.
> 
> Otherwise, if you happen to have a file in your local directory that's
> the name of the PID you want, weird things happen.
> 
> > Also added missing NL80211 attributes before NL80211_CMD_SET_WIPHY_NETNS.
> 
> Please don't - I'll update nl80211.h by copying as needed.
> 
> johannes
> 

OK, just to clarify with nl80211.h - you will update it including new
NL80211_ATTR_NETNS_FD ? If yes - I will wait for this change.

Thanks,
