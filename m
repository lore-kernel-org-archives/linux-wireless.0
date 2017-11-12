Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:38029 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdKLOk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Nov 2017 09:40:27 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>, make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2] ath10k: Re-enable TXQs for all devices
In-Reply-To: <f5540404-f2e0-203a-ee75-daf357f29547@nbd.name>
References: <20171110004839.7478-1-toke@toke.dk> <f5540404-f2e0-203a-ee75-daf357f29547@nbd.name>
Date: Sun, 12 Nov 2017 23:40:12 +0900
Message-ID: <87shdjpnlf.fsf@toke.dk> (sfid-20171112_154031_764601_5AC105C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-11-10 01:48, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Commit 4ca1807815aa6801aaced7fdefa9edacc2521767 disables the use of the
>> mac80211 TXQs for some devices because of a theoretical throughput
>> regression. The original regression report[1] was related to fq_codel
>> qdisc drop performance, which was fixed in
>> 9d18562a227874289fda8ca5d117d8f503f1dcca. Since then, we have not seen
>> the TXQ-related regression, so it should be safe to re-enable TXQs.
> That commit is unrelated to the fq/codel implementations in mac80211,
> since mac80211 with txq does not use qdisc.

Yup. Which is why it's odd that the initial bug report referred to this;
that would indicate that the regression had nothing to do with TXQs in
the first place, and we could have merged this ages ago?

-Toke
