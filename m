Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39858 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbcADTAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 14:00:30 -0500
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: VHT 20Mhz, MCS 9 RX rate reported by (my) ath10k
Message-ID: <568AC14D.4000102@candelatech.com> (sfid-20160104_200033_510932_8E6D2D56)
Date: Mon, 4 Jan 2016 11:00:29 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While trying to track down some funny results from 'iw station dump',
I find that my ath10k NIC is occasionally reporting MCS 9, 20Mhz bandwidth,
which I guess must be an invalid rate.

This is with non-stock firmware and patched driver, but I have mostly messed
with the TX rate reporting, not RX rate, so I'm not sure this is a local
issue.

Previously, I have also verified that ath10k can send and receive CCK rates
on 5Ghz, which is also evidently not supposed to be valid, so I'm suspicious
that maybe it can do MCS 9 at 20Mhz as well.  Or, maybe it is just reporting
bogus values.

Either way, I'd like it to do better than show a zero rate in the
station dump.  Any suggestions for the least-bad way to report a
non-zero rate when I have a NIC reporting this rate info?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

