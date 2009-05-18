Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:45197 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZERTAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 15:00:09 -0400
Received: by bwz22 with SMTP id 22so3392759bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 12:00:09 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: some wireless suspend thoughts
References: <1242397016.5799.102.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 18 May 2009 22:00:06 +0300
In-Reply-To: <1242397016.5799.102.camel@johannes.local> (Johannes Berg's message of "Fri\, 15 May 2009 16\:16\:56 +0200")
Message-ID: <87pre69qyx.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>  * kick pci driver suspend/resume out of ath9k and keep the device in
>    low power while unused
>  * make mac80211 send nullfunc for suspend/resume
>  * make cfg80211 always call suspend/resume
>
> This is quite hackish. It works for me, but my AP disassocs me anyway
> because it probes every 5 seconds and if you don't respond ... however,
> due to the nullfunc at resume time we notice very very quickly since it
> sends a deauth as a response to that.

To me trying to maintain association during suspend sounds wrong. What
do we gain from that? 

In my opinion it's better to disassociate during suspend and let user
space reassociate during resume. That way no need to do any special
hacks and functionality is the same with all APs.

I'm sure I'm missing a lot here, but this is my first impression.

-- 
Kalle Valo
