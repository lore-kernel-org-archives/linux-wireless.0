Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:46637 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZASSPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 13:15:13 -0500
Received: by nf-out-0910.google.com with SMTP id d3so430453nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 10:15:12 -0800 (PST)
Message-ID: <4974C32D.4030802@gmail.com> (sfid-20090119_191520_000770_7843B7E0)
Date: Mon, 19 Jan 2009 19:15:09 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <497105D1.5040906@gmail.com> <4973BAC6.5020502@gmail.com> <200901190126.58392.chunkeey@web.de>
In-Reply-To: <200901190126.58392.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Monday 19 January 2009 00:27:02 Artur Skawina wrote:
>> Artur Skawina wrote:
>>> didn't trigger anything here, just the usual:
>>>
>>> BUG kmalloc-4096: Poison overwritten

>> This is almost 100% reproducible; sometimes the machine freezes instead.

Here's an interesting sequence:

1) a TX urb is submitted.
2) p54u_rx_cb() => p54_rx_frame_sent(), which does kfree_skb( the_skb_in_(1) ).
3) p54u_tx_cb() for (1) is called with the same, now freed, skb. kaboom.

IOW the skb is freed before the usb completion runs.

Somehow i don't think this is the reason for the corruption, but it certainly
seems to be responsible for some, if not all, of the crashes/panics.

artur
