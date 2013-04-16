Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965416Ab3DPVno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 17:43:44 -0400
Message-ID: <1366148618.8244.35.camel@jlt4.sipsolutions.net> (sfid-20130416_234348_027138_AFDC9385)
Subject: Re: [PATCH V6] cfg80211: introduce critical protocol indication
 from user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 16 Apr 2013 23:43:38 +0200
In-Reply-To: <516DC04D.9090204@broadcom.com>
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
	 <1365676794-24717-1-git-send-email-arend@broadcom.com>
	 <1366121523.8244.23.camel@jlt4.sipsolutions.net>
	 <516DC04D.9090204@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-16 at 23:19 +0200, Arend van Spriel wrote:
> >> +	NL80211_CMD_CRIT_PROTOCOL_START,
> >> +	NL80211_CMD_CRIT_PROTOCOL_STOP,
> >> +	NL80211_CMD_CRIT_PROTOCOL_STOPPED_EVENT,
> >
> > Why use a separate command ID? Usually we use the same _STOP for the
> > event as well, I think? Except maybe scan which you can't stop? Not
> > sure ... Anyway I don't mind, just wondering if there was a special
> > reason to do this.
> >
> 
> This is my first nl80211 event :-) I looked at the ft_event thingy. I am 
> fine using the _STOP instead.

Ah, but that didn't have a command. I'd just use _STOP in this case.

> >> + nla_put_failure:
> >> +	if (hdr)
> >> +		genlmsg_cancel(msg, hdr);
> >
> > There's not really a reason to cancel, but we still do most of the time.
> > I guess we can keep it, but it doesn't matter :)
> 
> If it not really needed it may call for separate patch removing all 
> occurrences?

Yeah, agree.

> >>   	trace_rdev_return_void(&rdev->wiphy);
> >> -}					$
> >> +}$
> >
> > Heh, thanks.
> 
> Have to thank my editor, I guess. Trailing whitespace?

Plenty (see the $ signs I just inserted)

johannes

