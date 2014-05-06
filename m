Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722AbaEFKtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 06:49:10 -0400
Message-ID: <1399373331.4218.22.camel@jlt4.sipsolutions.net> (sfid-20140506_124929_897534_C71D6FDB)
Subject: Re: [PATCH 1/4] cfg80211/nl80211: add channel switch started and
 failed notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	Ilan Peer <ilan.peer@intel.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 06 May 2014 12:48:51 +0200
In-Reply-To: <1399038031-23206-1-git-send-email-luca@coelho.fi>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-02 at 16:40 +0300, Luca Coelho wrote:

> + * @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY: Notify that a channel switch
> + *	has been started on an interface, regardless of the initiator
> + *	(ie. whether it was requested from a remote device or
> + *	initiated on our own).  It indicates that
> + *	%NL80211_ATTR_IFINDEX will be on %NL80211_ATTR_WIPHY_FREQ
> + *	after %NL80211_ATTR_CH_SWITCH_COUNT TBTT's.

You don't seem to have that now, but it may not always be needed, and we
could add it later (unless userspace needs to rely on having the
attribute - otherwise it has to check for it)

Actually though, maybe you do need it, so that you can determine whether
it makes sense to try anything smart - if the count is 1 or you received
an action frame then you probably don't have time at all?

> + * @NL80211_CMD_CH_SWITCH_FAILED_NOTIFY: Notify that a channel switch
> + *	has failed on %NL80211_ATTR_IFINDEX.  This notification can
> + *	only be sent after a @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY has
> + *	been issued.

(+Ilan, Andrei)

I'm not really sure why you have this - it seems that in this case the
interface will be stopped so you'll get a STOP_AP or DISCONNECT or
whatever other notification. This may not actually be completely true
right now (I seem to remember a fix in this area but can't seem to find
it in my tree!!) but we'll have to fix that part anyway. Not really sure
why then that couldn't be used instead of this notification? The
userspace code is going to have to worry about that anyway, I'd think.

johannes

