Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbbIDRsQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 13:48:16 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<1441032517.13980.21.camel@sipsolutions.net>
	<wrfjmvx73u0l.fsf@redhat.com>
	<1441120044.2441.9.camel@sipsolutions.net>
	<wrfj4mjcqn3x.fsf@redhat.com>
	<1441275442.2565.17.camel@sipsolutions.net>
Date: Fri, 04 Sep 2015 13:48:13 -0400
In-Reply-To: <1441275442.2565.17.camel@sipsolutions.net> (Johannes Berg's
	message of "Thu, 03 Sep 2015 12:17:22 +0200")
Message-ID: <wrfjr3megjoi.fsf@redhat.com> (sfid-20150904_194820_110007_EF2D5594)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Wed, 2015-09-02 at 21:59 -0400, Jes Sorensen wrote:
>> 
>> The code mimics what the vendor driver does - part of the bringup of the
>> chip sets a bunch of parameters from an register value array. Rather
>> than guessing what their default is, I feel it's safer to just shut 
>> it down here and stick with that.
>
> Ok, fair enough. Might be worth putting that into start() rather than
> add_interface() though? Anyway, it's not a big deal, I just wasn't sure
> if that was intentional.

OK, I'll probably just leave it there for now then.

>> > I'd be extremely surprised if any of this worked - perhaps you're 
>> > not advertising A-MPDU support (yet)?
>> > 
>> > You're not calling ieee80211_start_tx_ba_cb_irqsafe() or
>> > ieee80211_stop_tx_ba_cb_irqsafe(), so this can't really work. The
>> > session might be set up but will never actually start.
>> > 
>> > That said, the code also looks incomplete. Perhaps better to just
>> > remove it entirely for now?
>> 
>> I started working on this, but I guess I didn't finish it. One thing I
>> haven't figured out yet is why I see AMPDU_RX_START events, but I never
>> see AMPDU_TX_START events show in the log.
>
> Nothing in your system is calling ieee80211_start_tx_ba_session() then.

Gotcha, now you mention it, that rings a bell! I'll put that on my todo
list. One of the biggest things puzzling me is how much the firmware
does with AMPDU - there is a break bit I can set in the TX descriptor to
say 'don't AMPDU this packet' but do not actually know if it will do all
of this behind my back. I need to dig more into the vendor driver (and
their 80211 stack) to see if I can figure that out.

Cheers,
Jes


