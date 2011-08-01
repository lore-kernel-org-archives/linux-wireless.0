Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63152 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1HACce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 22:32:34 -0400
Received: by vws1 with SMTP id 1so4135244vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 19:32:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ8GFOgmsVyeGqYhfMoS+qPVx5cp53C94hr=GL0wPYUwQH5zwg@mail.gmail.com>
References: <CAJ8GFOg4A4JwC8qdF6e7rRCRETnfrPm5Zv60_8Cm1xpbJJNQpg@mail.gmail.com>
	<201107312112.55357.chunkeey@googlemail.com>
	<CAJ8GFOgmsVyeGqYhfMoS+qPVx5cp53C94hr=GL0wPYUwQH5zwg@mail.gmail.com>
Date: Mon, 1 Aug 2011 10:32:34 +0800
Message-ID: <CAJ-VmongjbU80_VXAajrEAdt5ZZCWRtZrO3b1zKcEEH=nWqQTw@mail.gmail.com> (sfid-20110801_043245_819015_30A130D5)
Subject: Re: carl9170: How do I change value of retries for long packets?
From: Adrian Chadd <adrian@freebsd.org>
To: Harshal Chhaya <harshal@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 August 2011 10:29, Harshal Chhaya <harshal@gmail.com> wrote:


>>> However, I did find some very helpful information in the debug files
>>> in 'debugfs' including the number of retries.
>>> The current value is 4 for long packets and 7 for short packets.
>> I don't think that the term "short packets" is what you think it is. :D
>
> From what I understand, short packets are smaller than the
> RTSThreshold and long packets are larger than that value. Since my
> RTSThreshold is undefined, I imagine all my data packets are 'long
> packets'.

If it's even peripherally related to the Atheros MAC terminology, then
that's the number of RTS retries and then entire packet retries.

Ie:

* short would be "how many times to try sending an RTS, expecting to
hear an CTS in response but not hearing it."
* long would be "how many times to try sending the whole packet,
expecting an ACK in response, but not hearing it."



Adrian
