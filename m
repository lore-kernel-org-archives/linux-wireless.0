Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40777 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaCRWUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 18:20:51 -0400
Message-ID: <5328C6A8.5000002@candelatech.com> (sfid-20140318_232054_729442_1B328FA1)
Date: Tue, 18 Mar 2014 15:20:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Stuck packet in ath10k
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been debugging tx flush issues in ath10k.  It seems that
quite often a packet is not flushed within the 3-second timeout,
but sometimes it may be flushed later if one is patient.

I printed out one of the packets in hex, but it does not appear to
have any data, and I'm getting confused trying to decode it by hand.
(Would be lovely if wireshark would let one type in a packet in hex
and then decode it!)

48 01 00 00        # ??
04 f0 21 03 38 99  # Addr of AP
00 f0 21 0e 02 fe  # Addr of sending station
04 f0 21 03 38 99  # Addr of AP
00 11              # Seq number?


Anyone know what this packet is and/or have an idea why it would take
a long time to be dealt with by the firmware?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

