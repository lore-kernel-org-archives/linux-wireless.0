Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3JBQHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 12:07:34 -0400
Message-ID: <1380730039.13329.27.camel@jlt4.sipsolutions.net> (sfid-20131002_180737_805065_1463F0D1)
Subject: Re: [PATCH 2/4] nl80211/cfg80211: enable DFS for IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Oct 2013 18:07:19 +0200
In-Reply-To: <20131002124006.GA23903@pandem0nium>
References: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1378230201-25446-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1380625757.14430.22.camel@jlt4.sipsolutions.net>
	 <20131002124006.GA23903@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-02 at 14:40 +0200, Simon Wunderlich wrote:

> > > NL80211_ATTR_CONTROL_PORT_DFS attribute when joining the IBSS.
> > 
> > I don't like that name, it makes no sense. This has nothing to do with
> > the port control (802.1X-style) at all.
> 
> How about NL80211_ATTR_DFS_CAPABLE instead?

That seems also confusing, like a hardware capability or something...

Maybe rather "NL80211_ATTR_HANDLE_DFS" or something?

> Yeah, I should document this a little more: Userspace should react to
> radar events and apprioately switch the channel when this happens. As
> non-capable tools (like wpa_supplicant in it's current state) do not
> react on radar events but might select DFS channels when available, there
> might be non-conforming behaviour. Therefore I'm introducing this flag.
> 
> Userspace programs are supposed to set this flag when they have channel
> management and radar avoidance/channel change functionality is implemented
> to unlock DFS channels.

I think we may we want some safeguard, e.g. only give the userspace a
second or so to react and tear down the IBSS otherwise? Even with
userspace that is capable of handling it, it could have crashed and the
IBSS will continue operating in that case since we don't tear down the
IBSS when it crashes. Or we could do that, require userspace to keep the
nl80211 socket open, but the timing seems easier?

> I can resend the patchset with some more documentation on this.

Thanks.

johannes

