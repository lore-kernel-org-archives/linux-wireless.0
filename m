Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:44652 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbcGTOpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 10:45:33 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
Date: Wed, 20 Jul 2016 16:45:28 +0200
In-Reply-To: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name> (Felix Fietkau's
	message of "Tue, 12 Jul 2016 12:09:24 +0200")
Message-ID: <87oa5snzav.fsf@toke.dk> (sfid-20160720_164537_582187_246376A5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> - if I put a hack in the fq code to force the hash to a constant value
> (effectively disabling fq without disabling codel), the problem
> disappears and even multiple streams get proper performance.

There's definitely something iffy about the hashing. Here's the output
relevant line from the aqm debug file after running a single TCP stream
for 60 seconds to that station:

ifname addr tid ac backlog-bytes backlog-packets flows drops marks overlimit collisions
tx-bytes tx-packets
wlp2s0 04:f0:21:1e:74:20 0 2 0 0 146 16 0 0 0 717758966 467925

(there are two extra fields here; I added per-txq CoDel stats, will send
a patch later).

This shows that the txq has 146 flows associated from that one TCP flow.
Looking at this over time, it seems that each time the queue runs empty
(which happens way too often, which is what I was originally
investigating), another flow is assigned.

Michal, any idea why? :)

-Toke
