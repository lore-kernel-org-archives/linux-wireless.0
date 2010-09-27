Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34501 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0I0TEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 15:04:13 -0400
Received: by gyd8 with SMTP id 8so1624064gyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:04:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285613669.4043.27.camel@jlt3.sipsolutions.net>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
 <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
 <1285611630.4043.26.camel@jlt3.sipsolutions.net> <AANLkTin+1-_RA8fY8B5-omQi3kMJ3U0iw8Kdg=FC2rnP@mail.gmail.com>
 <1285613669.4043.27.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 12:03:52 -0700
Message-ID: <AANLkTimmZZiMbtA-8m69grwV_v95KcGKRQi6=-fz0JuT@mail.gmail.com>
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 11:54 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-09-27 at 11:49 -0700, Luis R. Rodriguez wrote:
>
>> >> I don't get what we are doing with these frames today, are you saying
>> >> we pegged some of these frames into the reorder buffer when starting a
>> >> sw scan, or that we were dropping them?
>
>> yeah, I was thinking about the release reorder buffer and its
>> respective timeout, I thought that's what the subject of this patch
>> was about.
>
> So I got confused by your question ...
>
> We put them into the reorder buffer, but if we get a reorder timeout
> while scanning we'll drop the frames which isn't necessary.

Ah, got it, thanks, good catch. Guess its not a terrible stable fix,
but at least important for those who care about VoIP and such.

  Luis
