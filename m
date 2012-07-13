Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40026 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2GMMB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 08:01:59 -0400
Received: by lbbgm6 with SMTP id gm6so5717528lbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 05:01:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
References: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
Date: Fri, 13 Jul 2012 14:01:57 +0200
Message-ID: <CA+icZUVs-XMjWhuUE8-8+nyVADw-GRrMGp8=VfRj2F_2H42FLw@mail.gmail.com> (sfid-20120713_140202_909767_94675BE0)
Subject: Re: [PATCH 0/3] cfg80211/mac80211 channel fixes
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 13, 2012 at 1:58 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Ok so the last series worked but wasn't really good. I realized
> that even for normal multi-channel operation we're going to need
> get_channel() since otherwise we don't know the channel *type*
> that the interface is using (e.g. in managed mode) since the AP
> is no real indication of it as we might decide to not use HT40
> or whatever...
>
> So instead of just reverting the get_channel removal, I'm adding
> it back now with an interface argument. Nothing much changes for
> mac80211, but in the future I'll adjust the cfg80211 channel
> tracking code to make use of it so that it'll be required for
> multi-channel (or the code will have to assume incompatibility.)
>
> This series fixes the monitor mode problems and I've committed
> them (but haven't pushed, in case somebody finds errors.)
>

For what tree is this? -next aka 3.6 material?

- Sedat -

> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
