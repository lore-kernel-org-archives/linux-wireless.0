Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48548 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdLAPpw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 10:45:52 -0500
Message-ID: <1512143142.25588.17.camel@sipsolutions.net> (sfid-20171201_164555_346684_618A4A6A)
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
Date: Fri, 01 Dec 2017 16:45:42 +0100
In-Reply-To: <87d13y31r0.fsf@toke.dk> (sfid-20171201_162958_526202_5A4E3A79)
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
         <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
         <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com>
         <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk>
         <87bmjjzppd.fsf@kamboji.qca.qualcomm.com>
         <5080a68538fd2d883e15bacaa969661b@codeaurora.org> <87r2se36rq.fsf@toke.dk>
         <87k1y6y04i.fsf@kamboji.qca.qualcomm.com> <87d13y31r0.fsf@toke.dk>
         (sfid-20171201_162958_526202_5A4E3A79)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-01 at 16:29 +0100, Toke Høiland-Jørgensen wrote:
> 
> Yeah, figures. Well, maybe we'll just have to support an asynchronous
> callback into mac80211 to register airtime usage. Will probably have to
> add some asynchronicity anyway to avoid doing too much work in the fast
> path.

I really think we should have that anyway. In fact, perhaps we should
just enforce it that way? Then ath9k would have to do a bit more work,
but it's also the slower of the devices :-)

But this plays in with the whole multi-queue RX we discussed before.

johannes
