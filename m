Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53963 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbbA3NES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:04:18 -0500
Message-ID: <1422623054.1919.18.camel@sipsolutions.net> (sfid-20150130_140421_431785_12082A48)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jan 2015 14:04:14 +0100
In-Reply-To: <CA+BoTQkdszYWbNJcV+1dDFsaSJ3aoTuC=ORUMr_aJx7_aQmcqw@mail.gmail.com> (sfid-20150130_140219_266074_71EA76C0)
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	 <1422621903.1919.7.camel@sipsolutions.net>
	 <CA+BoTQkdszYWbNJcV+1dDFsaSJ3aoTuC=ORUMr_aJx7_aQmcqw@mail.gmail.com>
	 (sfid-20150130_140219_266074_71EA76C0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 14:02 +0100, Michal Kazior wrote:

> I recall that at least there's one case where using these helpers is
> impossible: drv_config() which can be called while mac80211 is already
> holding iflist_mtx. ath10k needs to iterate over vifs and issue
> blocking commands sometimes so it can't use atomic/rcu versions
> either.

If you wanted to use it, I wouldn't be averse to adding a locked version
that can only be used inside a few of such callbacks. With appropriate
lockdep warnings that would be safe enough, I think.

johannes

