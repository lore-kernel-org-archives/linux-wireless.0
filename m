Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:2300 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZASSxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 13:53:01 -0500
Received: by ug-out-1314.google.com with SMTP id 39so224539ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 10:52:59 -0800 (PST)
Message-ID: <4974CC08.2060402@gmail.com> (sfid-20090119_195309_486731_BEA171B2)
Date: Mon, 19 Jan 2009 19:52:56 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
CC: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <497105D1.5040906@gmail.com> <4973BAC6.5020502@gmail.com> <200901190126.58392.chunkeey@web.de> <4974C32D.4030802@gmail.com>
In-Reply-To: <4974C32D.4030802@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Here's an interesting sequence:
> 
> 1) a TX urb is submitted.
> 2) p54u_rx_cb() => p54_rx_frame_sent(), which does kfree_skb( the_skb_in_(1) ).
> 3) p54u_tx_cb() for (1) is called with the same, now freed, skb. kaboom.
> 
> IOW the skb is freed before the usb completion runs.
> 
> Somehow i don't think this is the reason for the corruption, but it certainly
> seems to be responsible for some, if not all, of the crashes/panics.

Hmm, if it happens for beacons, it's probably also happening for other frames,
which are not freed, but given to ieee80211_tx_status_irqsafe() and that could
explain the corruption. Will verify, but probably not before tomorrow.

artur
