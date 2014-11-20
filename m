Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47875 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTPWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 10:22:08 -0500
Message-ID: <1416496922.8557.7.camel@sipsolutions.net> (sfid-20141120_162212_668350_F9270085)
Subject: Re: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy specific
 regd info
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Date: Thu, 20 Nov 2014 16:22:02 +0100
In-Reply-To: <CA+XVXfeqfHHDh6AcgkuBW9BwUo-s77+pnbDtP_y=e0dZQVBitg@mail.gmail.com> (sfid-20141116_120711_380898_244AC3F5)
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
	 <1415895219-19848-4-git-send-email-arik@wizery.com>
	 <20141113231323.GG24486@wotan.suse.de>
	 <CA+XVXfeqfHHDh6AcgkuBW9BwUo-s77+pnbDtP_y=e0dZQVBitg@mail.gmail.com>
	 (sfid-20141116_120711_380898_244AC3F5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-11-16 at 13:06 +0200, Arik Nemtsov wrote:

> We intend to add a patch to wpa_s to always add the wiphy_idx to
> NL80211_CMD_GET_REG. With the current approach only drivers with
> SELF_MANAGED_REG will get wiphy->regd back. This is ok since these are
> new drivers, which are familiar with this API.
> 
> But if we use your suggestion and always return wiphy->regd, then some
> driver like ath9k that uses regulatory_hint() will now get it's
> private regd returned to the wpa_s that manages it. I'm not saying
> it's necessarily bad, but it's different than what was returned
> before. The cfg80211 regdomain is intersected with wiphy->regd, so now
> ath9k will start getting more permissive channels in usermode.
> 
> So we thought it's best to enable the new behavior only if the driver
> explicitly wants it, using a new regulatory flag.

How does this work the other way around - i.e. a newer wpa_s requesting
per-wiphy information but it not being present?

It seems to me that either way what the kernel should return is the
information that will actually be applied when validated, which is of
course not possible when there are wiphy-specific regdomains and a
global one is requested (unless there's just one wiphy, which might be
something to consider making work?)

I also don't actually see a driver regulatory flag in this patch, as
expected, so not sure what exactly you're talking about above?

johannes

