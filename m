Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx38.mail.ru ([94.100.176.52]:54224 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468AbZINWzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 18:55:24 -0400
Subject: Re: A station can't reconnect after it wakes up
From: Igor Perminov <igor.perminov@inbox.ru>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Jouni Malinen <j@w1.fi>, Artur Skawina <art.08.09@gmail.com>
In-Reply-To: <200909141431.31091.hs4233@mail.mn-solutions.de>
References: <1248969930.29068.224.camel@sunlight>
	 <87my4z0w53.fsf@litku.valot.fi> <1252927472.26765.202.camel@sunlight>
	 <200909141431.31091.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 02:55:24 +0400
Message-Id: <1252968924.26765.294.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-09-14 at 14:31 +0200, Holger Schurig wrote:
> > 4. The STA device wakes up and begins 
> > authentication with an Auth frame as it hasn't been
> > authenticated/associated previously.
> 
> What's the status of the PS bit of this Auth Frame?

The PS bit of the Auth frame indicates that the STA is under power.
And mac80211 checks the PS bit in data frames only, but not in
management ones.

> Does the station here send a NULL func packet with the "I'm under 
> power again" bit?   It might be necessary to do this via a 
> null-func packet towards some broken APs.

No, it doesn't send. The station works under Windows Mobile 6, and I
can't change its implementation. Contrary, I'm working on making a
Linux/hostapd AP non-broken.

Igor


