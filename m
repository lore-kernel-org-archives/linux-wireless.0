Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35526 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbcICKQW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:16:22 -0400
Subject: Re: [PATCH v5] ath9k: Switch to using mac80211 intermediate software
 queues.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20160805160346.10545-1-toke@toke.dk>
 <20160902140030.11798-1-toke@toke.dk>
Cc: Tim Shepard <shep@alum.mit.edu>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <df0e8117-68cf-b318-cb71-c450b0598eb3@nbd.name> (sfid-20160903_121626_533228_82D2963B)
Date: Sat, 3 Sep 2016 12:16:19 +0200
MIME-Version: 1.0
In-Reply-To: <20160902140030.11798-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-02 16:00, Toke Høiland-Jørgensen wrote:
> This switches ath9k over to using the mac80211 intermediate software
> queueing mechanism for data packets. It removes the queueing inside the
> driver, except for the retry queue, and instead pulls from mac80211 when
> a packet is needed. The retry queue is used to store a packet that was
> pulled but can't be sent immediately.
> 
> The old code path in ath_tx_start that would queue packets has been
> removed completely, as has the qlen limit tunables (since there's no
> longer a queue in the driver to limit).
> 
> Based on Tim's original patch set, but reworked quite thoroughly.
> 
> Cc: Tim Shepard <shep@alum.mit.edu>
> Cc: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
You can add:
Signed-off-by: Felix Fietkau <nbd@nbd.name>

- Felix
