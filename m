Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYLQSZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 13:25:43 -0500
Subject: Re: [PATCH v2 1/3] cfg80211: add PM hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	mabbaswireless@gmail.com
In-Reply-To: <20081217153524.GA3539@tuxdriver.com>
References: <1229313039-5544-2-git-send-email-me@bobcopeland.com>
	 <20081217153524.GA3539@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 19:10:49 +0100
Message-Id: <1229537449.4268.10.camel@localhost> (sfid-20081217_192546_086837_D1335A46)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-17 at 10:35 -0500, John W. Linville wrote:
> On Sun, Dec 14, 2008 at 10:50:37PM -0500, Bob Copeland wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > 
> > This should help implement suspend/resume in mac80211, these
> > hooks will be run before the device is suspended and after it
> > resumes. Therefore, they can touch the hardware as much as
> > they want to.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Is cfg80211 the right place for these?  Is it likely that any
> non-mac80211 users of cfg80211 will ever want to use these hooks?

That's a good question. But even if non-mac80211 won't use this, I don't
see how to get notifications in mac80211 w/o involving cfg80211, since
mac80211 doesn't really have a way to get at the ops there without this,
does it?

johannes

