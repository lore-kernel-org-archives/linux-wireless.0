Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:52245 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYLSJVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 04:21:52 -0500
Received: by yx-out-2324.google.com with SMTP id 8so324352yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 01:21:51 -0800 (PST)
Message-ID: <a32f33a40812190121t5d669e9ao93c971494dd529a1@mail.gmail.com> (sfid-20081219_102159_296608_B62E6E13)
Date: Fri, 19 Dec 2008 10:21:50 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [PATCH v6 3/3] mac80211: implement dynamic power save
Cc: "Vivek Natarajan" <vivek.natraj@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87myesy5ey.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081218213306.7248.64398.stgit@tikku>
	 <20081218213527.7248.65697.stgit@tikku>
	 <8e92b4100812182217q6f8e6014s3f28ab79c5bc2ba3@mail.gmail.com>
	 <87myesy5ey.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI,

>> I need your thoughts on having null frame being sent from mac80211(
>> the RFC I submitted earlier). Do you feel a state machine is
>> necessary to go to power save? ( like awake, sleep, pending_sleep if
>> the AP hasn't acked the null frame with a timer or a work queue to
>> send null frame periodically in the pending state).
>
> I haven't thinked much about this yet, but your proposal of having a
> state machine most probably is the best option. It's just that earlier
> Johannes mentioned that it's not currently possible to know if null
> frame has been acked:
>
> http://www.spinics.net/lists/linux-wireless/msg21212.html
>
> We would have to solve that before implementing the state machine.
>
>> Or altogether you want that to be part of the driver and not in
>> mac80211?
>
> I think this needs to be in mac80211 because there are three drivers
> which need it (p54/stlc45xx, ath5/9k and b43).

You can add the rt2x00 family to that list as well, I have already a patch
which implements power saving in rt2x00 but it will need this patch to get
it working correctly.

Ivo
