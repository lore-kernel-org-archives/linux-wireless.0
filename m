Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:52775 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0AXMhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 07:37:40 -0500
Received: by ewy26 with SMTP id 26so1138508ewy.28
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 04:37:37 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
Subject: Re: hwtkip hangs on b43
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
	<201001232000.07229.mb@bu3sch.de> <4B5B4E9F.8040708@lwfinger.net>
	<201001232038.55204.mb@bu3sch.de> <4B5BE16E.7080901@lwfinger.net>
	<1264332771.23766.24.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 24 Jan 2010 14:37:35 +0200
In-Reply-To: <1264332771.23766.24.camel@johannes.local> (Johannes Berg's message of "Sun\, 24 Jan 2010 12\:32\:50 +0100")
Message-ID: <871vhfptkg.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> >>> We can just remove the lock and add a comment explaining why it is not locked...
>
> Mind you, it won't work on SDIO hardware since the callback cannot
> sleep, contrary to what Kalle documented :(

Oh, sorry about that. Back then I tried to be careful and I checked
the context few calls up. But I didn't check far enough and realise
that all RX code is inside rcu critical section.

I'll send a patch to fix this shortly.

> Why is it not giving everybody warnings in might_sleep()?

Very good question. We should get warnings from both iwlwifi and b43,
but I have no idea why we haven't heard anything.

-- 
Kalle Valo
