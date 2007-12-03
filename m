Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:57999 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752208AbXLCL7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:59:21 -0500
Date: Mon, 3 Dec 2007 12:54:02 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071203125402.76562f26@morte> (sfid-20071203_115923_327620_000288F2)
In-Reply-To: <1196679780.7470.9.camel@localhost>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 03 Dec 2007 12:03:00 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Wait a sec. Rate control is per station, so each AP will have it's own
> rate control state.

Ah, right. So fixing the related TODO may make sense.

> Have you tried shorter sample intervals? Currently, it's once per
> second. I plan to shorten it, maybe to 2Hz or even 4Hz and see whether
> we can get better responsiveness and still stay stable. Also, the
> integration time needs to be fine-tuned then.

Well, the integration and control times are just fine. I mean, you can tune
them, but I wouldn't expect the result to be very different. I just think we
need some intervention when exceptional events occur. But if you decide to
fix that TODO, considering association an exceptional event wouldn't make
sense any longer. I've seen improvements after interpolation cycles too,
though.

> I also thought about your rate <-> failed frames table. I'm not
> convinced this works, because I cannot see a way to obtain consistent
> values for the table. Clearly, measuring table entries should be done
> with equal interference conditions for all entries, and they must also
> be adjusted over time. However, if we only collect data during normal
> operation, we'll likely have good data only for the few recent rates we
> were operating at.

Yes, that's exactly what I meant.


-- 
Ciao
Stefano
