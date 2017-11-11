Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33780 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbdKKNiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Nov 2017 08:38:09 -0500
Subject: Re: [PATCH v2] ath10k: Re-enable TXQs for all devices
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20171110004839.7478-1-toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f5540404-f2e0-203a-ee75-daf357f29547@nbd.name> (sfid-20171111_143812_596244_9BD92034)
Date: Sat, 11 Nov 2017 14:38:06 +0100
MIME-Version: 1.0
In-Reply-To: <20171110004839.7478-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-11-10 01:48, Toke Høiland-Jørgensen wrote:
> Commit 4ca1807815aa6801aaced7fdefa9edacc2521767 disables the use of the
> mac80211 TXQs for some devices because of a theoretical throughput
> regression. The original regression report[1] was related to fq_codel
> qdisc drop performance, which was fixed in
> 9d18562a227874289fda8ca5d117d8f503f1dcca. Since then, we have not seen
> the TXQ-related regression, so it should be safe to re-enable TXQs.
That commit is unrelated to the fq/codel implementations in mac80211,
since mac80211 with txq does not use qdisc.

- Felix
