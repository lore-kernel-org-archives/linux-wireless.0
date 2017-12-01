Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49568 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdLAP6J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 10:58:09 -0500
Message-ID: <1512143881.25588.18.camel@sipsolutions.net> (sfid-20171201_165835_875429_5C369282)
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "linux-wireless-owner@vger.kernel.org"
        <linux-wireless-owner@vger.kernel.org>
Date: Fri, 01 Dec 2017 16:58:01 +0100
In-Reply-To: <87a7z230m3.fsf@toke.dk>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
         <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
         <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com>
         <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk>
         <87bmjjzppd.fsf@kamboji.qca.qualcomm.com>
         <5080a68538fd2d883e15bacaa969661b@codeaurora.org> <87r2se36rq.fsf@toke.dk>
         <87k1y6y04i.fsf@kamboji.qca.qualcomm.com> <87d13y31r0.fsf@toke.dk>
         <1512143142.25588.17.camel@sipsolutions.net> <87a7z230m3.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-01 at 16:54 +0100, Toke Høiland-Jørgensen wrote:

> I guess that once we have an asynchronous scheduler task of some kind,
> supporting the callback is easy, but pulling the data out of each packet
> needs more work.

Right.


> But since we'll have to do that for ath9k anyway it
> becomes more a question of whether it's something that should be
> supported in mac80211 or if it should be implemented in each driver.
> But since that logic will have to be written from scratch anyway, is
> there any reason to not just do it in mac80211 from the beginning?

I was thinking in the driver so that there's no overhead for the other
drivers that don't want it that way.

Dunno. It probably doesn't really matter.

johannes
