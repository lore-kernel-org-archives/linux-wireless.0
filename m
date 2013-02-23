Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45177 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3BWGqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 01:46:05 -0500
Date: Sat, 23 Feb 2013 00:46:00 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130223064600.GA27187@thinkpad-t410> (sfid-20130223_074615_731372_F9DB479B)
References: <20130222205044.GD1418@thinkpad-t410>
 <201302222307.38229.chunkeey@googlemail.com>
 <20130222225454.GF1418@thinkpad-t410>
 <201302230048.52018.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302230048.52018.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 23, 2013 at 12:48:51AM +0100, Christian Lamparter wrote:
> On Friday 22 February 2013 23:54:54 Seth Forshee wrote:
> > On Fri, Feb 22, 2013 at 11:07:37PM +0100, Christian Lamparter wrote:
> > > About the "frame gets passed down..." thing. Do you know
> > > if this frame is received by the firmware or if it is
> > > stuck in the usb-pipe? (if you have DEBUGFS support, you
> > > can look at tx_ampdu_upload. If it's value stays the same
> > > (that is >= 1. If it drops to 0, then it should be fine)
> > > until the DELBA rolls around, then something is wrong with
> > > the USB BUS). 
> > 
> > tx_ampdu_upload is one of the things I was monitoring. In one example,
> > frames with sequence numbers 1282 - 1286 are put in the tx_pending
> > queue, increasing tx_ampdu_upload to 5. All 5 frames are passed to
> > carl9170_usb_tx() (this is what I mean when I say the frame gets passed
> > down), but only the first 4 are transmitted, and tx_ampdu_upload
> > decrements down to 1. It stays at 1 until the DELBA comes, at which
> > point it finally gets transmitted and tx_ampdu_upload decrements to 0.
> > So it sounds like there's a USB bus problem. I've verified that this
> > problem shows up on multiple machines.
> 
> Thanks.
> 
> So it looks like we need to ask whenever the USB transport
> is reliable or not. Did you (by any change) also monitor
> "usb_tx_anch_urbs" [And does it get stuck at some > 1 value
> as well?]. I'm asking this because if the driver has more than
> 8 (=AR9170_NUM_TX_URBS) concurrently outgoing URBs, the 
> overflow is queued in tx_wait. Of course, the urb completion
> handler (carl9170_usb_tx_data_complete) takes care of
> delivering the next frame in the tx_wait line and so on...
> But according to your report, this doesn't seem to work!
> What's a bit odd is that the device is able to recover. Because 
> normally if there is an USB error, the endpoint will halt and
> no traffic will get through it anymore [So the DELBA should be
> stuck as well!].

The carl9170 usb code seems to be working properly. If tx_anch_urbs
reaches 8 the overflow is queued in tx_wait as you said, and the next
queued frame gets delivered from carl9170_usb_tx_data_complete(). The
stuck frame does get passed to a successful usb_submit_urb() call before
tx stops, but it still isn't transmitted until the DELBA comes along
(and tx_anch_urbs decrements to 1 and then gets stuck there while tx is
stalled, as would be expected).

> When you were testing this at a different machine, did you
> use the same cable/hub? Or did you plug it into the USB
> port directly?

In both cases the adapter was plugged directly into the machine's USB
ports.

> BTW: Is this a DWA-160 REV A1 or A2?

A2

Thanks,
Seth
