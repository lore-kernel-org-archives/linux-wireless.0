Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:50661 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbZASXch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:32:37 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Tue, 20 Jan 2009 00:32:42 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <49750494.8000408@gmail.com> <497509F9.4010003@gmail.com>
In-Reply-To: <497509F9.4010003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901200032.42202.chunkeey@web.de> (sfid-20090120_003241_535715_C2A18985)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 20 January 2009 00:17:13 Artur Skawina wrote:
> Artur Skawina wrote:
> > Christian Lamparter wrote:
> >> On Monday 19 January 2009 22:53:03 Artur Skawina wrote:
> >>> We can move the FREE_AFTER_TX(skb) check from the completion to the submission
> >>> path, right? Then find a way to do the pull _before_ giving away the skbs.
> >>> I can't shutdown the machine where i can reproduce this today, so it will have
> >>> to wait until at least tomorrow.
> >>>
> >>> artur
> >> Like this?
> >>
> > yes, that's what i was thinking. Will FREE_AFTER_TX(skb) be false for all skbs
> > that are dropped in p54_rx_frame_sent()?
Not exactly, but it's the right direction. FREE_AFTER_TX is true for _setting_ control frames... e.g frequency/filter/dcf. 

> > Also most of the push/pull business in completions can probably go, we just have to set
> > up the pointers right on submission, ie transfer the rx header into the headroom, then
> > no skb manipulations in completions should be needed, and these kind of races should
> > be harmless.
> 
> I only looked at the FREE_AFTER_TX(skb) part and completely missed that you had already
> removed the pull, sorry.
Yeah, this will make life easier for the "stuck package" detection...
Although, I'll miss the skb_push & skb_pull checks. But that's a small price, 
if your device finally works. (Well "works" is maybe a bit too much, 
as you'll probably run into other bugs, e.g truesize bug or the "shot rc", or
more problems with powersaving station that only have apsd).

Regards,
	Chr
