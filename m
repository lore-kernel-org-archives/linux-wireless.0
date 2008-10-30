Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:45599 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbYJ3OM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:12:26 -0400
Received: by rv-out-0506.google.com with SMTP id k40so621680rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 07:12:25 -0700 (PDT)
Message-ID: <b6c5339f0810300712p40b79c3r9613989f5af41777@mail.gmail.com> (sfid-20081030_151232_418939_CD40BC73)
Date: Thu, 30 Oct 2008 10:12:25 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] ath5k: badness at net/mac80211/rx.c:2200, status->rate_idx = 255
Cc: ath5k-devel@lists.ath5k.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0810291822g33c0ce4cvc21a2449d8ee5458@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224799927.22806.15.camel@dv>
	 <20081023213333.4t4427vw5ws8ccck-cebfxv@webmail.spamcop.net>
	 <b6c5339f0810241158t59b15861qc9eb05a3f3f032a2@mail.gmail.com>
	 <b6c5339f0810241201r7f8ba34ej6f39a96e371849eb@mail.gmail.com>
	 <1224882332.10804.0.camel@dv>
	 <b6c5339f0810291822g33c0ce4cvc21a2449d8ee5458@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 9:22 PM, Bob Copeland <me@bobcopeland.com> wrote:
> So, any hints on how to reproduce this one?  Seems lots of people are
> hitting it but I haven't seen it yet (though I was working on
> 2.6.27-rc2 up until yesterday).

Nevermind, leaving it on overnight, I got the warning too.  I guess I'll
sprinkle some printks about.

If nothing else, the -1 and u8 stuff is ugly and should probably be fixed,
but it will result in the same warning since rate_idx will be >> n_bitrates.

-- 
Bob Copeland %% www.bobcopeland.com
