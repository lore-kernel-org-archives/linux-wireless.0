Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36520 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZKKEHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 23:07:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 20:07:16 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19194.14583.795686.199320@gargle.gargle.HOWL>
Date: Wed, 11 Nov 2009 09:39:27 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Aeolus Yang <Aeolus.Yang@Atheros.com>
Subject: Oops on ath_txq_schedule() hit a BUG_ON()
In-Reply-To: <43e72e890911101606j46e1edfn64e331f3463d4da5@mail.gmail.com>
References: <43e72e890911101606j46e1edfn64e331f3463d4da5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> I managed to get an oops the 2.6.32-rc wireless bits on ath9k by using
> linux-backports-modules package on Ubuntu 9.10 which is on 2.6.31. I'm
> pretty sure this is a real oops which can be reproduced on 2.6.32-rc6
> but I was unable to boot the same laptop on 2.6.32-rc6 [1] due to an
> early oops on what seems to be i915.
> 
> The EIP is at ath_txq_schedule() but the oops happens due to a
> BUG_ON() (used to be ASSERT()) on this piece of code:

I have seen this once, and I have a backtrace.

> This happens against an 802.11n AP, the WRT610n with 802.11n enabled.
> The AP has this option to let you enable "only 802.11n", whatever that
> means, its on the 2.4 GHz so I doubt the "only 802.11n" option is not
> really only enabling 802.11n.

Pure 11n is not needed, it can be reproduced with any 11n AP.
A suspend/resume cycle exposes this issue occasionally.

> This was with SpeedStep enabled, the power pulled off and doing iperf
> UDP out (TX'ing). Haven't managed to find what makes the assumption
> incorrect yet but it obviously is. If we cannot find what it is soon
> we need to figure out a compromise and change it to a WARN_ONCE or so.

This issue is irrelevant to SpeedStep.
The tx_buf array of pointers has to be cleaned up a bit.

Sujith
