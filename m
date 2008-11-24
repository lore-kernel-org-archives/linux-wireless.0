Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35151 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYKXXMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 18:12:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 15:12:12 -0800
Date: Mon, 24 Nov 2008 15:12:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Richard Farina <sidhayn@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-regdb: flaw in general functionality
Message-ID: <20081124231204.GN6245@tesla> (sfid-20081125_001217_270868_1E1BADC1)
References: <492B2B74.7040404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <492B2B74.7040404@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 02:32:20PM -0800, Richard Farina wrote:
> First of all I would like to say that the entire idea and function
> behind crda is vastly improved from the old regulatory settings hard
> coded in the kernel.  In light of this, however, we all seem to be
> avoiding a very clear part of reality.
> 
> crda and the regulatory database restrain the channels that a person can
> legally transmit on based on their (presumed) current regulatory
> legislation.  Unfortunately, when I learned about radios I was taught
> that radios can RECEIVE as well as transmit.  In fact, in the USA (the
> country I live in and hence where I am most familiar with the laws) it
> is 100% legal to monitor any frequency that you desire.  crda clearly
> misses that fact and doesn't permit proper legal operation of the radio
> device.
> 
> crda and the regulatory database should be modified so that I can use my
> cards in the legal manner prescribed by the FCC (my regulatory body here
> in the USA).

The reguluatory database is designed with 802.11 in mind, its database
also provides enablement on frequency, not disablement. By default
cfg80211 disallows everything except what is listed for the current
regulatory domain being used.

Your point about not being able to listen is a good one, and a patch to
update the the US in consideration of part 15 rules would be
appreciated. Keep in mind we have flags for such things:

  -Passive scan
  -No-IBSS

We should probably rename no-ibss to no-beaconing though as that is the
real meaning inention behind it. 

  Luis
