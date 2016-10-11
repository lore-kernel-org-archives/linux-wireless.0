Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:52991 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbcJKJlp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 05:41:45 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: fix sequence number allocation regression
References: <20161011092831.85565-1-nbd@nbd.name>
Date: Tue, 11 Oct 2016 11:39:58 +0200
In-Reply-To: <20161011092831.85565-1-nbd@nbd.name> (Felix Fietkau's message of
        "Tue, 11 Oct 2016 11:28:31 +0200")
Message-ID: <8760oz4429.fsf@toke.dk> (sfid-20161011_114445_736411_87DB131C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> The recent commit that moved around TX handlers dropped the sequence
> number allocation at the end of ieee80211_tx_dequeue and calls
> ieee80211_tx_h_sequence instead (for the non-fast-xmit case).
> However, it did not change the fast-xmit sequence allocation condition
> in ieee80211_xmit_fast_finish, which skipped seqno alloc if intermediate
> tx queues are being used.
>
> Drop the now obsolete condition.
>
> Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to aft=
er TXQ dequeue")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

(Think this was introduced in the merging of mac80211-next and net-next?)

-Toke
