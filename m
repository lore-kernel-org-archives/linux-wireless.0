Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:27270 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783AbZLGUI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 15:08:29 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1221503eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 12:08:35 -0800 (PST)
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
Subject: Re: [RFT] ar9170: AP broadcast buffering
References: <200911290206.07784.chunkeey@googlemail.com>
	<4B1BF68D.8060907@web.de> <200912071736.40929.chunkeey@googlemail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 07 Dec 2009 22:08:32 +0200
In-Reply-To: <200912071736.40929.chunkeey@googlemail.com> (Christian Lamparter's message of "Mon\, 7 Dec 2009 17\:36\:40 +0100")
Message-ID: <87aaxu4ke7.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> Now the problem is that under traffic the BC/MC frames might
> be delayed in the tx_pending queues and don't make it in time.

I don't know what time constraints you refer to here, but clients
should stay awake until they have received a multicast/broadcast
message with the moredata bit disabled. So, in theory, it doesn't
matter even if the frames are transmitted even 20 ms after the beacon.
(In practise some hardware might have timers for this, I think at
least wl1251 had one.)

Of course the downside is the increased power consumption. But it's
still better than to not receive the multicast/broadcast frames at all :)

-- 
Kalle Valo
