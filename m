Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50705 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3BVWHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 17:07:44 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so545240eek.20
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2013 14:07:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: carl9170 A-MPDU transmit problem
Date: Fri, 22 Feb 2013 23:07:37 +0100
Cc: linux-wireless@vger.kernel.org
References: <20130222205044.GD1418@thinkpad-t410>
In-Reply-To: <20130222205044.GD1418@thinkpad-t410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302222307.38229.chunkeey@googlemail.com> (sfid-20130222_230748_496519_7E7EEDE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Seth,

On Friday 22 February 2013 21:50:44 Seth Forshee wrote:
> I was given a D-Link wireless dongle by a colleague who said he was
> having trouble with the connection stalling. One thing I noticed right
> away when running iperf is that the tx BA sessions seem to be getting
> stopped and restarted pretty frequently. I've been doing some debugging,
> and here's what I'm seeing.
> 
> On the air everything seems to go smoothly for a while, but then the
> D-Link adapter stops transmitting data frames for a while. It still
> sends CTS and BA frames in response to the AP, just no data frames.
> Eventually it sends the action frame with the DELBA request, but
> immediately before sending the action frame it sends a single data
> frame. This pattern repeats each time this happens.
> 
> That final data frame is a bit curious, so I added some tracing to
> carl9170. It looks like this frame gets passed down to the hardware as
> the last in a batch of A-MPDU frames, but for some reason the hardware
> stops transmitting without sending this frame. carl9170 doesn't pass any
> more A-MPDU frames to the hardware while tx for that frame is pending,
> and when the action frame for the DELBA request finally comes along it
> seems to get things moving again.
> 
> Do you have any idea what might be causing the hardware to stop
> transmitting with one frame left? Any suggestions on how to fix it?
Do you also see messages like "invalid plcp cck rate.",
"rx stream does not start with a first_mpdu frame tag." and/or
"plcp info/frame tail is clipped" or messages about "driver
reset"?

Can you tell me what version firmware are you using? 
If your driver is up to date, you could try the 
firmware attached to:
<https://bugzilla.redhat.com/show_bug.cgi?id=831953>

About the "frame gets passed down..." thing. Do you know
if this frame is received by the firmware or if it is
stuck in the usb-pipe? (if you have DEBUGFS support, you
can look at tx_ampdu_upload. If it's value stays the same
(that is >= 1. If it drops to 0, then it should be fine)
until the DELBA rolls around, then something is wrong with
the USB BUS). 

Note: Unfortunately, Control frames (BA + CTS + ACK)
don't share the tx queues with DATA or MGMT frames. 
These frames are generated within the bowls of the
hardware MAC and they take "short paths" through
the tx arbiter (this is all done in the silicon).
[However, if you filter the monitor dumps again, you
could look for nullfuncs or Probe Requests originating 
from the device. These should be a good indication 
whenever the hardware or the driver is on the fritz.]

Note2: It's too early to tell anything yet ;-)
But just in case you are planning to test the latest
wireless-testing.git or compat-driver: Here's a patch
which was just posted:
<http://www.spinics.net/lists/linux-wireless/msg103866.html>
It sorts out a disagreement between carl9170 and the
latest minstrel_ht changes. Without it, you'll definitely
get a very choppy connection (lots of WARNings and frame
drop).

Regards,
	Christian
