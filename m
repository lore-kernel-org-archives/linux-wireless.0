Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032130Ab2CPNiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:38:55 -0400
Subject: Re: [RFC 2/3] mac80211: protect ->scanning by mutex in
 ieee80211_work_work()
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120316131644.GB10844@redhat.com>
References: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
	 <1331899378-10543-2-git-send-email-sgruszka@redhat.com>
	 <1331902453.6753.4.camel@jlt3.sipsolutions.net>
	 <20120316131644.GB10844@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 14:38:52 +0100
Message-ID: <1331905132.6753.12.camel@jlt3.sipsolutions.net> (sfid-20120316_143903_107339_AD4561BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 14:16 +0100, Stanislaw Gruszka wrote:
> On Fri, Mar 16, 2012 at 01:54:13PM +0100, Johannes Berg wrote:
> > I don't really see the point in this. It seems that this doesn't really
> > help, you'd actually have to protect all the work stuff here with the
> > mutex so the scanning can also be excluded or so?
> 
> You mean some other work stuff than ieee80211_work_work() ?
> 
> We have almost all ieee80211_work_work() code protected by local->mtx
> already, I just moved local->scanning check after the mutex_lock.

Oh, ok. I thought it wasn't really protected, I guess then this makes
some sense.

johannes

