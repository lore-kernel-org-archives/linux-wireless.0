Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38185 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbcGLKJb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 06:09:31 -0400
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	=?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Subject: TCP performance regression in mac80211 triggered by the fq code
Message-ID: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name> (sfid-20160712_120936_281302_9587C1C3)
Date: Tue, 12 Jul 2016 12:09:24 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

With Toke's ath9k txq patch I've noticed a pretty nasty performance
regression when running local iperf on an AP (running the txq stuff) to
a wireless client.

Here's some things that I found:
- when I use only one TCP stream I get around 90-110 Mbit/s
- when running multiple TCP streams, I get only 35-40 Mbit/s total
- fairness between TCP streams looks completely fine
- there's no big queue buildup, the code never actually drops any packets
- if I put a hack in the fq code to force the hash to a constant value
(effectively disabling fq without disabling codel), the problem
disappears and even multiple streams get proper performance.

Please let me know if you have any ideas.

- Felix
