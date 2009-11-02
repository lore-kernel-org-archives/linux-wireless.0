Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:48575 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbZKBQm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 11:42:29 -0500
Received: by iwn10 with SMTP id 10so3435159iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 08:42:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257165123.3555.185.camel@johannes.local>
References: <1257165123.3555.185.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Nov 2009 08:42:14 -0800
Message-ID: <43e72e890911020842v5a4c5129t6ffd3779a08328fc@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: validate scan channels
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 2, 2009 at 4:32 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Currently it is possible to request a scan on only
> disabled channels, which could be problematic for
> some drivers. Reject such scans, and also ignore
> disabled channels that are given. This resuls in
> the scan begin/end event only including channels
> that are actually used.
>
> This makes the mac80211 check for disabled channels
> superfluous. At the same time, remove the no-IBSS
> check from mac80211 -- nothing says that we should
> not find any networks on channels that cannot be
> used for an IBSS, even when operating in IBSS mode.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Side note that this patch reminds me of.

About two days ago I noticed that if my internal card enables channel
12 as its world roaming, I connect to my AP on channel 12 (therefore
lifting the passive scan flag), and if I then connect a USB device
which disables channel 12 communication will still go on on channel 12
on the old card but the channel will still have been marked as
disabled.

I figured I'd not here that we currently can trash these types of
connections because as noted with this patch we'd disable scanning --
but we only degrade the connection, we don't do something sensible. So
when we get a chance we should force a disconnect if a channel we're
using all of a sudden becomes disabled.

  Luis
