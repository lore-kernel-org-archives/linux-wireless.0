Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57109 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbbHSLY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 07:24:58 -0400
Message-ID: <1439983495.2089.7.camel@sipsolutions.net> (sfid-20150819_132501_583342_4DCC98F6)
Subject: Re: set channel from radiotap headers during injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Allan Matthew <allanm84@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 19 Aug 2015 13:24:55 +0200
In-Reply-To: <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com> (sfid-20150814_234019_925894_43212D3A)
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
	 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
	 (sfid-20150814_234019_925894_43212D3A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-08-14 at 14:39 -0700, Allan Matthew wrote:
> Anyone have any thoughts on this?
> 
> Is it possible with channel context enabled somehow?
> 

I don't think it's possible - per-packet configuration would have to be
basically instantaneous (cannot sleep etc.) and setting the channel is
necessarily a much longer operation.

If your device supports channel contexts, you might be able to *pick*
the channel you want to inject on, but you could probably achieve that
through the existing MAC address selection that picks an interface.
It's also not clear how monitor + chanctx would work at all, since
monitor expects to be on the channel all the time.

You could possibly select other parameters like the bitrate, but the
channel width - especially 5/10 MHz - doesn't seem feasible.

johannes
