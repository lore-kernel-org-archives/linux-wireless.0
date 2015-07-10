Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38441 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbGJAEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 20:04:00 -0400
Message-ID: <559F0BEF.4000808@candelatech.com> (sfid-20150710_020403_826511_AB49F605)
Date: Thu, 09 Jul 2015 17:03:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: How is AP supposed to handle power-save packets from peer?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Suppose one is doing heavy download (AP -> peer traffic), and there are lots of frames in the
NIC's tx buffers (ath10k firmware, in this case).

Then, peer sends a power-save pkt telling AP it is going off-channel or otherwise
will be unavailable.

What is the appropriate behaviour from the AP?  Can the firmware just drop all those tx frames to
make room to handle other stations?  Maybe report ACK failure and hope the upper level stacks
retransmit as appropriate?

Or, is the host supposed to flush the peer's packets to clear out the frames?

Or, is firmware somehow supposed to keep all the frames for when the peer comes back?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

