Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:39837 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZASXRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:17:17 -0500
Received: by ewy13 with SMTP id 13so659127ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 15:17:15 -0800 (PST)
Message-ID: <497509F9.4010003@gmail.com> (sfid-20090120_001724_609184_C1CA9FE7)
Date: Tue, 20 Jan 2009 00:17:13 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Artur Skawina <art.08.09@gmail.com>
CC: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901191948.57069.chunkeey@web.de> <4974F63F.4050302@gmail.com> <200901192338.09646.chunkeey@web.de> <49750494.8000408@gmail.com>
In-Reply-To: <49750494.8000408@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina wrote:
> Christian Lamparter wrote:
>> On Monday 19 January 2009 22:53:03 Artur Skawina wrote:
>>> We can move the FREE_AFTER_TX(skb) check from the completion to the submission
>>> path, right? Then find a way to do the pull _before_ giving away the skbs.
>>> I can't shutdown the machine where i can reproduce this today, so it will have
>>> to wait until at least tomorrow.
>>>
>>> artur
>> Like this?
>>
> yes, that's what i was thinking. Will FREE_AFTER_TX(skb) be false for all skbs
> that are dropped in p54_rx_frame_sent()?
> Also most of the push/pull business in completions can probably go, we just have to set
> up the pointers right on submission, ie transfer the rx header into the headroom, then
> no skb manipulations in completions should be needed, and these kind of races should
> be harmless.

I only looked at the FREE_AFTER_TX(skb) part and completely missed that you had already
removed the pull, sorry.

artur
