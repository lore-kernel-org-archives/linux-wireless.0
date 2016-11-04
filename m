Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:53107 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934176AbcKDLwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 07:52:46 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/3] mac80211: update A-MPDU flag on tx dequeue
References: <20161104092754.91649-1-nbd@nbd.name>
Date: Fri, 04 Nov 2016 12:46:16 +0100
In-Reply-To: <20161104092754.91649-1-nbd@nbd.name> (Felix Fietkau's message of
        "Fri, 4 Nov 2016 10:27:52 +0100")
Message-ID: <8760o3ead3.fsf@toke.dk> (sfid-20161104_125251_667718_A55C3F50)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> The sequence number counter is used to derive the starting sequence
> number. Since that counter is updated on tx dequeue, the A-MPDU flag
> needs to be up to date at the tme of dequeue as well.
>
> This patch prevents sending more A-MPDU frames after the session has
> been terminated and also ensures that aggregation starts right after the
> session has been established

Makes sense. Suppose there's no reason why the session couldn't be
started/ended while packets were queued.

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
