Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46617 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3BVXs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 18:48:57 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so568160eek.14
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2013 15:48:56 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: carl9170 A-MPDU transmit problem
Date: Sat, 23 Feb 2013 00:48:51 +0100
Cc: linux-wireless@vger.kernel.org
References: <20130222205044.GD1418@thinkpad-t410> <201302222307.38229.chunkeey@googlemail.com> <20130222225454.GF1418@thinkpad-t410>
In-Reply-To: <20130222225454.GF1418@thinkpad-t410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302230048.52018.chunkeey@googlemail.com> (sfid-20130223_004900_994927_EF73A826)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 22 February 2013 23:54:54 Seth Forshee wrote:
> On Fri, Feb 22, 2013 at 11:07:37PM +0100, Christian Lamparter wrote:
> > About the "frame gets passed down..." thing. Do you know
> > if this frame is received by the firmware or if it is
> > stuck in the usb-pipe? (if you have DEBUGFS support, you
> > can look at tx_ampdu_upload. If it's value stays the same
> > (that is >= 1. If it drops to 0, then it should be fine)
> > until the DELBA rolls around, then something is wrong with
> > the USB BUS). 
> 
> tx_ampdu_upload is one of the things I was monitoring. In one example,
> frames with sequence numbers 1282 - 1286 are put in the tx_pending
> queue, increasing tx_ampdu_upload to 5. All 5 frames are passed to
> carl9170_usb_tx() (this is what I mean when I say the frame gets passed
> down), but only the first 4 are transmitted, and tx_ampdu_upload
> decrements down to 1. It stays at 1 until the DELBA comes, at which
> point it finally gets transmitted and tx_ampdu_upload decrements to 0.
> So it sounds like there's a USB bus problem. I've verified that this
> problem shows up on multiple machines.

Thanks.

So it looks like we need to ask whenever the USB transport
is reliable or not. Did you (by any change) also monitor
"usb_tx_anch_urbs" [And does it get stuck at some > 1 value
as well?]. I'm asking this because if the driver has more than
8 (=AR9170_NUM_TX_URBS) concurrently outgoing URBs, the 
overflow is queued in tx_wait. Of course, the urb completion
handler (carl9170_usb_tx_data_complete) takes care of
delivering the next frame in the tx_wait line and so on...
But according to your report, this doesn't seem to work!
What's a bit odd is that the device is able to recover. Because 
normally if there is an USB error, the endpoint will halt and
no traffic will get through it anymore [So the DELBA should be
stuck as well!].

When you were testing this at a different machine, did you
use the same cable/hub? Or did you plug it into the USB
port directly?

BTW: Is this a DWA-160 REV A1 or A2?

Regards,
	Christian
