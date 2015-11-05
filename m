Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38368 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965410AbbKEH4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 02:56:50 -0500
Message-ID: <1446710205.2540.1.camel@sipsolutions.net> (sfid-20151105_085653_526922_44270956)
Subject: Re: Configurable scan dwell time?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Nov 2015 08:56:45 +0100
In-Reply-To: <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com> (sfid-20151105_080710_589478_5E61DC5E)
References: <563A9B8C.3060503@candelatech.com>
	 <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com>
	 (sfid-20151105_080710_589478_5E61DC5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-05 at 07:41 +0100, Michal Kazior wrote:
> On 5 November 2015 at 00:58, Ben Greear <greearb@candelatech.com>
> wrote:
> > It looks to me like the channel dwell time when scanning (SW
> > scanning,
> > mac80211)
> > is fixed at 1/9 of a second.  I'd like to make this
> > configurable...is that
> > something
> > that might be welcome upstream?
> > 
> > My plan is to add to the netlink API around starting a scan and
> > allow
> > user-space to
> > configure a dwell time in milliseconds.
> 
> I've actually tried doing something like this some time ago:
> 
>  - http://thread.gmane.org/gmane.linux.kernel.wireless.general/111255
>  - http://thread.gmane.org/gmane.linux.kernel.wireless.general/111251
> 

And as I said back then, I'm rather opposed to this. We risk adding API
that either nobody uses, or that ends up getting used in ways that
weren't intended (say for certain measurements) and then will break
things when scanning is changed in firmware, etc.

Let the scanning be. It's intended to find networks, not really
something else. Piggy-backing survey onto it was mostly a mistake. For
other things, do some more reasonable measurement commands.

johannes
