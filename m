Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:40968 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZASWyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 17:54:16 -0500
Received: by ewy13 with SMTP id 13so651656ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 14:54:14 -0800 (PST)
Message-ID: <49750494.8000408@gmail.com> (sfid-20090119_235420_919859_06BE8EBF)
Date: Mon, 19 Jan 2009 23:54:12 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901191948.57069.chunkeey@web.de> <4974F63F.4050302@gmail.com> <200901192338.09646.chunkeey@web.de>
In-Reply-To: <200901192338.09646.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Monday 19 January 2009 22:53:03 Artur Skawina wrote:
>>>> Here's an interesting sequence:
>>>>
>>>> 1) a TX urb is submitted.
>>>> 2) p54u_rx_cb() => p54_rx_frame_sent(), which does kfree_skb( the_skb_in_(1) ).
>>>> 3) p54u_tx_cb() for (1) is called with the same, now freed, skb. kaboom.
>>>>
>>>> IOW the skb is freed before the usb completion runs.
>>> Well, the sequence should be:
>>>
>>> 1) p54_tx gets called
>>> 1.1) one IRQ urb is submitted
>>> 1.2) one BULK urb is submitted
>>> 2) the firmware acks that it got the urbs
>>> 2.1) p54u_tx_cb is called for the IRQ urb. which frees the small buffer
>>> 2.2) p54u_tx_cb is called for the BULK urb. which only removes the net2280_tx_hdr from the skb.
>>> [time passes]
>>> 3) firmware is finished sending.
>>> 3.1) p54u_rx_cb gets called
>>>        => p54_rx_frame_sent passed the feedback to mac80211
>> That's what one would expect, and is probably why i couldn't see anything
>> wrong in the code despite going over it several times. Until i got a crash
>> which left no doubt as to what happened, and made me notice the "wrong"
>> completion order, log attached [1].
>> In theory, theory and practice do not differ, in practice...
>>
>>>> Somehow i don't think this is the reason for the corruption, but it certainly
>>>> seems to be responsible for some, if not all, of the crashes/panics.
>>> dunno... we should see a bit more fallout, because skb_pull changes skb->data and skb->len. 
>> Doing an skb_pull in p54u_tx_cb on skbs that have already been given to mac80211
>> cannot be good.
>> We can move the FREE_AFTER_TX(skb) check from the completion to the submission
>> path, right? Then find a way to do the pull _before_ giving away the skbs.
>> I can't shutdown the machine where i can reproduce this today, so it will have
>> to wait until at least tomorrow.
>>
>> artur
> 
> Like this?
> 
yes, that's what i was thinking. Will FREE_AFTER_TX(skb) be false for all skbs
that are dropped in p54_rx_frame_sent()?
Also most of the push/pull business in completions can probably go, we just have to set
up the pointers right on submission, ie transfer the rx header into the headroom, then
no skb manipulations in completions should be needed, and these kind of races should
be harmless.
Will test this; it's still possible that what i saw was the result of the tons of
debugging i put into that kernel. But this kind of problem could explain everything
i'm seeing, including the huge packet loss.

Thanks,

artur

