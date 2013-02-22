Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab3BVUut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:50:49 -0500
Date: Fri, 22 Feb 2013 14:50:44 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: carl9170 A-MPDU transmit problem
Message-ID: <20130222205044.GD1418@thinkpad-t410> (sfid-20130222_215054_661659_32116D24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

I was given a D-Link wireless dongle by a colleague who said he was
having trouble with the connection stalling. One thing I noticed right
away when running iperf is that the tx BA sessions seem to be getting
stopped and restarted pretty frequently. I've been doing some debugging,
and here's what I'm seeing.

On the air everything seems to go smoothly for a while, but then the
D-Link adapter stops transmitting data frames for a while. It still
sends CTS and BA frames in response to the AP, just no data frames.
Eventually it sends the action frame with the DELBA request, but
immediately before sending the action frame it sends a single data
frame. This pattern repeats each time this happens.

That final data frame is a bit curious, so I added some tracing to
carl9170. It looks like this frame gets passed down to the hardware as
the last in a batch of A-MPDU frames, but for some reason the hardware
stops transmitting without sending this frame. carl9170 doesn't pass any
more A-MPDU frames to the hardware while tx for that frame is pending,
and when the action frame for the DELBA request finally comes along it
seems to get things moving again.

Do you have any idea what might be causing the hardware to stop
transmitting with one frame left? Any suggestions on how to fix it?

Thanks,
Seth

