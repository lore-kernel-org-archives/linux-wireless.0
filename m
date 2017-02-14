Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58510 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbdBNR7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 12:59:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: clean up and fix ath_tx_count_airtime
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170212132931.43510-1-nbd@nbd.name>
References: <20170212132931.43510-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>,
        <toke@toke.dk>
Message-ID: <3744f8f76bc14c0a89c37011762df92b@eusanexr01a.eu.qualcomm.com> (sfid-20170214_185907_740893_1E02C8D0)
Date: Tue, 14 Feb 2017 09:58:57 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> ath_tx_count_airtime is doing a lot of unnecessary work:
> 
> - Redundant station lookup
> - Redundant rcu_read_lock/unlock
> - Useless memcpy of bf->rates
> - Useless NULL check of bf->bf_mpdu
> - Redundant lookup of the skb tid
> 
> Additionally, it tries to look up the mac80211 queue index from the txq,
> which fails if the frame was delivered via the power save queue.
> 
> This patch fixes all of these issues by passing down the right set of
> pointers instead of doing extra work
> 
> Cc: stable@vger.kernel.org
> Fixes: 63fefa050477 ("ath9k: Introduce airtime fairness scheduling between stations")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>

Patch applied to ath-next branch of ath.git, thanks.

a6e56d749f1b ath9k: clean up and fix ath_tx_count_airtime

-- 
https://patchwork.kernel.org/patch/9568369/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
