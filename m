Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60191 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3LDWQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 17:16:34 -0500
Received: by mail-bk0-f48.google.com with SMTP id v10so6714549bkz.7
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 14:16:33 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: question for mac80211 driver maintainers - RCU usage in drivers
Date: Wed, 04 Dec 2013 23:16:30 +0100
Message-ID: <1409469.QTj73PAUiY@blech> (sfid-20131204_231638_387913_7C4176B9)
In-Reply-To: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wednesday, December 04, 2013 10:30:10 PM Johannes Berg wrote:
> Except for iwlmvm, I don't find much RCU usage wrt. stations in drivers.
carl9170 uses rcu too. (Once there was a nice statistic about rcu
usage by subsystem and drivers, but it somehow disappeared and I
can't find it anymore)

> Is there any other driver that assumes it is safe to delete a station
> pointer in the sta_state callback and not use synchronize_rcu()? From
> looking at the code, I don't see any, but I can't really be sure that
> everyone uses __rcu annotations correctly ... :)
No, carl9170 doesn't use sta_state but it uses sta_remove. 
I'm curious: how you would achieve this feat? After all, mac80211's
tx- and rx-paths currently relies on RCU protected station pointers 
too (and all that goes along with it. e.g.: ampdu sessions, keys, ...)?

> Would anyone object if we changed mac80211 to *immediately* free the
> station after calling the driver's sta_state (or sta_remove) callback?
No objection.

> We currently delay this until after an RCU grace period, but that way we
> end up having a lot of delay in station freeing ... We'd like to
> optimise that.
Regards,

Christian

> PS: I'll probably have to add another callback "sta going away before
> RCU" so you can invalidate pointers there ... otherwise I'd have to
> synchronize_rcu() in iwlmvm which would kinda defeat the purpose.
hm, invalidating ampdu sessions is going to be tricky isn't it?
But ok, some time ago I played around with moving the complicated
amdpu scheduler of carl9170 into the (single-threaded) firmware.
So large parts of carl9170's code which uses rcu in this context would
become "unnecessary".

I didn't merge the patch - since there was no obvious benefit - but
I still have them and they can be revived if needed.
