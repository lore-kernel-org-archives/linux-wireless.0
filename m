Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:62868 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbZK1VJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 16:09:40 -0500
Received: by ewy7 with SMTP id 7so2994087ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 13:09:46 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: annotate sleeping driver ops
References: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi>
	<200911282200.28477.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 28 Nov 2009 23:09:44 +0200
In-Reply-To: <200911282200.28477.mb@bu3sch.de> (Michael Buesch's message of "Sat\, 28 Nov 2009 22\:00\:26 +0100")
Message-ID: <871vji8ig7.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> On Saturday 28 November 2009 21:19:26 Kalle Valo wrote:
>> mac80211 doesn't seem to use get_tx_stats anywhere currently. Just to be on
>> the safe side, I documented it to be atomic, but hopefully the op can be
>> removed in the future.
>
> Well, b43 takes a mutex in that callback. I think that's OK, because if it's
> never called, it's pretty safe to sleep there. ;)

Yeah, it should be safe. And I'm planning to remove this code anyway,
see the other thread I started.

-- 
Kalle Valo
