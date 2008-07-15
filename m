Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:24886 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544AbYGOFwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 01:52:01 -0400
Received: by ti-out-0910.google.com with SMTP id b6so2504142tic.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 22:51:57 -0700 (PDT)
Message-ID: <a8e1da0807142251p14324917w62d751bed5a56b92@mail.gmail.com> (sfid-20080715_075220_752010_881B5573)
Date: Tue, 15 Jul 2008 13:51:56 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Mattias Nissler" <mattias.nissler@gmx.de>
Subject: Re: mac80211 : WARN at net/mac80211/rate.h:153
Cc: "Michael Buesch" <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>
In-Reply-To: <1216055849.4435.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080714075010.GA3559@darkstar> <200807141614.51628.mb@bu3sch.de>
	 <1216055849.4435.7.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 1:17 AM, Mattias Nissler <mattias.nissler@gmx.de> wrote:
> On Mon, 2008-07-14 at 16:14 +0200, Michael Buesch wrote:
>> CCing PID guys.
>> I've seen several people hitting this. What's the meaning of this warning?
>
> It basically means the rate control cannot find any rate in
> local->hw.wiphy->bands[local->hw.conf.channel->band] that is supported
> by the sta in question. Normally this should not happen. I guess the
> reason is that the supported rates bits in the sta info are all zero,
> which would probably be a bug. I haven't seen this here, but I don't use
> the IBSS code either. To further investigate this, you could the
> following just before the WARN_ON:
>
> printk(KERN_DEBUG "supported rates bitmask: %08x\n",
>        sta->supp_rates[sband->band]);

Yes, as you said, I get:

supported rates bitmask: 00000000

>
> Mattias
>
>



-- 
Regards
dave
