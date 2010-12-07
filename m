Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0LGPzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:55:00 -0500
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, pstew@google.com, stable@kernel.org
In-Reply-To: <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
	 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
	 <1291714709.3607.2.camel@jlt3.sipsolutions.net>
	 <AANLkTikrLweKeSR-=XziaJ5rqDRf_Ny=mg1OD=jC4nqA@mail.gmail.com>
	 <1291736887.3607.47.camel@jlt3.sipsolutions.net>
	 <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 16:54:58 +0100
Message-ID: <1291737298.3607.48.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 07:51 -0800, Luis R. Rodriguez wrote:

> >> >>       drv_stop(local);
> >> >> +     ieee80211_recalc_idle_force(local);

> > Because you can't call into drivers after you stop them? Shouldn't this
> > be obvious?
> 
> That makes sense, but mac80211 is the one who tells the driver when
> its idle or non-idle, if we stop the device do we want it to handle an
> idle check itself? This change would only force out an idle change
> notification, nothing else.

I don't get what you're saying at all. Can you look at the code lines I
quoted again?

johannes

