Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33309 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbbIXVuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 17:50:06 -0400
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: IBSS and AMSDU on ath10k
Message-ID: <5604700D.6020504@candelatech.com> (sfid-20150924_235030_345857_8BDC0160)
Date: Thu, 24 Sep 2015 14:50:05 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm trying to figure out why IBSS with AMSDU breaks on CT firmware (ath10k).

First, I have no idea if it works on any other firmware....

The problem I see is that the first frame of the AMPDU
has a single frame, and it looks fine and is received up the stack.

Subsequent frames in the AMPDU with 2+ subframes look mostly correct
at first glance, but the 'bssid' as decoded by the stack and sniffer
is 00:00:00:00:00:00, so the stack will not accept it.

I am guessing that frames are either really broken on the air, or
the re-assembly in the ath10k driver is broken.

The same systems in managed mode show proper bssid on the AMSDU
frames, so maybe it really is an on-air issue.

My ath10k sniffer might suffer the same problem, so I'm not actually
certain what is on the air.

The ath9k as sniffer cannot seem to decode any AMSDU frames, even
if the IBSS devices are using HT instead of VHT framerates.

I'm curious if anyone has any suggestions as to how this is supposed
to work.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

