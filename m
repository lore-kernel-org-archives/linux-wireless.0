Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59313 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752368AbdLAP3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 10:29:44 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "akolli\@codeaurora.org" <akolli@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "linux-wireless-owner\@vger.kernel.org"
        <linux-wireless-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
In-Reply-To: <87k1y6y04i.fsf@kamboji.qca.qualcomm.com>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com> <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com> <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com> <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk> <87bmjjzppd.fsf@kamboji.qca.qualcomm.com> <5080a68538fd2d883e15bacaa969661b@codeaurora.org> <87r2se36rq.fsf@toke.dk> <87k1y6y04i.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 01 Dec 2017 16:29:39 +0100
Message-ID: <87d13y31r0.fsf@toke.dk> (sfid-20171201_162958_526202_5A4E3A79)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>>> tx_duration is aggregate time duration of 4 PPDU sent to STA.
>>> FW sends these values for retry packets also.
>>
>> Great, that sounds like just what we need.
>
> Except mapping to the iee80211_tx_status() might be difficult. I'm not
> sure how HTT_T2H_MSG_TYPE_PKTLOG events are sent in relation to
> HTT_T2H_MSG_TYPE_TX_COMPL_IND.

Yeah, figures. Well, maybe we'll just have to support an asynchronous
callback into mac80211 to register airtime usage. Will probably have to
add some asynchronicity anyway to avoid doing too much work in the fast
path.

Will keep that in mind when I get around to revisiting those patches :)

-Toke
