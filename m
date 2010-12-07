Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36204 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab0LGK3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 05:29:07 -0500
Received: by mail-bw0-f45.google.com with SMTP id 16so11706385bwz.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 02:29:06 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] cfg80211: Make NL80211_CMD_SET_REG synchronous
Date: Tue, 7 Dec 2010 11:27:55 +0100
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <1291715126-7652-1-git-send-email-helmut.schaa@googlemail.com> <1291715582.3607.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291715582.3607.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012071127.55852.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 7. Dezember 2010 schrieb Johannes Berg:
> On Tue, 2010-12-07 at 10:45 +0100, Helmut Schaa wrote:
> > A user space caller of NL80211_CMD_SET_REG previously had no chance to
> > verify if the regulatory domain change it requested already happened.
> > Listening to NL80211_CMD_REG_CHANGE is not enough since it won't be
> > triggered when the regulatory domain didn't change (for example because
> > it was already the same before).
> > 
> > Fix this by making NL80211_CMD_SET_REG synchronous by adding a
> > completion struct to the regulatory_hint_user function and wait for the
> > completion of the regulatory request before returning.
> 
> Way too complicated. regulatory_hint_user() is called in a context that
> can sleep, obviously, so you can just make it call something like
> run_regulatory_request() that will cancel_work_sync(reg_work) and call
> reg_todo() after queueing, instead of schedule_work(reg_work)  -- that
> way when it returns all things have been processed.

Sounds good, but that would also change the other calls to regulatory_hint_user
(regulatory_init & restore_regulatory_settings), not just the netlink command
from user space. Not sure if it is reasoable to wait for these callers as well?

Second, since reg_process_pending_hints and reg_process_pending_hints are mutex
protected we wouldn't even have to to call cancel_work_sync to ensure
serialization.

Helmut
