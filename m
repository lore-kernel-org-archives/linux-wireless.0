Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35500 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZG3QIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:08:25 -0400
Received: by qyk34 with SMTP id 34so892564qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 09:08:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907301752.23855.mb@bu3sch.de>
References: <200907301631.50780.mb@bu3sch.de>
	 <b6c5339f0907300745l3e7ec63eu9819503c4e7766bb@mail.gmail.com>
	 <1248968229.16129.9.camel@johannes.local>
	 <200907301752.23855.mb@bu3sch.de>
Date: Thu, 30 Jul 2009 12:08:25 -0400
Message-ID: <b6c5339f0907300908t6a5cc64dy7a5b776595f0da69@mail.gmail.com>
Subject: Re: Ath5k/mac80211 triggers WARN_ON in kernel/softirq.c
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 11:52 AM, Michael Buesch<mb@bu3sch.de> wrote:
>> John, can you revert the BH patch ("mac80211: do not use irq locks where
>> not necessary") and I'll send a new one with those changes removed?
>
> I didn't look at the code, but can't we simply request the beacon from
> mac80211 before locking? Or isn't the spin_lock_irqsave() done in the driver?
>

We could drop the lock around it, but it'd be nice to keep the option
open here.  For example, some people want to move the beacon tasklet
into the hard IRQ - in that case the driver would have to jump through
a lot of hoops to refresh the beacon.

-- 
Bob Copeland %% www.bobcopeland.com
