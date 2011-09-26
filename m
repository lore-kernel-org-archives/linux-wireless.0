Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56907 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1IZWbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 18:31:01 -0400
Received: by qyk7 with SMTP id 7so7136932qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 15:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110922154849.369194760@sipsolutions.net>
References: <20110922154726.521122680@sipsolutions.net> <20110922154849.369194760@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 26 Sep 2011 15:30:40 -0700
Message-ID: <CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com> (sfid-20110927_003105_618484_4E28FC39)
Subject: Re: [RFC 03/15] mac80211: also expire filtered frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 22, 2011 at 8:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> mac80211 will expire normal PS-buffered frames, but
> if the device rejected some frames for a sleeping
> station, these won't be on the ps_tx_buf queue but
> on the tx_filtered queue instead; this is done to
> avoid reordering.
>
> However, mac80211 will not expire frames from the
> filtered queue, let's fix that.
>
> Also add a more comments to what all this expiry is
> doing and how it works.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

No particular comments on the code yet but latency issues has got me
thinking about the filtered frames stuff and if we really need it. How
much benefit does keeping these frames give us instead of just
dropping them?

  Luis
