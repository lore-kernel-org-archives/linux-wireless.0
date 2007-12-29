Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:24095 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbXL2O25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 09:28:57 -0500
Received: by nf-out-0910.google.com with SMTP id g13so307994nfb.21
        for <linux-wireless@vger.kernel.org>; Sat, 29 Dec 2007 06:28:55 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sat, 29 Dec 2007 15:29:09 +0100
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200712291247.54258.IvDoorn@gmail.com> <1198929568.4172.37.camel@johannes.berg>
In-Reply-To: <1198929568.4172.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712291529.10357.IvDoorn@gmail.com> (sfid-20071229_142904_886582_157B4102)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 December 2007, Johannes Berg wrote:
> 
> > but since the payload should be aligned to a 4 byte boundrary anyway
> 
> That's not true. The "payload" in terms of "802.11 frame" shouldn't be
> aligned on a four-byte boundary for QoS or 4-addr frames.
> 
> > can't predict what header length the frame will contain. :(
> 
> Well, good hardware inserts padding, cf.
> http://bcm-v4.sipsolutions.net/802.11/RX
> 
> > Although it would safe the initial allocation of the DMA buffer...
> > I'll look into it to see if it would be useful.
> 
> More importantly, it'd save you the copy if your hardware is decent and
> inserts two bytes padding for QoS/WDS frames.

Well Ralink doesn't seem to add this padding since this bug appeared,
remember all bytes from the DMA was copied to the skb buffer so if there
was any padding included it would have been copied as well. ;)

Anyway, I have worked on a fix for the padding and I'll commit it to
rt2x00.git first to see if anybody reports any problems with it before
sending it to wireless-dev.

Same goes for letting the device copy the data into the skb buffer directly. :)

Ivo
