Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48742 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874AbYD3VAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 17:00:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT 0/4] mac80211 QoS-related enhancements
Date: Wed, 30 Apr 2008 22:59:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <20080430124055.091382000@sipsolutions.net> <1209560849.18659.1.camel@johannes.berg>
In-Reply-To: <1209560849.18659.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804302259.47950.mb@bu3sch.de> (sfid-20080430_230009_713472_1970555C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 April 2008 15:07:29 Johannes Berg wrote:
> 
> > Any testing of this series is welcome, even just the first patch by itself
> > (especially with drivers other than b43), it doesn't make sense to test with
> > patch 2 and not 3 though, so if you're going to test one by one treat 2/3 as
> > a set.
> 
> I have, of course, tested this series with b43 (and founds dozens of
> bugs...) Michael, thanks for your dma overflow injection feature :)

:)

> One thing that turned up was that if I enable dma overflow with this
> patchset then b43 hardware spews lots of PHY TX errors. I have verified
> that the ieee80211_tx_control info is correct, and the frame data is
> also fine, so I'm not sure what's up there. Could that be unrelated to
> this patch? I haven't tested dma overflow injection w/o this series yet.

Hm, not sure. It could be a b43 bug, of course. But last time I tested
the overflow injection, it worked fine. And that's not too long ago.
Probably 3 or 4 weeks. Of course, we should test this again with the QOS
patch applied and removed now. If that patch does actually trigger it,
then we probably still need to search for a b43 bug.
Is the QOS callback (forgot its name) called when we have an overflow?

-- 
Greetings Michael.
