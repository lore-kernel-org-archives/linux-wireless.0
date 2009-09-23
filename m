Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:47590 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZIWX23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 19:28:29 -0400
Received: by iwn8 with SMTP id 8so625388iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 16:28:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090923225853.GA14625@jm.kir.nu>
References: <43e72e890909221541u67fa291fq353327d1d55841f2@mail.gmail.com>
	<20090923225853.GA14625@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Sep 2009 16:28:12 -0700
Message-ID: <43e72e890909231628g340f1467ka5c02515b051285b@mail.gmail.com>
Subject: Re: Flush TX - wireless summit topic
To: Jouni Malinen <j@w1.fi>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 3:58 PM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Sep 22, 2009 at 03:41:50PM -0700, Luis R. Rodriguez wrote:
>> Another thing we spoke about at the wireless summit was flushing TX
>> prior to changing channel / scan. Bob, remember the issue with ath5k
>> on the band not coinciding on received skbs since we don't do a DMA RX
>> flush prior to channel change? Well one theory discussed was that we
>> would see that issue disappear if we actually did a proper TX flush
>> prior to channel change since we expect we would not see further
>> incoming frames from our AP if we told it we were going to PS (sending
>> a null func frame). If we implement a proper TX flush then the theory
>> goes that we wouldn't need to do any sort of DMA flush as we would not
>> have any frames pending.
>
> I don't know where this theory is coming from, but I do not subscribe to
> it ;-).

I misunderstood you then, sorry about that.

> The AP may very well send broadcast frames even after we
> indicate the change to PS mode. In addition, other frames could
> potentially be received based on RX filter settings. If we want to make
> sure we do not get new pending RX frames, we need to stop the receiver
> first or be prepared to handle the received frames somehow.

Thanks for the clarification.

> The number of pending RX frames would hopefully be relatively small,
> though, in this kind of case.

Indeed.

> In order to process these frames
> correctly, they would need to be taken care of prior to the channel
> change or alternatively, with the channel parameters cached in the
> driver so that they could be sent up with all the correct information
> even after the channel change.

I'm inclined for mac80211 to force an rxflush here so that we force
all drivers to do the right thing and we'd document this as such,
instead of having to rely on each driver doing the right thing
(caching the channel for the RX'f frame). The downside to this is
obviously this can create a delay on channel change, however long it
takes to process the pending frames already sitting for us on the
DMA'd memory.

  Luis
