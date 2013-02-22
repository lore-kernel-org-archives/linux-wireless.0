Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324Ab3BVWy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 17:54:59 -0500
Date: Fri, 22 Feb 2013 16:54:54 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130222225454.GF1418@thinkpad-t410> (sfid-20130222_235503_668894_2C6C609B)
References: <20130222205044.GD1418@thinkpad-t410>
 <201302222307.38229.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302222307.38229.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 22, 2013 at 11:07:37PM +0100, Christian Lamparter wrote:
> Hello Seth,
> 
> On Friday 22 February 2013 21:50:44 Seth Forshee wrote:
> > I was given a D-Link wireless dongle by a colleague who said he was
> > having trouble with the connection stalling. One thing I noticed right
> > away when running iperf is that the tx BA sessions seem to be getting
> > stopped and restarted pretty frequently. I've been doing some debugging,
> > and here's what I'm seeing.
> > 
> > On the air everything seems to go smoothly for a while, but then the
> > D-Link adapter stops transmitting data frames for a while. It still
> > sends CTS and BA frames in response to the AP, just no data frames.
> > Eventually it sends the action frame with the DELBA request, but
> > immediately before sending the action frame it sends a single data
> > frame. This pattern repeats each time this happens.
> > 
> > That final data frame is a bit curious, so I added some tracing to
> > carl9170. It looks like this frame gets passed down to the hardware as
> > the last in a batch of A-MPDU frames, but for some reason the hardware
> > stops transmitting without sending this frame. carl9170 doesn't pass any
> > more A-MPDU frames to the hardware while tx for that frame is pending,
> > and when the action frame for the DELBA request finally comes along it
> > seems to get things moving again.
> > 
> > Do you have any idea what might be causing the hardware to stop
> > transmitting with one frame left? Any suggestions on how to fix it?
> Do you also see messages like "invalid plcp cck rate.",
> "rx stream does not start with a first_mpdu frame tag." and/or
> "plcp info/frame tail is clipped" or messages about "driver
> reset"?

No, none of these messages.

> Can you tell me what version firmware are you using? 

usb 3-3: firmware API: 1.9.6 2012-07-07

> If your driver is up to date, you could try the 
> firmware attached to:
> <https://bugzilla.redhat.com/show_bug.cgi?id=831953>

This firmware exhibits the same behavior.

> About the "frame gets passed down..." thing. Do you know
> if this frame is received by the firmware or if it is
> stuck in the usb-pipe? (if you have DEBUGFS support, you
> can look at tx_ampdu_upload. If it's value stays the same
> (that is >= 1. If it drops to 0, then it should be fine)
> until the DELBA rolls around, then something is wrong with
> the USB BUS). 

tx_ampdu_upload is one of the things I was monitoring. In one example,
frames with sequence numbers 1282 - 1286 are put in the tx_pending
queue, increasing tx_ampdu_upload to 5. All 5 frames are passed to
carl9170_usb_tx() (this is what I mean when I say the frame gets passed
down), but only the first 4 are transmitted, and tx_ampdu_upload
decrements down to 1. It stays at 1 until the DELBA comes, at which
point it finally gets transmitted and tx_ampdu_upload decrements to 0.

So it sounds like there's a USB bus problem. I've verified that this
problem shows up on multiple machines.

> Note: Unfortunately, Control frames (BA + CTS + ACK)
> don't share the tx queues with DATA or MGMT frames. 
> These frames are generated within the bowls of the
> hardware MAC and they take "short paths" through
> the tx arbiter (this is all done in the silicon).
> [However, if you filter the monitor dumps again, you
> could look for nullfuncs or Probe Requests originating 
> from the device. These should be a good indication 
> whenever the hardware or the driver is on the fritz.]
> 
> Note2: It's too early to tell anything yet ;-)
> But just in case you are planning to test the latest
> wireless-testing.git or compat-driver: Here's a patch
> which was just posted:
> <http://www.spinics.net/lists/linux-wireless/msg103866.html>
> It sorts out a disagreement between carl9170 and the
> latest minstrel_ht changes. Without it, you'll definitely
> get a very choppy connection (lots of WARNings and frame
> drop).

I'm currently testing with 3.8, so the minstrel_ht changes aren't an
issue.

Thanks,
Seth

