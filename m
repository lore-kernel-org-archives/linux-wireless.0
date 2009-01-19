Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57287 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZASSsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 13:48:52 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Mon, 19 Jan 2009 19:48:57 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200901190126.58392.chunkeey@web.de> <4974C32D.4030802@gmail.com>
In-Reply-To: <4974C32D.4030802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901191948.57069.chunkeey@web.de> (sfid-20090119_194857_338440_D7D57883)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 January 2009 19:15:09 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Monday 19 January 2009 00:27:02 Artur Skawina wrote:
> >> Artur Skawina wrote:
> >>> didn't trigger anything here, just the usual:
> >>>
> >>> BUG kmalloc-4096: Poison overwritten
> 
> >> This is almost 100% reproducible; sometimes the machine freezes instead.
> 
> Here's an interesting sequence:
> 
> 1) a TX urb is submitted.
> 2) p54u_rx_cb() => p54_rx_frame_sent(), which does kfree_skb( the_skb_in_(1) ).
> 3) p54u_tx_cb() for (1) is called with the same, now freed, skb. kaboom.
> 
> IOW the skb is freed before the usb completion runs.

Well, the sequence should be:

1) p54_tx gets called
1.1) one IRQ urb is submitted
1.2) one BULK urb is submitted
2) the firmware acks that it got the urbs
2.1) p54u_tx_cb is called for the IRQ urb. which frees the small buffer
2.2) p54u_tx_cb is called for the BULK urb. which only removes the net2280_tx_hdr from the skb.
[time passes]
3) firmware is finished sending.
3.1) p54u_rx_cb gets called
       => p54_rx_frame_sent passed the feedback to mac80211

> Somehow i don't think this is the reason for the corruption, but it certainly
> seems to be responsible for some, if not all, of the crashes/panics.
dunno... we should see a bit more fallout, because skb_pull changes skb->data and skb->len. 

Regards,
	Chr
