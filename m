Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:27985 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYKQRIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 12:08:16 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1053975yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 09:08:15 -0800 (PST)
Message-ID: <b6c5339f0811170908u2f5eb552jbc23cd50871186df@mail.gmail.com> (sfid-20081117_180822_305132_359FBB7B)
Date: Mon, 17 Nov 2008 12:08:14 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Cc: "John Linville" <linville@tuxdriver.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226915999.3599.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226915999.3599.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 4:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I think, therefore, that we should take a step back, remove it
> entirely for now and add the small feature it provided properly.
> For suspend and resume we will need to introduce new hooks, and for
> the case where the firmware was reset the driver will probably
> simply just pretend it has done a suspend/resume cycle to get
> mac80211 to reprogram the hardware completely, not just try to
> connect to the current AP again in station mode. When doing so, we
> will need to take into account locking issues and possibly defer
> to schedule_work from within mac80211 for the resume operation,
> while the suspend operation must be done directly.

I have proto-patches for suspend/resume that I still need to post -- I
haven't done so yet because, well, it's still a long way from working,
and I back-burnered it a bit.  I'll try to pull them together and post
them just for science.

In them, ieee80211_notify_mac is a minor implementation detail so any hook
back into the mac layer (ieee80211_suspend/ieee80211_resume e.g.) would be
fine with me.  So I think this is OK.

Deferring stuff in resume until later sounds like a good plan, there can
be lots of surprising stuff there (e.g. I didn't see this yet in any
drivers, but if someone happens to request_firmware in ->start() and
there is no userspace yet, uh oh...)

-- 
Bob Copeland %% www.bobcopeland.com
