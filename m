Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43727 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbeHBVia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 17:38:30 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: use-after free bug in hacked 4.16 kernel, related to fq_flow_dequeue
In-Reply-To: <a5e579a2-5c20-5438-83c6-1eb5ae3e5630@candelatech.com>
References: <a5e579a2-5c20-5438-83c6-1eb5ae3e5630@candelatech.com>
Date: Thu, 02 Aug 2018 21:45:55 +0200
Message-ID: <87in4sy2ks.fsf@toke.dk> (sfid-20180802_214605_093557_531778B9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> This is from my hacked kernel, could be my fault. I thought the fq
> guys might want to know however...

Hmm, nothing obvious comes to mind; fq_flow_dequeue() just dequeues a
packet from the queue; it only has two memory derefs, to fq->lock and
flow->queue. Don't see why either of those should be freed at this
point.

Unless fq_adjust_removal() is being inlined, perhaps? Then I suppose the
flow->tin reference could be the problem, if the txq_info struct was
already freed; did you change anything around the handling of TXQs?

-Toke
