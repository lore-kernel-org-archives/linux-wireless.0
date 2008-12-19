Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29222 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYLSHpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 02:45:33 -0500
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 3/3] mac80211: implement dynamic power save
References: <20081218213306.7248.64398.stgit@tikku>
	<20081218213527.7248.65697.stgit@tikku>
	<8e92b4100812182217q6f8e6014s3f28ab79c5bc2ba3@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 19 Dec 2008 09:45:25 +0200
In-Reply-To: <8e92b4100812182217q6f8e6014s3f28ab79c5bc2ba3@mail.gmail.com> (ext Vivek Natarajan's message of "Fri\, 19 Dec 2008 11\:47\:59 +0530")
Message-ID: <87myesy5ey.fsf@nokia.com> (sfid-20081219_084537_302242_1D000EB9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> I need your thoughts on having null frame being sent from mac80211(
> the RFC I submitted earlier). Do you feel a state machine is
> necessary to go to power save? ( like awake, sleep, pending_sleep if
> the AP hasn't acked the null frame with a timer or a work queue to
> send null frame periodically in the pending state).

I haven't thinked much about this yet, but your proposal of having a
state machine most probably is the best option. It's just that earlier
Johannes mentioned that it's not currently possible to know if null
frame has been acked:

http://www.spinics.net/lists/linux-wireless/msg21212.html

We would have to solve that before implementing the state machine.

> Or altogether you want that to be part of the driver and not in
> mac80211?

I think this needs to be in mac80211 because there are three drivers
which need it (p54/stlc45xx, ath5/9k and b43).

-- 
Kalle Valo
