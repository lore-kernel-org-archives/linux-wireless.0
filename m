Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f32.google.com ([209.85.219.32]:46959 "EHLO
	mail-ew0-f32.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZATUSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 15:18:54 -0500
Received: by ewy13 with SMTP id 13so643685ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 12:18:51 -0800 (PST)
Message-ID: <497631A8.9030903@gmail.com> (sfid-20090120_211857_670111_0A2F4D8C)
Date: Tue, 20 Jan 2009 21:18:48 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <49750494.8000408@gmail.com> <497509F9.4010003@gmail.com> <200901200032.42202.chunkeey@web.de>
In-Reply-To: <200901200032.42202.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Tuesday 20 January 2009 00:17:13 Artur Skawina wrote:
>> Artur Skawina wrote:
>>> yes, that's what i was thinking. Will FREE_AFTER_TX(skb) be false for all skbs
>>> that are dropped in p54_rx_frame_sent()?
> Not exactly, but it's the right direction. FREE_AFTER_TX is true for _setting_ control frames... e.g frequency/filter/dcf. 

Which means "yes", i guess. Because if it were ever to be true the race would
reappear, and given how hard it was to reproduce, i'd rather not take any 
chances (in all the testing i hit the BUG in skb_pull only twice).

> if your device finally works. (Well "works" is maybe a bit too much, 
> as you'll probably run into other bugs, e.g truesize bug or the "shot rc", or
> more problems with powersaving station that only have apsd).

It seems to work quite well, i'm seeing the occasional truesize warning and
haven't yet figured out why the client won't reconnect before hostapds
ap_max_inactivity timeout triggers, but other than that everything seems fine.

Thanks,

artur
